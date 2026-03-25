//@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick.Controls
import QtQuick // for Text
import Quickshell.Io
import Quickshell.Wayland
import Qcm.Material as MD
import "./widgets/"

Scope {
    MD.MProp.textColor: MD.MProp.color.on_surface
    MD.MProp.backgroundColor: MD.MProp.color.surface_container
    Component.onCompleted: {
        // MD.Token.color.accentColor = "#8BC34A";

        MD.Token.themeMode = MD.Enum.Dark;
        notify.running = true;
    }
    Variants {
        model: Quickshell.screens
        DefaultPanel {}
    }
    Variants {
        id: walpapers
        model: Quickshell.screens
        PanelWindow {

            required property var modelData
            property alias wp: screen_wp

            screen: modelData
            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Bottom
            Walpaper {
                id: screen_wp
                wp_id: modelData.model
                anchors.fill: parent
            }
        }
    }

    Lock {}

    Process {
        id: notify
        command: ["sh", ".config/quickshell/start-notify.sh"]
    }
    IpcHandler {
        target: "walpaper"
        function set(url: string, _title: string, _desc: string, _copyright: string) {
            for (const wp of walpapers.instances) {
                wp.wp.set(url, _title, _desc, _copyright);
            }
        }
    }
}
