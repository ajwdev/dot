import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: volumeWidget
    Layout.rightMargin: 8
    implicitWidth: volumeText.implicitWidth
    implicitHeight: volumeText.implicitHeight

    property int volumeLevel: 0
    property var parentWindow: null

    property var outputDevices: []
    property var inputDevices: []
    property string currentOutput: ""
    property string currentInput: ""
    property bool showPopup: false
    property var activeStreams: []

    Text {
        id: volumeText
        text: "Vol: " + volumeLevel + "%"
        color: Theme.accentPurple
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
    }

    // Volume level (wpctl for PipeWire)
    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    volumeLevel = Math.round(parseFloat(match[1]) * 100)
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Volume adjustment process
    Process {
        id: volAdjustProc
        running: false
    }

    // Timer for periodic updates
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            volProc.running = true
        }
    }

    // Get list of output devices
    Process {
        id: outputDevicesProc
        command: ["sh", "-c", "wpctl status | awk '/Sinks:/,/Sources:/ {if (/│.*[0-9]+\\./) print}'"]
        running: false

        property var deviceList: []

        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) return;
                var line = data.trim();

                if (line.includes('.')) {
                    // Check if line contains asterisk (default device marker)
                    var isDefault = line.includes('*');
                    // Match device ID and name
                    var match = line.match(/(\d+)\.\s+([^\[]+)/);
                    if (match) {
                        var id = match[1];
                        var name = match[2].trim();
                        outputDevicesProc.deviceList.push({id: id, name: name, isDefault: isDefault});
                        if (isDefault) currentOutput = id;
                    }
                }
            }
        }

        onRunningChanged: {
            if (running) {
                deviceList = [];
            } else {
                outputDevices = deviceList;
            }
        }
    }

    // Get list of input devices
    Process {
        id: inputDevicesProc
        command: ["sh", "-c", "wpctl status | sed -n '/^Audio/,/^Video/p' | awk '/Sources:/,/Filters:/ {if (/│.*[0-9]+\\./) print}' | sort"]
        running: false

        property var deviceList: []

        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) return;
                var line = data.trim();

                if (line.includes('.')) {
                    // Check if line contains asterisk (default device marker)
                    var isDefault = line.includes('*');
                    // Match device ID and name
                    var match = line.match(/(\d+)\.\s+([^\[]+)/);
                    if (match) {
                        var id = match[1];
                        var name = match[2].trim();
                        inputDevicesProc.deviceList.push({id: id, name: name, isDefault: isDefault});
                        if (isDefault) currentInput = id;
                    }
                }
            }
        }

        onRunningChanged: {
            if (running) {
                deviceList = [];
            } else {
                inputDevices = deviceList;
            }
        }
    }

    // Get active audio streams (per-app volumes)
    Process {
        id: streamsProc
        command: ["sh", "-c", "wpctl status | sed -n '/Streams:/,/^Video/p' | grep '^[[:space:]]*[0-9]\\+\\.' | grep -v '>' | grep -v 'Audio/' | sort"]
        running: false

        property var streamList: []

        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.trim()) return;
                var line = data.trim();

                // Match stream: "98. Firefox" (exclude channel routing lines with ">")
                var match = line.match(/(\d+)\.\s+(.+)/);
                if (match) {
                    var id = match[1];
                    var name = match[2].trim();
                    streamsProc.streamList.push({id: id, name: name, volume: 100});
                }
            }
        }

        onRunningChanged: {
            if (running) {
                streamList = [];
            } else {
                activeStreams = streamList;
            }
        }
    }

    // Device selection popup - NOT using Loader, direct instantiation
    PopupWindow {
        id: devicePopup
        visible: showPopup

        anchor {
            item: volumeWidget
            rect.y: volumeWidget.height
        }

        implicitWidth: 350
        implicitHeight: 400

        Rectangle {
            id: deviceContent
            anchors.fill: parent
            color: Theme.backgroundColor
            border.color: Theme.borderColor
            border.width: 1
            radius: Theme.radius

            Flickable {
                id: flickable
                anchors.fill: parent
                anchors.margins: 1
                clip: true
                contentHeight: contentColumn.height + 20
                ColumnLayout {
                    id: contentColumn
                    x: 10
                    y: 10
                    width: parent.width - 20
                    spacing: 10

                    // Volume slider section
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.rightMargin: 10
                        spacing: 5

                        Text {
                            text: "Volume: " + volumeLevel + "%"
                            color: Theme.textColor
                            font.pixelSize: Theme.fontSize
                            font.family: Theme.fontFamily
                            font.bold: true
                        }

                        Slider {
                            id: volumeSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: volumeLevel
                            stepSize: 1

                            onMoved: {
                                volAdjustProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (value / 100).toFixed(2)];
                                volAdjustProc.running = true;
                                volProc.running = true;
                            }
                        }
                    }

                    // Active Streams section (per-app volumes)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: Theme.borderColor
                        visible: activeStreams.length > 0
                    }

                    Text {
                        text: "Active Streams"
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeLarge
                        font.family: Theme.fontFamily
                        font.bold: true
                        visible: activeStreams.length > 0
                    }

                    Repeater {
                        model: activeStreams

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.rightMargin: 10
                            spacing: 5

                            required property var modelData

                            Text {
                                text: modelData.name
                                color: Theme.textColor
                                font.pixelSize: Theme.fontSize
                                font.family: Theme.fontFamily
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Slider {
                                Layout.fillWidth: true
                                from: 0
                                to: 100
                                value: modelData.volume
                                stepSize: 1

                                onMoved: {
                                    volAdjustProc.command = ["wpctl", "set-volume", modelData.id, (value / 100).toFixed(2)];
                                    volAdjustProc.running = true;
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: Theme.borderColor
                    }

                    Text {
                        text: "Output Devices"
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeLarge
                        font.family: Theme.fontFamily
                        font.bold: true
                    }

                    Repeater {
                        model: outputDevices

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            color: outputMouseArea.containsMouse ? Theme.highlightColor : "transparent"
                            radius: Theme.radiusSmall

                            required property var modelData

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: modelData.isDefault ? "✓" : " "
                                    color: Theme.textColor
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: Theme.textColor
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: outputMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    volAdjustProc.command = ["wpctl", "set-default", modelData.id];
                                    volAdjustProc.running = true;
                                    outputDevicesProc.running = true;
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: Theme.borderColor
                    }

                    Text {
                        text: "Input Devices"
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeLarge
                        font.family: Theme.fontFamily
                        font.bold: true
                    }

                    Repeater {
                        model: inputDevices

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            color: inputMouseArea.containsMouse ? Theme.highlightColor : "transparent"
                            radius: Theme.radiusSmall

                            required property var modelData

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                spacing: 10

                                Text {
                                    text: modelData.isDefault ? "✓" : " "
                                    color: Theme.textColor
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    color: Theme.textColor
                                    font.pixelSize: Theme.fontSize
                                    font.family: Theme.fontFamily
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: inputMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    volAdjustProc.command = ["wpctl", "set-default", modelData.id];
                                    volAdjustProc.running = true;
                                    inputDevicesProc.running = true;
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }

    // Mouse area for scroll wheel and click
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Refresh device lists and toggle popup
                outputDevicesProc.running = true;
                inputDevicesProc.running = true;
                streamsProc.running = true;
                showPopup = !showPopup;
            }
        }

        onWheel: (wheel) => {
            // Reversed for natural scrolling
            var delta = wheel.angleDelta.y > 0 ? -5 : 5;
            volAdjustProc.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", delta > 0 ? "5%+" : "5%-"];
            volAdjustProc.running = true;

            // Update volume display immediately
            volProc.running = true;
        }
    }
}
