import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell
import Qcm.Material as MD

MD.Pane {
    id: sysTray

    elevation: MD.Token.elevation.level2
    backgroundColor: MD.MProp.color.secondary_container
    radius: MD.Token.shape.corner.medium

    implicitWidth: trayRow.implicitWidth + (panelsRoot.sidePadding * 2)
    implicitHeight: parent.height
    padding: panelsRoot.padding
    rightPadding: panelsRoot.sidePadding
    leftPadding: panelsRoot.sidePadding
    RowLayout {
        id: trayRow
        spacing: 5
        height: parent.height

        // height: 50
        Repeater {
            model: SystemTray.items
            delegate: Item {
                id: trayItem
                required property var modelData
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height

                Image {
                    id: trayImg
                    source: trayItem.modelData.icon
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                }

                PopupWindow {
                    id: trayTooltip
                    anchor.window: panel
                    anchor.rect.x: {
                        var _dep = sysTray.x;
                        return (trayItem.mapToItem(panelBox, 0, 0).x) + (trayItem.width / 2) - (this.width / 2);
                    }
                    anchor.rect.y: sysTray.height
                    implicitHeight: Math.max(10, trayTTBox.height)
                    implicitWidth: Math.max(10, trayTTBox.width)

                    visible: trayArea.containsMouse
                    color: "transparent"

                    Pane {
                        id: trayTTBox
                        anchors.fill: parent

                        padding: padding
                        Material.theme: Material.Dark
                        Material.roundedScale: roundedScale
                        Material.background: Qt.alpha(Material.color(Material.Grey, Material.Shade900), 0.9)

                        ColumnLayout {
                            id: trayTTText
                            spacing: padding
                            Label {
                                id: headerText
                                text: trayItem.modelData.id
                                font.bold: true
                                // anchors.centerIn: parent
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                            }

                            MenuSeparator {

                                Layout.fillWidth: true
                            }
                            Label {
                                text: trayItem.modelData.tooltipTitle
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }

                MouseArea {
                    id: trayArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button == Qt.LeftButton) {
                            trayItem.modelData.activate();
                        } else if (true) {
                            let cords = trayItem.mapToItem(panelBox, 0, 0);
                            trayItem.modelData.display(panel, cords.x, cords.y);
                        }
                    }
                }
            }
        }
    }
}
