import Quickshell
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick
import Qcm.Material as MD
import QtQuick.Templates as T

MD.Pane {
    elevation: MD.Token.elevation.level2

    backgroundColor: MD.MProp.color.secondary_container

    height: parent.height
    radius: MD.Token.shape.corner.medium
    rightPadding: panelsRoot.sidePadding
    leftPadding: panelsRoot.sidePadding
    MD.Label {
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        typescale: MD.Token.typescale.title_medium
        text: Qt.formatDateTime(clock.date, "ddd yyyy-MM-dd HH:mm.ss ttt")
        color: MD.Token.color.getOn(MD.MProp.color.secondary_container)
        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }
    }
}
