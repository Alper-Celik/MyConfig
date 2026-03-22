pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell

Item {
    id: root
    required property string prefix
    property bool captureCursor: false
    property var screens: _screens.instances
    property var takeSS: function () {
        screens.forEach(s => s.proc.running = true);
    }
    signal screenShotTaken

    Variants {
        id: _screens
        model: Quickshell.screens
        Item {
            id: _SShot
            property var output: modelData.name
            property var img: ""
            required property var modelData
            property var proc: _proc
            Process {
                id: _proc
                running: false
                property string filePath: "/dev/shm/" + root.prefix + _SShot.modelData.name + ".ppm"
                command: {
                    let cmd = ["grim", "-tppm"];

                    if (root.captureCursor) {
                        cmd = cmd.concat(["-c"]);
                    }

                    return cmd.concat(["-o", _SShot.output, filePath]);
                }
                onExited: {
                    // prevent caching with the timestamp
                    _SShot.img = "file://" + filePath + "?t=" + Date.now();
                    if (!root.screens.filter(s => s.proc.running).some(r => r == true)) {
                        root.screenShotTaken();
                    }
                }
            }
            Image {
                source: _SShot.img
                visible: false
                asynchronous: false
                cache: true
            }
        }
    }
}
