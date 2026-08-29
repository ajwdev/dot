pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Compositor abstraction for Hyprland and niri. Detects the running compositor
// via XDG_CURRENT_DESKTOP at startup and exposes a unified reactive interface
// for workspaces and focused-window info. Widgets import only this singleton.
//
// Hyprland-specific code lives in HyprlandBridge.qml, loaded lazily via Loader
// so that `import Quickshell.Hyprland` never runs under niri.
Singleton {
    id: root

    readonly property bool isNiri: Quickshell.env("XDG_CURRENT_DESKTOP") === "niri"

    // ── Public API ───────────────────────────────────────────────────────────

    // Workspace list: [{id, idx, ...}, ...], sorted by idx.
    readonly property var workspaces: isNiri ? _niriWorkspaces : (_hyprLoader.item ? _hyprLoader.item.workspaces : [])
    // ID of the focused workspace — compare against workspace.id for highlights.
    readonly property int focusedWorkspaceId: isNiri ? _niriFocusedWsId : (_hyprLoader.item ? _hyprLoader.item.focusedWorkspaceId : -1)
    // Focused window.
    readonly property string focusedTitle: isNiri ? _niriFocusedTitle : (_hyprLoader.item ? _hyprLoader.item.title : "Window")
    readonly property string focusedAppId: isNiri ? _niriFocusedAppId : (_hyprLoader.item ? _hyprLoader.item.windowClass : "")
    readonly property bool focusedIsFloating: isNiri ? _niriFocusedIsFloating : (_hyprLoader.item ? _hyprLoader.item.isFloating : false)
    readonly property bool hasFocusedWindow: isNiri ? (_niriFocusedWinId !== -1) : (_hyprLoader.item ? _hyprLoader.item.windowClass !== "" : false)

    // True if any window lives on the workspace with the given id.
    function workspaceHasWindows(wsId) {
        if (isNiri) {
            for (var k in _niriWindowsById) {
                if (_niriWindowsById[k].workspace_id === wsId)
                    return true;
            }
            return false;
        }
        return _hyprLoader.item ? _hyprLoader.item.workspaceHasWindows(wsId) : false;
    }

    function focusWorkspace(idx) {
        if (isNiri)
            Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(idx)]);
        else if (_hyprLoader.item)
            _hyprLoader.item.focusWorkspace(idx);
    }

    // ── Hyprland (lazy) ──────────────────────────────────────────────────────

    Loader {
        id: _hyprLoader
        source: root.isNiri ? "" : "HyprlandBridge.qml"
    }

    // ── Niri ─────────────────────────────────────────────────────────────────
    // Drives off `niri msg --json event-stream`. Uses a scalar _niriFocusedWsId
    // rather than object.is_focused because niri's incremental events mutate
    // workspace objects in place — QML won't observe same-identity mutations.

    property var _niriWorkspaces: []
    property int _niriFocusedWsId: -1
    property var _niriWindowsById: ({})
    property int _niriFocusedWinId: -1

    readonly property var _niriFocusedWin: _niriWindowsById[_niriFocusedWinId] ?? null
    readonly property string _niriFocusedTitle: _niriFocusedWin ? (_niriFocusedWin.title ?? "") : ""
    readonly property string _niriFocusedAppId: _niriFocusedWin ? (_niriFocusedWin.app_id ?? "") : ""
    readonly property bool _niriFocusedIsFloating: _niriFocusedWin ? (_niriFocusedWin.is_floating ?? false) : false

    function _niriUpsertWindow(win) {
        var m = Object.assign({}, _niriWindowsById);
        m[win.id] = win;
        _niriWindowsById = m;
    }

    function _niriHandleEvent(evt) {
        if (evt.WorkspacesChanged) {
            var list = evt.WorkspacesChanged.workspaces.slice();
            list.sort((a, b) => (a.idx ?? 0) - (b.idx ?? 0));
            _niriWorkspaces = list;
            for (var i = 0; i < list.length; i++) {
                if (list[i].is_focused) { _niriFocusedWsId = list[i].id; break; }
            }
        } else if (evt.WorkspaceActivated) {
            var aid = evt.WorkspaceActivated.id;
            if (evt.WorkspaceActivated.focused) _niriFocusedWsId = aid;
            _niriWorkspaces = _niriWorkspaces.map(w => Object.assign({}, w, {
                is_active: w.output === (_niriWorkspaces.find(x => x.id === aid) || {}).output
                    ? (w.id === aid) : w.is_active,
                is_focused: evt.WorkspaceActivated.focused ? (w.id === aid) : w.is_focused
            }));
        } else if (evt.WindowsChanged) {
            var m = {};
            var wins = evt.WindowsChanged.windows;
            for (var w = 0; w < wins.length; w++) {
                m[wins[w].id] = wins[w];
                if (wins[w].is_focused) _niriFocusedWinId = wins[w].id;
            }
            _niriWindowsById = m;
        } else if (evt.WindowOpenedOrChanged) {
            var win = evt.WindowOpenedOrChanged.window;
            _niriUpsertWindow(win);
            if (win.is_focused) _niriFocusedWinId = win.id;
        } else if (evt.WindowClosed) {
            var mm = Object.assign({}, _niriWindowsById);
            delete mm[evt.WindowClosed.id];
            _niriWindowsById = mm;
            if (_niriFocusedWinId === evt.WindowClosed.id) _niriFocusedWinId = -1;
        } else if (evt.WindowFocusChanged) {
            _niriFocusedWinId = evt.WindowFocusChanged.id ?? -1;
        }
    }

    Process {
        id: niriStream
        command: ["niri", "msg", "--json", "event-stream"]
        running: root.isNiri
        stdout: SplitParser {
            onRead: line => {
                var t = line.trim();
                if (!t) return;
                try { root._niriHandleEvent(JSON.parse(t)); } catch (e) {}
            }
        }
        onExited: if (root.isNiri) niriReconnect.start()
    }

    Timer {
        id: niriReconnect
        interval: 1000
        repeat: false
        onTriggered: niriStream.running = true
    }
}
