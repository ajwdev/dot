import QtQuick
import QtQuick.Layouts
import Quickshell

// niri variant: niri has no dwindle/master layouts (single scrolling-column
// tiling). Report the focused window's floating state instead, via NiriService.
Text {
    property color textColor: "#a9b1d6"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    text: NiriService.focusedWindow ? (NiriService.focusedIsFloating ? "Floating" : "Tiled") : "Tiled"
    color: textColor
    font.pixelSize: fontSize
    font.family: fontFamily
    font.bold: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5
}
