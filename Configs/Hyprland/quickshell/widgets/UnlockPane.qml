import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
    Material.theme: Material.Dark
    Material.roundedScale: Material.MediumScale
    Material.background: Material.color(Material.Grey, Material.Shade900)
    Material.elevation: 50
    padding: 50

    width: parent.width / 4
    height: parent.height / 2

    anchors.centerIn: parent

    RowLayout {

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        TextField {
            id: passField

            Layout.fillWidth: true
            echoMode: TextInput.Password
            placeholderText: pam_password.message
            onAccepted: {
                console.log("trying to unlock pam_u2f");
                pam_password.login(text);
            }
            Connections {
                target: pam_password
                function onFailed() {
                    passField.clear();
                }
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

            onClicked: pam_password.login(passField.text)
        }
    }
}
