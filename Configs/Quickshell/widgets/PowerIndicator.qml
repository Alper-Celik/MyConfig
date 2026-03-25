import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell
import Qcm.Material as MD
import Quickshell.Widgets
import Quickshell.Services.UPower

MD.Pane {

    required property var widget_padding
    required property var sidePadding
    padding: widget_padding
    rightPadding: sidePadding
    leftPadding: sidePadding

    radius: MD.Token.shape.corner.medium
    backgroundColor: MD.MProp.color.secondary_container

    height: parent.height
    // width: 300

    Row {
        height: parent.height

        MD.Label {
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            typescale: MD.Token.typescale.title_medium
            text: "%" + ((UPower.displayDevice.percentage) * 100)
        }
        Image {
            source: Quickshell.iconPath(UPower.displayDevice.iconName)
            width: height
            height: parent.height
        }
    }
}
