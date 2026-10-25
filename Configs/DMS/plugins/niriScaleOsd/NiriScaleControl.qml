pragma ComponentBehavior: Bound

// Control Center entry for display scale, on the dms-shell 2.0 tile API (controlCenterWidget rows
// are declared upstream but never rendered). Clicking the tile opens the detail page listing every
// output; a tile wide enough to expand shows the focused output's slider inline.
//
// Changes go through Configs/scripts/niri-output-scale, so the OSD mirrors them. Drags only
// preview; the scale is applied once on release, otherwise every drag step would re-scale the
// output under the pointer.
import QtQuick
import Quickshell
import qs.Common
import qs.Services
import qs.Widgets
import qs.DCommon.Widgets
import qs.Modules.ControlCenter
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

    // Slider geometry shared by the inline row and the detail-page rows.
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

    // Inline body of a tile that is wide and tall enough to expand.
    ccExpandedContent: Component {
        Row {
            id: expandedRow

            spacing: Theme.spacingS

            StyledText {
                id: expandedValue

                anchors.verticalCenter: parent.verticalCenter
                width: Math.round(parent.width * 0.16)
                horizontalAlignment: Text.AlignRight
                text: root.focusedOutput ? root.focusedPercent + "%" : "—"
                font.pixelSize: Theme.fontSizeSmall
                color: root.focusedPercent === 100 ? Theme.surfaceVariantText : Theme.primary
            }

            ScaleBar {
                anchors.verticalCenter: parent.verticalCenter
                width: Math.max(0, expandedRow.width - expandedValue.width - expandedRow.spacing)
                output: root.focusedOutput
            }
        }
    }

    // Detail page: every connected output, name + slider + percentage.
    ccDetailContent: Component {
        Item {
            id: detailRoot

            DFlickable {
                anchors.fill: parent
                contentHeight: detailColumn.height
                clip: true

                Column {
                    id: detailColumn
                    width: parent.width
                    spacing: CcMetrics.detailContentGap

                    StyledText {
                        width: parent.width
                        text: "Scale is applied by niri and not saved to outputs.kdl."
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceVariantText
                        wrapMode: Text.WordWrap
                    }

                    Repeater {
                        model: root.outputNames

                        delegate: Item {
                            id: detailRow

                            required property string modelData

                            width: detailColumn.width
                            height: 22

                            StyledText {
                                id: detailName

                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: Math.max(40, Math.round(parent.width * 0.34))
                                text: detailRow.modelData
                                font.pixelSize: Theme.fontSizeSmall
                                color: detailRow.modelData === root.focusedOutput ? Theme.surfaceText : Theme.surfaceVariantText
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            StyledText {
                                id: detailValue

                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: Math.round(parent.width * 0.14)
                                horizontalAlignment: Text.AlignRight
                                text: root.shownPercent(detailRow.modelData) + "%"
                                font.pixelSize: Theme.fontSizeSmall
                                color: root.shownPercent(detailRow.modelData) === 100 ? Theme.surfaceVariantText : Theme.primary
                            }

                            ScaleBar {
                                anchors.left: detailName.right
                                anchors.leftMargin: Theme.spacingS
                                anchors.right: detailValue.left
                                anchors.rightMargin: Theme.spacingS
                                anchors.verticalCenter: parent.verticalCenter
                                output: detailRow.modelData
                            }
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
    // Off so a click opens the detail page instead of toggling anything.
    ccWidgetIsToggle: false

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
