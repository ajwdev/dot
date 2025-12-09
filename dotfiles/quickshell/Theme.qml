pragma Singleton

import QtQuick
import Quickshell

Singleton {
    // Tokyo Night color scheme
    readonly property color backgroundColor: "#1a1b26"
    readonly property color textColor: "#a9b1d6"
    readonly property color borderColor: "#444b6a"
    readonly property color highlightColor: "#2a2b36"
    readonly property color mutedColor: "#565f89"
    readonly property color accentPurple: "#ad8ee6"
    readonly property color accentBlue: "#7aa2f7"
    readonly property color accentCyan: "#7dcfff"
    readonly property color accentGreen: "#9ece6a"
    readonly property color accentYellow: "#e0af68"
    readonly property color accentOrange: "#ff9e64"
    readonly property color accentRed: "#f7768e"

    // Typography
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSizeSmall: 12
    readonly property int fontSize: 14
    readonly property int fontSizeLarge: 16

    // Spacing
    readonly property int spacingSmall: 4
    readonly property int spacing: 8
    readonly property int spacingLarge: 12

    // Border radius
    readonly property int radiusSmall: 2
    readonly property int radius: 4
    readonly property int radiusLarge: 8
}
