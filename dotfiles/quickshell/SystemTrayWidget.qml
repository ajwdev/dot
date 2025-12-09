import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    spacing: 8

    property int iconSize: 16
    property color attentionColor: "#f7768e"
    property color backgroundColor: "#1a1b26"
    property var parentWindow: null

    Repeater {
        model: SystemTray.items.values

        Item {
            id: trayItem
            required property var modelData

            Layout.preferredWidth: iconSize
            Layout.preferredHeight: iconSize

            // Tray icon
            Image {
                id: trayIcon
                anchors.centerIn: parent
                width: iconSize
                height: iconSize
                source: modelData.icon
                smooth: true
            }

            // Attention indicator (red dot for notifications)
            Rectangle {
                visible: modelData.status === Status.NeedsAttention
                anchors {
                    horizontalCenter: parent.right
                    verticalCenter: parent.top
                }
                width: 6
                height: 6
                radius: 3
                color: attentionColor
                border.color: backgroundColor
                border.width: 1
            }

            // Mouse interaction
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: (mouse) => {
                    // Get the global position for menu display
                    var pos = mapToItem(null, mouse.x, mouse.y);

                    switch (mouse.button) {
                        case Qt.LeftButton:
                            // Left click - activate (default action) or show menu if only menu
                            if (modelData.onlyMenu && modelData.hasMenu) {
                                modelData.display(parentWindow, pos.x, pos.y);
                            } else {
                                modelData.activate();
                            }
                            break;
                        case Qt.RightButton:
                            // Right click - show menu if available, otherwise activate
                            if (modelData.hasMenu) {
                                modelData.display(parentWindow, pos.x, pos.y);
                            } else {
                                modelData.activate();
                            }
                            break;
                        case Qt.MiddleButton:
                            // Middle click - secondary action
                            modelData.secondaryActivate();
                            break;
                    }
                }

                onWheel: (wheel) => {
                    // Scroll action
                    modelData.scroll(wheel.angleDelta.y / 120, false);
                }
            }
        }
    }
}
