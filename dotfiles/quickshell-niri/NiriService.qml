pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// niri IPC bridge for the bar. Replaces `Quickshell.Hyprland` (niri has no
// native quickshell module). Reads niri's newline-delimited JSON event stream
// via `niri msg --json event-stream` and exposes reactive state. Auto-restarts
// the stream if niri restarts or the process dies.
Singleton {
    id: root

    // Sorted list of workspace objects: {id, idx, name, output, is_active,
    // is_focused, active_window_id, ...}
    property var workspaces: []
    // id -> window object: {id, title, app_id, workspace_id, is_focused, is_floating}
    property var windowsById: ({})

    property int focusedWindowId: -1
    readonly property var focusedWindow: windowsById[focusedWindowId] ?? null
    readonly property string focusedTitle: focusedWindow ? (focusedWindow.title ?? "") : ""
    readonly property string focusedAppId: focusedWindow ? (focusedWindow.app_id ?? "") : ""
    readonly property bool focusedIsFloating: focusedWindow ? (focusedWindow.is_floating ?? false) : false

    // True if any window lives on the given workspace id.
    function workspaceHasWindows(wsId) {
        for (var k in windowsById) {
            if (windowsById[k].workspace_id === wsId)
                return true;
        }
        return false;
    }

    // Switch to workspace by index (1-based, matching the bar's numbering).
    function focusWorkspace(idx) {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(idx)]);
    }

    function _upsertWindow(win) {
        var m = windowsById;
        m[win.id] = win;
        windowsById = m; // reassign to trigger bindings
    }

    function _handleEvent(evt) {
        // Each event is a single-key tagged object.
        if (evt.WorkspacesChanged) {
            var list = evt.WorkspacesChanged.workspaces.slice();
            list.sort((a, b) => (a.idx ?? 0) - (b.idx ?? 0));
            workspaces = list;
        } else if (evt.WorkspaceActivated) {
            var id = evt.WorkspaceActivated.id;
            var focused = evt.WorkspaceActivated.focused;
            var ws = workspaces.slice();
            for (var j = 0; j < ws.length; j++) {
                if (ws[j].id === id) {
                    ws[j].is_active = true;
                    if (focused) ws[j].is_focused = true;
                } else if (focused) {
                    ws[j].is_focused = false;
                }
            }
            workspaces = ws;
        } else if (evt.WorkspaceActiveWindowChanged) {
            // No direct UI need; focus events cover the title widget.
        } else if (evt.WindowsChanged) {
            var m = {};
            var wins = evt.WindowsChanged.windows;
            for (var w = 0; w < wins.length; w++) {
                m[wins[w].id] = wins[w];
                if (wins[w].is_focused) focusedWindowId = wins[w].id;
            }
            windowsById = m;
        } else if (evt.WindowOpenedOrChanged) {
            var win = evt.WindowOpenedOrChanged.window;
            _upsertWindow(win);
            if (win.is_focused) focusedWindowId = win.id;
        } else if (evt.WindowClosed) {
            var mm = windowsById;
            delete mm[evt.WindowClosed.id];
            windowsById = mm;
            if (focusedWindowId === evt.WindowClosed.id) focusedWindowId = -1;
        } else if (evt.WindowFocusChanged) {
            focusedWindowId = evt.WindowFocusChanged.id ?? -1;
        }
    }

    Process {
        id: streamProc
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                var t = line.trim();
                if (!t) return;
                try {
                    root._handleEvent(JSON.parse(t));
                } catch (e) {
                    // Ignore malformed lines (e.g. the initial handshake).
                }
            }
        }
        onExited: (code, status) => {
            // niri restarted or stream dropped — reconnect shortly.
            reconnect.start();
        }
    }

    Timer {
        id: reconnect
        interval: 1000
        repeat: false
        onTriggered: streamProc.running = true
    }
}
