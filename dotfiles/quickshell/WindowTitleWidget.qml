import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 8
    Layout.fillWidth: true
    Layout.leftMargin: 8

    property color textColor: "#ad8ee6"
    property color iconColor: "#7aa2f7"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    readonly property string windowClass: CompositorService.focusedAppId
    readonly property string windowTitle: CompositorService.focusedTitle !== "" ? CompositorService.focusedTitle : "Window"

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
        if (iconMap[lower]) return iconMap[lower];
        for (var key in iconMap) {
            if (lower.includes(key)) return iconMap[key];
        }
        return "";
    }

    Text {
        text: getIcon(windowClass)
        color: iconColor
        font.pixelSize: fontSize + 2
        font.family: fontFamily
        visible: text !== ""
    }

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
