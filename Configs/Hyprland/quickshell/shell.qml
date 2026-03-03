//@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick.Controls
import QtQuick // for Text
import Quickshell.Io

Scope {
    Variants {
        model: Quickshell.screens
        DefaultPanel {}
    }
    Lock {}
}
