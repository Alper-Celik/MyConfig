pragma Singleton

import Quickshell.Io
import Quickshell

Singleton {
    id: root
    property var screens: _screens.instances
    property var takeSS: function () {
        screens.forEach(s => s.running = true);
    }
    signal screenShotTaken

    Variants {
        id: _screens
        model: Quickshell.screens
        Process {
            property var output: modelData.name
            property var img: ""
            required property var modelData
            running: false
            command: ["sh", "-c", "grim -o" + output + " - | base64 -w 0 "]
            stdout: StdioCollector {
                onStreamFinished: data = this.text
            }
            onExited: {
                img = "data:image/png;base64," + this.stdout.text;
                if (!screens.filter(s => s.running).some(r => r == true)) {
                    root.screenShotTaken();
                }
            }
        }
    }
}
