import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

RowLayout {
    spacing: 8
    Layout.fillWidth: true
    Layout.leftMargin: 8

    property string windowClass: ""
    property string windowTitle: "Window"
    property color textColor: "#ad8ee6"
    property color iconColor: "#7aa2f7"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    // Icon mappings (class -> Nerd Font icon)
    property var iconMap: ({
        "kitty": "󰄛",
        "ghostty": "󰊠",
        "com.mitchellh.ghostty": "󰊠",
        "firefox": "󰈹",
        "librewolf": "󰈹",
        "chromium": "󰊯",
        "google-chrome": "󰊯",
        "microsoft-edge": "󰇩",
        "brave": "󰇩",
        "spotify": "󰓇",
        "steam": "󰓓",
        "code": "󰨞",
        "code-oss": "󰨞",
        "blender": "󰂫",
        "obs": "󰐌",
        "thunderbird": "󰇰",
        "slack": "󰒱"
    })

    function getIcon(className) {
        var lower = className.toLowerCase();
        // Try exact match first
        if (iconMap[lower]) return iconMap[lower];
        // Try partial matches
        for (var key in iconMap) {
            if (lower.includes(key)) return iconMap[key];
        }
        // Default icon
        return "";
    }

    // App icon (Nerd Font)
    Text {
        text: getIcon(windowClass)
        color: iconColor
        font.pixelSize: fontSize + 2
        font.family: fontFamily
        visible: text !== ""
    }

    // Window title
    Text {
        text: windowTitle
        color: textColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.fillWidth: true
        elide: Text.ElideRight
        maximumLineCount: 1
    }

    // Active window info
    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '{class, initialTitle, title} | @json'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    try {
                        var info = JSON.parse(data.trim());
                        windowClass = info.class || "";
                        windowTitle = info.initialTitle + " - " + info.title || "Window";
                    } catch (e) {
                        windowTitle = "Wut";
                        windowClass = "";
                    }
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Event-based updates (instant)
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true
        }
    }

    // Backup timer (catches edge cases)
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: {
            windowProc.running = true
        }
    }
}
