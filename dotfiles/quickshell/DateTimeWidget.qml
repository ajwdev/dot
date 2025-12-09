import QtQuick
import QtQuick.Layouts

Text { id: root
    property color textColor: "#0db9d7"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14
    property string dateFormat: "ddd, MMM dd hh:mm AP"

    text: Qt.formatDateTime(new Date(), dateFormat)
    color: textColor
    font.pixelSize: fontSize
    font.family: fontFamily
    font.bold: true
    Layout.rightMargin: 8

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: parent.text = Qt.formatDateTime(new Date(), root.dateFormat)
    }
}
