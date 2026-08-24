import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// Loaded by CompositorService only when XDG_CURRENT_DESKTOP=Hyprland.
// Keeping this in a separate file means the Quickshell.Hyprland import never
// runs under niri (Loader is lazy — it won't parse this until source is set).
QtObject {
    id: root

    // Unified workspace format: [{id, idx}, ...]. In Hyprland, id === idx.
    readonly property var workspaces: {
        var result = [];
        var vals = Hyprland.workspaces.values;
        for (var i = 0; i < vals.length; i++)
            result.push({id: vals[i].id, idx: vals[i].id});
        return result;
    }

    readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1

    property string title: "Window"
    property string windowClass: ""
    property bool isFloating: false

    // Hyprland: workspace appears in the list only when it has windows.
    function workspaceHasWindows(wsId) {
        return Hyprland.workspaces.values.find(ws => ws.id === wsId) !== undefined;
    }

    function focusWorkspace(idx) {
        Hyprland.dispatch("workspace " + idx);
    }

    property Process _windowProc: Process {
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '{class, initialTitle, title, floating} | @json'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) return;
                try {
                    var info = JSON.parse(data.trim());
                    root.windowClass = info.class || "";
                    var t = info.title || "";
                    var it = info.initialTitle || "";
                    root.title = (it && t && it !== t) ? it + " - " + t : (t || "Window");
                    root.isFloating = info.floating || false;
                } catch (e) {}
            }
        }
        Component.onCompleted: running = true
    }

    property Connections _events: Connections {
        target: Hyprland
        function onRawEvent() { root._windowProc.running = true }
    }

    property Timer _poll: Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: root._windowProc.running = true
    }
}
