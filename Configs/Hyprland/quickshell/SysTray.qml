import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell

Item {
    width: trayRow.width
    implicitHeight: parent.height
    Row {
        id: trayRow
        spacing: 5
        height: parent.height
        Repeater {
            model: SystemTray.items
            delegate: Item {
                id: trayItem
                required property var modelData
                height: parent.height
                width: height

                Image {
                    id: trayImg
                    source: trayItem.modelData.icon
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                PopupWindow {
                    id: trayTooltip
                    anchor.window: panel
                    anchor.rect.x: {
                        var _dep = trayRow.width;
                        return (trayItem.mapToGlobal(0, 0).x) + (trayItem.width / 2) - (this.width / 2);
                    }
                    anchor.rect.y: 30
                    implicitHeight: Math.max(10, trayTTBox.height)
                    implicitWidth: Math.max(10, trayTTBox.width)

                    visible: locked || trayArea.containsMouse
                    property var locked: false

                    color: ColorUtils.adjustAlpha("black", 0.5)
                    Rectangle {
                        id: trayTTBox
                        color: ColorUtils.adjustAlpha("black", 0)
                        width: trayTTText.width + 10
                        height: trayTTText.height + 10

                        Column {
                            id: trayTTText
                            anchors.centerIn: parent
                            width: childrenRect.width
                            height: childrenRect.height
                            spacing: 2
                            Rectangle {
                                width: Math.max(headerText.width + 20, parent.width)
                                height: headerText.height
                                color: "#333" // Darker background for the header

                                Label {
                                    id: headerText
                                    text: trayItem.modelData.id
                                    color: "white"
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                            }

                            Label {
                                // text: "test"
                                text: trayItem.modelData.tooltipTitle
                            }

                            MenuWidget {
                                menuHandle: trayItem.modelData.menu
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
                            trayItem.modelData.display(panel, this.x, this.y);
                            trayTooltip.locked = !trayTooltip.locked;
                        }
                    }
                }
            }
        }
    }
}
