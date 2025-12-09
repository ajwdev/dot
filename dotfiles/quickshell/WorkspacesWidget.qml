import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    spacing: 0

    property int workspaceCount: 4
    property color activeColor: "#0db9d7"
    property color occupiedColor: "#0db9d7"
    property color emptyColor: "#444b6a"
    property color activeIndicatorColor: "#ad8ee6"
    property color backgroundColor: "#1a1b26"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    Item { width: 8 }

    Repeater {
        model: workspaceCount

        Rectangle {
            Layout.preferredWidth: 20
            Layout.fillHeight: true
            color: "transparent"

            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: workspace !== null

            Text {
                text: index + 1
                color: parent.isActive ? activeColor : (parent.hasWindows ? occupiedColor : emptyColor)
                font.pixelSize: fontSize
                font.family: fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            Rectangle {
                width: 20
                height: 3
                color: parent.isActive ? activeIndicatorColor : backgroundColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}
