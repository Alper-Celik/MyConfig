pragma ComponentBehavior: Bound
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick.Controls.Material
import QtQuick.Effects
import QtQuick
import "./widgets"

Item {

    WlSessionLock {
        id: lock

        property var toBeLocked: false

        function unlockSesion() {
            console.log("unlocking session");
            lock.locked = false;
            pam_u2f.inAuth = false;
            pam_u2f.active = false;
            pam_u2f.inAuth = false;
            pam_password.active = false;
        }

        function lockSesion() {
            if (!toBeLocked && !lock.locked) {
                toBeLocked = true;
                lock_ss.takeSS();
                pam_u2f.startAuth();
                pam_password.startAuth();
            }
        }

        WlSessionLockSurface {
            id: lockSurface
            Material.theme: Material.Dark
            Material.background: Material.color(Material.Grey, Material.Shade900)
            color: Material.color(Material.Grey, Material.Shade900)

            Item {
                id: lock_root
                // state: "locking"
                anchors.fill: parent
                states: [
                    State {
                        name: "locking"
                        PropertyChanges {
                            target: background_effect
                            saturation: -.25
                            blur: 1
                        }
                    },
                    State {
                        name: "unlocking"
                    }
                ]
                transitions: Transition {
                    from: "*"
                    to: "*"
                    NumberAnimation {
                        properties: "saturation,blur"
                        easing.type: Easing.OutExpo
                        duration: 4000
                    }
                }

                Component.onCompleted: {
                    lock_root.state = "locking";
                }

                Image {
                    id: displayImage
                    anchors.fill: parent
                    source: lock_ss.screens.find(s => s.output === lockSurface.screen.name).img

                    cache: true
                    asynchronous: true
                }
                MultiEffect {
                    id: background_effect
                    source: displayImage
                    anchors.fill: displayImage
                    blurEnabled: true
                    blurMax: 96
                    autoPaddingEnabled: false
                }
                UnlockPane {
                    onResponse: function (response: string) {
                        pam_password.login(response);
                    }
                    Connections {
                        target: pam_password
                        function onFailed() {
                            parent.loginFailed("");
                        }
                    }
                }
            }
        }
    }
    IpcHandler {
        target: "lock"
        function lock(): void {
            lock.lockSesion();
        }
        function unlock(): void {
            lock.unlockSesion();
        }
    }
    Process {
        running: true
        onRunningChanged: if (!running)
            running = true
        command: ["sh", ".config/quickshell/wacthLock.sh"]
        stdout: SplitParser {
            id: collector
            onRead: function (data) {
                if (data === "Lock")
                    lock.lockSesion();
                else if (data === "Unlock")
                    lock.unlockSesion();
            }
        }
    }

    ScreenShotter {
        id: lock_ss
        prefix: "lock_"
        onScreenShotTaken: {
            if (lock.toBeLocked) {
                lock.locked = true;
                lock.toBeLocked = false;
            }
        }
    }

    PamContext {
        id: pam_u2f
        config: "yubikey"

        property bool inAuth: false

        onActiveChanged: {
            if (inAuth && (active === false)) {
                active = true;
            }
        }

        function startAuth() {
            inAuth = true;
            active = true;
        }

        onCompleted: function (result) {
            if (result === PamResult.Success) {
                lock.unlockSesion();
            }
        }
    }
    PamContext {
        id: pam_password
        config: "password"

        property bool inAuth: false

        signal failed

        onActiveChanged: {
            if (inAuth && (active === false)) {
                active = true;
            }
        }

        function startAuth() {
            inAuth = true;
            active = true;
        }

        function login(password) {
            respond(password);
        }

        onCompleted: function (result) {
            if (result === PamResult.Success) {
                lock.unlockSesion();
            } else {
                pam_password.failed();
            }
        }
    }
}
