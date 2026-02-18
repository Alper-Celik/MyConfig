import QtQuick
import QtQuick.Controls.Basic
import Quickshell

Rectangle {
    id: menuRoot
    required property var menuHandle

    height: rootColumn.height + 10
    width: Math.max(rootColumn.width, parent.width)

    color: "lightgray"

    Column {
        id: rootColumn
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: 3
        Repeater {
            model: menuOpener.children
            delegate: menu
        }
    }

    Component {
        id: menu
        Loader {
            property var itemData: modelData
            // sourceComponent :Component{ Label{
            //   text: "test"
            // }}
            sourceComponent: {
                if (modelData.isSeparator) {
                    return separator;
                } else {
                    return menuItem;
                }
            }
        }
    }

    Component {
        id: separator
        Rectangle {
            color: "black"
            width: 500
            height: 5
        }
    }

    Component {
        id: menuItem
        Rectangle {
            width: 500
            height: 20
            color: ColorUtils.adjustAlpha("gray", 1)
            Row {
                property var itemData: parent.itemData
                Component {
                    id: radioBtn
                    RadioButton {
                        // height: itemTextLabel.height
                        checked: parent.btnState !== Qt.Unchecked
                    }
                }
                Component {
                    id: checkBtn
                    CheckBox {
                        // height: itemTextLabel.height
                        checkState: parent.btnState
                    }
                }
                Component {
                    id: emptyBtn
                    Label {
                        text: ""
                    }
                }

                Loader {
                    height: parent.parent.height
                    width: 50
                    property var btnState: itemData.checkState
                    sourceComponent: {
                        console.log(CheckBox);
                        if (itemData.buttonType === QsMenuButtonType.CheckBox)
                            return checkBtn;
                        else if (itemData.buttonType.toString() === QsMenuButtonType.RadioButton)
                            return radioBtn;
                        return emptyBtn;
                    }
                }

                Label {
                    id: itemTextLabel
                    height: parent.parent.height
                    text: itemData.text
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    QsMenuOpener {
        id: menuOpener
        menu: menuHandle
    }
}
