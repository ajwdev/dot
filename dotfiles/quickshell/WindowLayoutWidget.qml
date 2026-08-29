import QtQuick
import QtQuick.Layouts

Text {
    property color textColor: "#a9b1d6"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    text: CompositorService.hasFocusedWindow ? (CompositorService.focusedIsFloating ? "Floating" : "Tiled") : "Tiled"
    color: textColor
    font.pixelSize: fontSize
    font.family: fontFamily
    font.bold: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5
}
