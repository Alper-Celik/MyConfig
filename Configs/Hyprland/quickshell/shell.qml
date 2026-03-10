//@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick.Controls
import QtQuick // for Text
import Quickshell.Io
import Qcm.Material as MD

Scope {
    MD.MProp.textColor: MD.MProp.color.on_surface
    MD.MProp.backgroundColor: MD.MProp.color.surface_container
    Component.onCompleted: {
        // MD.Token.color.accentColor = "#8BC34A";

        MD.Token.themeMode = MD.Enum.Dark;
    }
    Variants {
        model: Quickshell.screens
        DefaultPanel {}
    }
    Lock {}
}
