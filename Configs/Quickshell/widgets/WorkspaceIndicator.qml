import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import Qcm.Material as MD
import Quickshell.WindowManager
import Quickshell

MD.Pane {
    id: ws_root
    required property var widget_padding
    required property var sidePadding
    required property ShellScreen screen
    padding: widget_padding
    rightPadding: sidePadding
    leftPadding: sidePadding
    property var screenWorspaces: WindowManager.screenProjection()

    radius: MD.Token.shape.corner.medium
    backgroundColor: MD.MProp.color.secondary_container
    height: parent.height
    RowLayout {
        spacing: 5
        height: parent.height
        Repeater {
            model: {
                return WindowManager.windowsets.slice().sort((a, b) => a.name - b.name);
            }

            delegate: MD.Button {
                id: ws_item
                Layout.preferredHeight: parent.height
                required property var modelData
                down: modelData.active
                implicitWidth: height
                onClicked: {
                    modelData.activate();
                }
                MD.Label {
                    anchors.centerIn: parent
                    text: ws_item.modelData.name
                }
            }
        }
    }
}
