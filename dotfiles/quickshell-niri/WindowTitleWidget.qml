import QtQuick
import QtQuick.Layouts
import Quickshell

// niri variant: focused-window title/app-id come from NiriService (niri IPC)
// instead of Hyprland events + hyprctl.
RowLayout {
    spacing: 8
    Layout.fillWidth: true
    Layout.leftMargin: 8

    property color textColor: "#ad8ee6"
    property color iconColor: "#7aa2f7"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    readonly property string windowClass: NiriService.focusedAppId
    readonly property string windowTitle: NiriService.focusedTitle !== "" ? NiriService.focusedTitle : "Window"

    // Icon mappings (app-id -> Nerd Font icon)
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
        if (!className) return "";
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
}
