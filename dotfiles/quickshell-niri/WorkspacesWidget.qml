import QtQuick
import QtQuick.Layouts

// niri variant: driven by NiriService instead of Quickshell.Hyprland.
// Keeps the fixed 1..N numbered grid; niri workspaces are dynamic/per-output,
// so index maps to niri's workspace `idx` and clicks use `focus-workspace idx`.
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

            // Find the niri workspace whose idx matches this cell (1-based).
            property var workspace: {
                var list = NiriService.workspaces;
                for (var i = 0; i < list.length; i++) {
                    if (list[i].idx === index + 1)
                        return list[i];
                }
                return null;
            }
            property bool isActive: workspace ? workspace.is_focused === true : false
            property bool hasWindows: workspace ? NiriService.workspaceHasWindows(workspace.id) : false

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
                onClicked: NiriService.focusWorkspace(index + 1)
            }
        }
    }
}
