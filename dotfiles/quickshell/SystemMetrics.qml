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
    property int cpuTemp: 0
    property int gpuTemp: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // Theme properties
    property color kernelColor: "#f7768e"
    property color cpuColor: "#e0af68"
    property color memColor: "#0db9d7"
    property color diskColor: "#7aa2f7"
    property color tempColor: "#ad8ee6"
    property color gpuColor: "#9ece6a"
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

    // CPU temperature (k10temp Tctl; hwmon index isn't stable, resolve by name)
    Process {
        id: tempProc
        command: ["sh", "-c", "for h in /sys/class/hwmon/hwmon*; do [ \"$(cat $h/name 2>/dev/null)\" = k10temp ] && cat $h/temp1_input && break; done"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var milli = parseInt(data.trim()) || 0
                cpuTemp = Math.round(milli / 1000)
            }
        }
        Component.onCompleted: running = true
    }

    // GPU temperature (amdgpu edge). Resolve by name since the hwmonN index
    // isn't stable across reboots.
    //
    // A machine can expose more than one amdgpu hwmon: a discrete card AND the
    // CPU's integrated graphics (e.g. tomservo has an RX 7900 + a Ryzen iGPU;
    // bolt has only the APU iGPU). We want the discrete card's temp when it
    // exists. The discriminator is fan1_input: a discrete GPU has fans and so
    // exposes a fan1_input attribute in its hwmon dir; an APU's iGPU has no fan
    // of its own and does not. So: pick the amdgpu that has fan1_input
    // (discrete), else fall back to the first amdgpu (APU-only hosts).
    Process {
        id: gpuTempProc
        command: ["sh", "-c", "sel=\"\"; for h in /sys/class/hwmon/hwmon*; do [ \"$(cat $h/name 2>/dev/null)\" = amdgpu ] || continue; [ -e \"$h/temp1_input\" ] || continue; [ -z \"$sel\" ] && sel=$h; [ -e \"$h/fan1_input\" ] && { sel=$h; break; }; done; [ -n \"$sel\" ] && cat $sel/temp1_input"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var milli = parseInt(data.trim()) || 0
                gpuTemp = Math.round(milli / 1000)
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
            tempProc.running = true
            gpuTempProc.running = true
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

    Separator {}

    Text {
        text: "CPU: " + cpuTemp + "°C"
        color: tempColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Separator {}

    Text {
        text: "GPU: " + gpuTemp + "°C"
        color: gpuColor
        font.pixelSize: fontSize
        font.family: fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }
}
