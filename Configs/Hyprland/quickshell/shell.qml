//@ pragma UseQApplication
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text

Scope {
    Variants {
        model: Quickshell.screens
        DefaultPanel {}
    }
}
