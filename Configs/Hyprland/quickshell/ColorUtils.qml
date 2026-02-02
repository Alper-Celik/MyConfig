pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property var adjustAlpha: function (existingColor, newAlpha): color {
        let color = Qt.color(existingColor);
        color.a = newAlpha;
        return color;
    }
}
