import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

Text {
    property string currentLayout: "Tile"
    property color textColor: "#a9b1d6"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    text: currentLayout
    color: textColor
    font.pixelSize: fontSize
    font.family: fontFamily
    font.bold: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5

    // Current layout (Hyprland: dwindle/master/floating)
    Process {
        id: layoutProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    currentLayout = data.trim()
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Event-based updates (instant)
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            layoutProc.running = true
        }
    }

    // Backup timer (catches edge cases)
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            layoutProc.running = true
        }
    }
}
