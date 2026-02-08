//@ pragma UseQApplication

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland


ShellRoot {
    id: root

    // Reusable separator component
    component Separator: Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: root.colMuted
    }

    // Theme colors
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"

    // Font
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: root.colBg

            margins {
                top: 0
                bottom: 0
                left: 0
                right: 0
            }

            WlrLayershell.layer: WlrLayer.Bottom

            Rectangle {
                anchors.fill: parent
                color: root.colBg

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    WorkspacesWidget {
                        workspaceCount: 4
                        activeColor: root.colCyan
                        occupiedColor: root.colCyan
                        emptyColor: root.colMuted
                        activeIndicatorColor: root.colPurple
                        backgroundColor: root.colBg
                        fontFamily: root.fontFamily
                        fontSize: root.fontSize
                    }

                    Separator {
                        Layout.leftMargin: 8
                    }

                    WindowLayoutWidget {
                        textColor: root.colFg
                        fontFamily: root.fontFamily
                        fontSize: root.fontSize
                    }

                    Separator {
                        Layout.leftMargin: 2
                    }

                    WindowTitleWidget {
                        textColor: root.colPurple
                        iconColor: root.colBlue
                        fontFamily: root.fontFamily
                        fontSize: root.fontSize
                    }

                    SystemTrayWidget {
                        iconSize: root.fontSize
                        attentionColor: root.colRed
                        backgroundColor: root.colBg
                        parentWindow: panelWindow
                        Layout.rightMargin: 8
                    }

                    Separator {}

                    CaffeineToggle {
                        activeColor: root.colYellow
                        inactiveColor: root.colMuted
                        fontFamily: root.fontFamily
                        fontSize: root.fontSize
                        Layout.leftMargin: -8
                    }

                    SystemMetrics {
                        kernelColor: root.colRed
                        cpuColor: root.colYellow
                        memColor: root.colCyan
                        diskColor: root.colBlue
                        separatorColor: root.colMuted
                        fontFamily: root.fontFamily
                        fontSize: root.fontSize
                    }

                    Separator {}

                    VolumeWidget {
                        parentWindow: panelWindow
                    }

                    Separator {}

                    DateTimeWidget {
                        textColor: root.colCyan
                        fontFamily: root.fontFamily
                        fontSize: root.fontSize
                    }

                    Item { width: 8 }
                }
            }
        }
    }

	//  FloatingWindow {
	// 	// match the system theme background color
	// 	color: contentItem.palette.active.window
	//
	// 	ScrollView {
	// 		anchors.fill: parent
	// 		contentWidth: availableWidth
	//
	// 		ColumnLayout {
	// 			anchors.fill: parent
	// 			anchors.margins: 10
	//
	// 			// get a list of nodes that output to the default sink
	// 			PwNodeLinkTracker {
	// 				id: linkTracker
	// 				node: Pipewire.defaultAudioSink
	// 			}
	//
	// 			MixerEntry {
	// 				node: Pipewire.defaultAudioSink
	// 			}
	//
	// 			Rectangle {
	// 				Layout.fillWidth: true
	// 				color: palette.active.text
	// 				implicitHeight: 1
	// 			}
	//
	// 			Repeater {
	// 				model: linkTracker.linkGroups
	//
	// 				MixerEntry {
	// 					required property PwLinkGroup modelData
	// 					// Each link group contains a source and a target.
	// 					// Since the target is the default sink, we want the source.
	// 					node: modelData.source
	// 				}
	// 			}
	// 		}
	// 	}
	// }

}
