import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick // for Text
import Qcm.Material as MD
import "./widgets/"

Item {
    id: panelsRoot
    required property var modelData

    property var padding: 5
    property var sidePadding: 5
    property var roundedScale: MD.Token.shape.corner.medium
    property var elevationL1: 25

    PanelWindow {
        id: panel
        screen: panelsRoot.modelData

        mask: Region {
            item: panelInner
        }

        anchors {
            top: true
            left: true
            right: true
        }
        exclusiveZone: 50
        color: "transparent"
        implicitHeight: modelData.height
        Rectangle {
            id: screen
            anchors.fill: parent
            color: "transparent"
        }
        Rectangle {
            id: panelBox
            color: "transparent"
            // anchors.fill: parent
            anchors.left: parent.left
            anchors.right: parent.right
            height: panel.exclusiveZone
            clip: false

            MD.Pane {
                id: panelInner
                MD.MProp.textColor: MD.MProp.color.on_surface
                MD.MProp.backgroundColor: MD.MProp.color.surface_container

                elevation: MD.Token.elevation.level5

                backgroundColor: MD.MProp.color.surface_container
                anchors.margins: 5
                padding: 0
                rightPadding: this.leftPadding
                radius: roundedScale
                clip: false

                anchors.fill: parent

                height: 30

                PanelClock {
                    id: clock
                    sidePadding: panelsRoot.sidePadding
                    anchors.centerIn: parent
                }

                Row {
                    id: panelWidgets
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft
                    spacing: panelsRoot.sidePadding * 2

                    PowerIndicator {
                        widget_padding: panelsRoot.padding
                        sidePadding: panelsRoot.sidePadding
                    }
                    SysTray {}
                }
            }
        }
    }
}
