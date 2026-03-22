import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick

Pane {
    id: unlockPane
    Material.theme: Material.Dark
    Material.roundedScale: Material.MediumScale
    Material.background: Material.color(Material.Grey, Material.Shade900)
    Material.elevation: 50
    padding: 50

    width: parent.width / 4
    height: parent.height / 2

    anchors.centerIn: parent

    function loginFailed(message: string) {
        passField.clear();
    }
    signal response(response: string)
    property string responsePlaceholder: "Password :"

    RowLayout {

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        TextField {
            id: passField

            Layout.fillWidth: true
            echoMode: TextInput.Password
            placeholderText: unlockPane.responsePlaceholder
            onAccepted: {
                unlockPane.response(text);
            }
        }
        RoundButton {
            icon.name: "image-red-eye"
            onClicked: {
                if (icon.name === "view-visible") {
                    icon.name = "image-red-eye";
                    passField.echoMode = TextInput.Password;
                } else {
                    passField.echoMode = TextInput.Normal;
                    icon.name = "view-visible";
                }
            }
        }
        Button {
            icon.name: "draw-arrow-forward"

            onClicked: unlockPane.response(passField.text)
        }
    }
}
