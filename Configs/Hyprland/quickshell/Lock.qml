pragma ComponentBehavior: Bound
import QtQuick.Controls.Material
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

Item {

    WlSessionLock {
        id: lock

        property var toBeLocked: false

        function lockSesion() {
            if (!toBeLocked && !lock.locked) {
                toBeLocked = true;
                lock_ss.takeSS();
            }
        }

        WlSessionLockSurface {
            id: lockSurface
            color: Material.color(Material.Grey, Material.Shade900)
            Image {
                id: displayImage
                anchors.fill: parent
                source: lock_ss.screens.find(s => s.output === lockSurface.screen.name).img

                cache: true
                asynchronous: true
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
}
