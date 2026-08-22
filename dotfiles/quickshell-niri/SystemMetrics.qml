import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    spacing: 0

    // Internal state
    property string kernelVersion: "Linux"
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // Theme properties
    property color kernelColor: "#f7768e"
    property color cpuColor: "#e0af68"
    property color memColor: "#0db9d7"
    property color diskColor: "#7aa2f7"
    property color separatorColor: "#444b6a"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    // Separator component
    component Separator: Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: separatorColor
    }

    // Kernel version
    Process {
        id: kernelProc
        command: ["uname", "-r"]
        stdout: SplitParser {
            onRead: data => {
                if (data) kernelVersion = data.trim()
            }
        }
        Component.onCompleted: running = true
    }

    // CPU usage
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var user = parseInt(parts[1]) || 0
                var nice = parseInt(parts[2]) || 0
                var system = parseInt(parts[3]) || 0
                var idle = parseInt(parts[4]) || 0
                var iowait = parseInt(parts[5]) || 0
                var irq = parseInt(parts[6]) || 0
                var softirq = parseInt(parts[7]) || 0

                var total = user + nice + system + idle + iowait + irq + softirq
                var idleTime = idle + iowait

                if (lastCpuTotal > 0) {
                    var totalDiff = total - lastCpuTotal
                    var idleDiff = idleTime - lastCpuIdle
                    if (totalDiff > 0) {
                        cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                    }
                }
                lastCpuTotal = total
                lastCpuIdle = idleTime
            }
        }
        Component.onCompleted: running = true
    }

    // Memory usage
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    // Disk usage
    Process {
        id: diskProc
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var percentStr = parts[4] || "0%"
                diskUsage = parseInt(percentStr.replace('%', '')) || 0
            }
        }
        Component.onCompleted: running = true
    }

    // Timer for periodic updates
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            diskProc.running = true
        }
    }

    // Layout children
    Separator {}

    Text {
        text: kernelVersion
        color: kernelColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Separator {}

    Text {
        text: "CPU: " + cpuUsage + "%"
        color: cpuColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Separator {}

    Text {
        text: "Mem: " + memUsage + "%"
        color: memColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Separator {}

    Text {
        text: "Disk: " + diskUsage + "%"
        color: diskColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }
}
