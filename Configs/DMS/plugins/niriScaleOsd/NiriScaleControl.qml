pragma ComponentBehavior: Bound

// Control Center entry for display scale, shaped like the brightness slider row: circular icon
// button + one slider for the focused output. Clicking the icon opens the drawer, which lists
// every connected output with its own slider.
//
// Changes go through Configs/scripts/niri-output-scale, so the OSD mirrors them. Drags only
// preview; the scale is applied once on release, otherwise every drag step would re-scale the
// output under the pointer.
//
// Both the row and the drawer need the shell to honour a plugin's controlCenterWidget and
// ccExpandRequest hooks (patch in Overlays/dms-shell-control-center-widget.patch); without it the
// ccWidget* properties below make it a pill that resets the focused output's scale when clicked.
import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    readonly property int scaleMinimum: 50
    readonly property int scaleMaximum: 300
    readonly property string focusedOutput: NiriService.currentOutput || ""
    // Only mapped outputs have a scale to change.
    readonly property var outputNames: Object.keys(NiriService.outputs || {}).filter(name => {
        const output = NiriService.outputs[name];
        return output && output.logical && output.logical.scale !== undefined;
    })
    readonly property int focusedPercent: root.shownPercent(root.focusedOutput)
    readonly property bool anyScaled: root.outputNames.some(name => root.shownPercent(name) !== 100)
    // Injected by the patched grid: asks the shell to open this widget's drawer.
    property var ccExpandRequest: null
    // Per-output value the handle sits on but that niri has not been told yet.
    property var pendingPercent: ({})

    function clampPercent(percent) {
        return Math.max(root.scaleMinimum, Math.min(root.scaleMaximum, Math.round(percent / 5) * 5));
    }

    function percentForRatio(ratio) {
        return root.clampPercent(root.scaleMinimum + Math.max(0, Math.min(1, ratio)) * (root.scaleMaximum - root.scaleMinimum));
    }

    function shownPercent(name) {
        if (!name)
            return 100;
        const pending = root.pendingPercent[name];
        if (pending !== undefined)
            return pending;
        return Math.round((NiriService.displayScales[name] ?? 1) * 100);
    }

    function shownRatio(name) {
        if (!name)
            return 0;
        return Math.max(0, Math.min(1, (root.shownPercent(name) - root.scaleMinimum) / (root.scaleMaximum - root.scaleMinimum)));
    }

    function previewPercent(name, percent) {
        if (!name)
            return;
        const next = Object.assign({}, root.pendingPercent);
        next[name] = root.clampPercent(percent);
        root.pendingPercent = next;
    }

    // One shot per gesture: re-scaling mid-drag moves the output under the pointer.
    function applyPercent(name, percent) {
        if (!name)
            return;
        root.previewPercent(name, percent);
        Quickshell.execDetached(["sh", "-c", "$HOME/.local/bin/niri-output-scale set " + (root.pendingPercent[name] / 100).toFixed(2) + " '" + name + "'"]);
    }

    function openDrawer() {
        if (root.ccExpandRequest)
            root.ccExpandRequest();
    }

    // niri reported a scale: drop that output's preview once it matches, or after a grace period.
    Connections {
        target: NiriService

        function onDisplayScalesChanged() {
            const scales = NiriService.displayScales || {};
            const remaining = {};
            for (const name in root.pendingPercent) {
                if (Math.round((scales[name] ?? 0) * 100) !== root.pendingPercent[name])
                    remaining[name] = root.pendingPercent[name];
            }
            if (Object.keys(remaining).length !== Object.keys(root.pendingPercent).length)
                root.pendingPercent = remaining;
        }
    }

    Timer {
        interval: 2000
        running: Object.keys(root.pendingPercent).length > 0
        onTriggered: root.pendingPercent = ({})
    }

    Component.onCompleted: {
        if (!NiriService.outputs || Object.keys(NiriService.outputs).length === 0)
            NiriService.fetchOutputs();
    }

    // Slider geometry shared by the row and the drawer rows.
    component ScaleBar: Item {
        id: scaleBar

        required property string output
        readonly property int shownPercent: root.shownPercent(scaleBar.output)

        height: 12

        Rectangle {
            anchors.fill: parent
            color: Theme.outline
            radius: Theme.cornerRadius
        }

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.shownRatio(scaleBar.output) * parent.width
            color: Theme.primary
            radius: Theme.cornerRadius
        }

        Rectangle {
            width: 4
            height: 20
            radius: Theme.cornerRadius
            x: Math.max(0, Math.min(scaleBar.width - width, root.shownRatio(scaleBar.output) * (scaleBar.width - width)))
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.primary
        }

        MouseArea {
            anchors.fill: parent
            anchors.topMargin: -Theme.spacingXS
            anchors.bottomMargin: -Theme.spacingXS
            enabled: scaleBar.output !== ""
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onPressed: mouse => root.previewPercent(scaleBar.output, root.percentForRatio(mouse.x / scaleBar.width))
            onPositionChanged: mouse => {
                if (pressed)
                    root.previewPercent(scaleBar.output, root.percentForRatio(mouse.x / scaleBar.width));
            }
            onReleased: root.applyPercent(scaleBar.output, scaleBar.shownPercent)
        }
    }

    controlCenterWidget: Component {
        Row {
            id: scaleRow

            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: parent.height
            spacing: Theme.spacingS

            Rectangle {
                id: iconButton

                width: Theme.iconSize + Theme.spacingS * 2
                height: width
                anchors.verticalCenter: parent.verticalCenter
                radius: width / 2
                color: iconArea.containsMouse ? Theme.primaryHover : Theme.withAlpha(Theme.primary, 0)

                DankRipple {
                    id: iconRipple

                    cornerRadius: parent.radius
                }

                MouseArea {
                    id: iconArea

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onPressed: mouse => iconRipple.trigger(mouse.x, mouse.y)
                    onClicked: root.openDrawer()
                    onEntered: iconTooltip.show("Display scale", iconArea, 0, 0, "bottom")
                    onExited: iconTooltip.hide()
                }

                DankIcon {
                    anchors.centerIn: parent
                    name: "display_settings"
                    size: Theme.iconSize
                    color: root.anyScaled ? Theme.primary : Theme.surfaceText
                }
            }

            StyledText {
                id: scaleValue

                anchors.verticalCenter: parent.verticalCenter
                width: Math.round(parent.width * 0.16)
                horizontalAlignment: Text.AlignRight
                text: root.focusedOutput ? root.focusedPercent + "%" : "—"
                font.pixelSize: Theme.fontSizeSmall
                color: root.focusedPercent === 100 ? Theme.surfaceVariantText : Theme.primary
            }

            ScaleBar {
                anchors.verticalCenter: parent.verticalCenter
                width: scaleRow.width - iconButton.width - scaleValue.width - scaleRow.spacing * 2
                output: root.focusedOutput
            }

            DankTooltipV2 {
                id: iconTooltip
            }
        }
    }

    // Drawer: every connected output, name + slider + percentage.
    ccDetailContent: Component {
        Rectangle {
            id: drawer

            implicitHeight: drawerColumn.implicitHeight + Theme.spacingM * 2
            radius: Theme.cornerRadius
            color: Theme.surfaceContainerHigh

            Column {
                id: drawerColumn

                anchors.fill: parent
                anchors.margins: Theme.spacingM
                spacing: Theme.spacingS

                StyledText {
                    text: "Display scale"
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                }

                StyledText {
                    text: "Scale is applied by niri and not saved to outputs.kdl."
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceVariantText
                }

                Repeater {
                    model: root.outputNames

                    delegate: Item {
                        id: drawerRow

                        required property string modelData

                        width: drawerColumn.width
                        height: 22

                        StyledText {
                            id: drawerName

                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.max(40, Math.round(parent.width * 0.34))
                            text: drawerRow.modelData
                            font.pixelSize: Theme.fontSizeSmall
                            color: drawerRow.modelData === root.focusedOutput ? Theme.surfaceText : Theme.surfaceVariantText
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        StyledText {
                            id: drawerValue

                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.round(parent.width * 0.14)
                            horizontalAlignment: Text.AlignRight
                            text: root.shownPercent(drawerRow.modelData) + "%"
                            font.pixelSize: Theme.fontSizeSmall
                            color: root.shownPercent(drawerRow.modelData) === 100 ? Theme.surfaceVariantText : Theme.primary
                        }

                        ScaleBar {
                            anchors.left: drawerName.right
                            anchors.leftMargin: Theme.spacingS
                            anchors.right: drawerValue.left
                            anchors.rightMargin: Theme.spacingS
                            anchors.verticalCenter: parent.verticalCenter
                            output: drawerRow.modelData
                        }
                    }
                }
            }
        }
    }

    ccDetailHeight: Math.max(120, 96 + 22 * root.outputNames.length)

    ccWidgetIcon: "display_settings"
    ccWidgetPrimaryText: "Display scale"
    ccWidgetSecondaryText: root.focusedOutput ? root.focusedOutput + " · " + root.focusedPercent + "%" : "No focused output"
    ccWidgetIsActive: root.focusedPercent !== 100

    onCcWidgetToggled: root.applyPercent(root.focusedOutput, 100)

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: "display_settings"
                color: root.focusedPercent === 100 ? Theme.surfaceVariantText : Theme.primary
                size: Theme.iconSize - 4
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: root.focusedPercent + "%"
                color: root.focusedPercent === 100 ? Theme.surfaceVariantText : Theme.primary
                font.pixelSize: Theme.fontSizeSmall
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: "display_settings"
                color: root.focusedPercent === 100 ? Theme.surfaceVariantText : Theme.primary
                size: Theme.iconSize - 4
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: root.focusedPercent + "%"
                color: root.focusedPercent === 100 ? Theme.surfaceVariantText : Theme.primary
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
