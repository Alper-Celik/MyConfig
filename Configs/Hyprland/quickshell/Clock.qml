import Quickshell
import QtQuick.Controls.Basic
import QtQuick

Item {
    Label {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "ddd yyyy-MM-dd HH:mm.ss ttt ")
    }
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
