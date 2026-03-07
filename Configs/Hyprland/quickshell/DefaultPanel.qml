import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick // for Text

Scope {
    id: panelsRoot
    required property var modelData

    property var padding: 5
    property var sidePadding: 5
    property var roundedScale: Material.MediumScale
    property var elevationL1: 25

    PanelWindow {
        id: panel
        screen: panelsRoot.modelData

        anchors {
            top: true
            left: true
            right: true
        }
        color: "transparent"
        implicitHeight: 50
        Rectangle {
            id: panelBox
            color: "transparent"
            anchors.fill: parent
        }
        Pane {
            id: panelInner
            anchors.margins: 5
            padding: 0
            rightPadding: this.leftPadding
            Material.theme: Material.Dark
            Material.roundedScale: roundedScale
            Material.background: Material.color(Material.Grey, Material.Shade900)
            clip: true

            anchors.fill: parent

            Clock {
                id: clock
                anchors.centerIn: parent
            }

            RowLayout {
                id: panelWidgets
                anchors.fill: parent

                SysTray {
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }
}
