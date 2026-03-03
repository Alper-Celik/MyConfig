import QtQuick.Controls.Material
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

Item {

    WlSessionLock {
        id: lock

        property var toBeLocked: false

        function lockSesion() {
            if (!toBeLocked) {
                toBeLocked = true;
                ScreenShotter.takeSS();
            }
        }

        WlSessionLockSurface {
            id: lockSurface
            color: Material.color(Material.Grey, Material.Shade900)
            Image {
                id: displayImage
                anchors.fill: parent
                // width: 500
                // height: 500
                // Use the function to set the source
                source: img
                property var img: {
                    return ScreenShotter.screens.filter(s => s.output == lockSurface.screen.name)[0].img;
                }
            }
            Button {
                text: "unlock me"
                onClicked: lock.locked = false
            }
        }
    }
    IpcHandler {
        target: "lock"
        function lock(): void {
            lock.lockSesion();
        }
        function unlock(): void {
            lock.locked = true;
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
                    lock.locked = false;
            }
        }
    }

    Connections {
        target: ScreenShotter
        onScreenShotTaken: {
            if (lock.toBeLocked) {
                lock.locked = true;
                lock.toBeLocked = false;
            }
        }
    }
}
