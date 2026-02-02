import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text

Scope {
    id: panelsRoot
    required property var modelData
    PanelWindow {
        screen: panelsRoot.modelData
        anchors {
            top: true
            left: true
            right: true
        }
        color: "transparent"
        implicitHeight: 30
        Rectangle {
            anchors.margins: 5

            anchors.fill: parent
            radius: 50
            color: ColorUtils.adjustAlpha("black", 0.5)

            Clock {
                anchors.centerIn: parent
            }
        }
    }
}
