import Quickshell
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick

Pane {
    Material.background: Material.color(Material.Grey, Material.Shade800)
    Material.roundedScale: Material.MediumScale
    Material.elevation: elevationL1

    Label {
        id: clockInner
        anchors.centerIn: parent
        font.pixelSize: 17
        text: Qt.formatDateTime(clock.date, "ddd yyyy-MM-dd HH:mm.ss ttt ")
        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }
    }
}
