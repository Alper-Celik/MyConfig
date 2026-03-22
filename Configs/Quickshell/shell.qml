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
        model: Quickshell.screens
        PanelWindow {
            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Bottom
            Walpaper {
                anchors.fill: parent
            }
        }
    }

    Lock {}

    Process {
        id: notify
        command: ["sh", ".config/quickshell/start-notify.sh"]
    }
}
