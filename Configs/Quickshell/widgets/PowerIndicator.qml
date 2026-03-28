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
    id: power_root
    required property var widget_padding
    required property var sidePadding
    padding: widget_padding
    rightPadding: sidePadding
    leftPadding: sidePadding

    radius: MD.Token.shape.corner.medium
    backgroundColor: MD.MProp.color.secondary_container

    height: parent.height
    width: r.width + (sidePadding * 2)
    // Rectangle {
    background: MD.Rectangle {
        color: parent.backgroundColor
        radius: parent.radius
        MD.Ripple2 {
            anchors.fill: parent
            radius: parent.radius
            pressX: control.mouseX
            pressY: control.mouseY
            pressed: control.pressed
        }
    }

    Row {
        id: r
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
    MouseArea {
        id: control
        anchors.fill: parent
        onClicked: {
            window.visible = !window.visible;
        }
    }

    PopupWindow {
        id: window
        anchor.window: panel
        anchor.rect.x: {
            var _dep = power_root.x;
            return (power_root.mapToItem(panelBox, 0, 0).x) + (power_root.width / 2) - (this.width / 2);
        }
        anchor.rect.y: power_root.height + 10
        width: 50
        height: 50
        visible: false
    }
}
