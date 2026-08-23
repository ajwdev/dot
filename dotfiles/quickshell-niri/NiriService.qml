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
    // Focused workspace id as a reactive scalar. niri sends incremental
    // WorkspaceActivated events; mutating the workspace objects in place does
    // NOT notify QML bindings (same object identity), so widgets compare against
    // this scalar for the active-highlight instead of reading obj.is_focused.
    property int focusedWorkspaceId: -1
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
        // Clone the map so identity changes and bindings re-evaluate.
        var m = Object.assign({}, windowsById);
        m[win.id] = win;
        windowsById = m;
    }

    function _handleEvent(evt) {
        // Each event is a single-key tagged object.
        if (evt.WorkspacesChanged) {
            var list = evt.WorkspacesChanged.workspaces.slice();
            list.sort((a, b) => (a.idx ?? 0) - (b.idx ?? 0));
            workspaces = list;
            for (var f = 0; f < list.length; f++) {
                if (list[f].is_focused) { focusedWorkspaceId = list[f].id; break; }
            }
        } else if (evt.WorkspaceActivated) {
            var aid = evt.WorkspaceActivated.id;
            var af = evt.WorkspaceActivated.focused;
            if (af) focusedWorkspaceId = aid;
            // Immutable update (fresh objects) so bindings that read the objects
            // also refresh. is_active is per-output; is_focused is global.
            workspaces = workspaces.map(w => Object.assign({}, w, {
                is_active: w.output === (workspaces.find(x => x.id === aid) || {}).output ? (w.id === aid) : w.is_active,
                is_focused: af ? (w.id === aid) : w.is_focused
            }));
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
            var mm = Object.assign({}, windowsById);
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
