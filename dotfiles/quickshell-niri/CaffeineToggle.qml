import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: caffeineRoot
    Layout.preferredWidth: 40
    Layout.fillHeight: true

    property bool enabled: false
    property color activeColor: "#e0af68"
    property color inactiveColor: "#444b6a"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    // Caffeine: prevent idle/sleep
    Process {
        id: caffeineProc
        command: ["systemd-inhibit", "--what=idle:sleep", "--who=Caffeine", "--why=User requested", "sleep", "infinity"]
        running: caffeineRoot.enabled
    }

    Text {
        id: iconText
        text: caffeineRoot.enabled ? "\udb81\udeca" : "\udb83\udfab"
        color: caffeineRoot.enabled ? activeColor : inactiveColor
        font.pixelSize: fontSize + 2
        font.family: fontFamily
        anchors.centerIn: parent
        z: 1
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        z: 2
        onClicked: {
            caffeineRoot.enabled = !caffeineRoot.enabled
        }
    }
}
