pragma ComponentBehavior: Bound

// Display scale OSD: shows the scale of the output that Configs/scripts/niri-output-scale
// changed, in DMS's OSD window and the same shape as the volume OSD — vertical bar with a grab
// handle when the OSD position is a side one, horizontal row otherwise.
//
// Dragging only moves the handle: the scale is applied once, on release, otherwise every drag
// step would re-scale the output (and this surface) under the pointer.
//
// IPC (both arguments required):
//   dms ipc call niriScaleOsd show <scale> <monitor>    monitor "" = every screen
//   dms ipc call niriScaleOsd hide
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    readonly property int scaleMinimum: 50
    readonly property int scaleMaximum: 300
    readonly property int scalePercent: Math.round(root.scaleValue * 100)
    readonly property string iconName: "display_settings"
    // Value the handle sits on but that niri has not been told yet; shown until it reports back.
    property int pendingPercent: -1
    readonly property int shownPercent: root.pendingPercent >= 0 ? root.pendingPercent : root.scalePercent
    readonly property real shownRatio: Math.max(0, Math.min(1, (root.shownPercent - root.scaleMinimum) / (root.scaleMaximum - root.scaleMinimum)))

    property string targetMonitor: ""
    property real scaleValue: 1.0
    // Bumped on every IPC call: re-showing keeps the OSD alive and updates the value.
    property int showSeq: 0
    property int hideSeq: 0

    function clampPercent(percent) {
        return Math.max(root.scaleMinimum, Math.min(root.scaleMaximum, Math.round(percent / 5) * 5));
    }

    function percentForRatio(ratio) {
        return root.clampPercent(root.scaleMinimum + Math.max(0, Math.min(1, ratio)) * (root.scaleMaximum - root.scaleMinimum));
    }

    function previewPercent(percent) {
        root.pendingPercent = root.clampPercent(percent);
    }

    function applyPending() {
        if (root.pendingPercent < 0)
            return;
        Quickshell.execDetached(["sh", "-c", "$HOME/.local/bin/niri-output-scale set " + (root.pendingPercent / 100).toFixed(2)]);
    }

    // niri reported a scale: drop the local preview once it matches, or after a grace period if
    // the value got clamped somewhere.
    Connections {
        target: root

        function onScalePercentChanged() {
            if (root.pendingPercent >= 0 && root.scalePercent === root.pendingPercent)
                root.pendingPercent = -1;
        }
    }

    Timer {
        interval: 2000
        running: root.pendingPercent >= 0
        onTriggered: root.pendingPercent = -1
    }

    IpcHandler {
        target: "niriScaleOsd"

        function show(scale: string, monitor: string): string {
            const value = parseFloat(scale);
            if (!isFinite(value) || value <= 0)
                return "error: invalid scale: " + scale;

            root.targetMonitor = monitor || "";
            root.scaleValue = value;
            root.pendingPercent = -1;
            root.showSeq += 1;
            return "scale " + root.scalePercent + "%";
        }

        function hide(): string {
            root.hideSeq += 1;
            return "hidden";
        }
    }

    Variants {
        model: Quickshell.screens

        DankOSD {
            id: osd

            readonly property bool forThisScreen: root.targetMonitor === "" || root.targetMonitor === (osd.screen ? osd.screen.name : "")

            osdWidth: osd.isVerticalLayout ? Theme.iconSize + Theme.spacingS * 2 : Math.min(216, screenWidth - Theme.spacingM * 2)
            osdHeight: osd.isVerticalLayout ? Math.min(260, screenHeight - Theme.spacingM * 2) : 40 + Theme.spacingS * 2
            autoHideInterval: 2000
            enableMouseInteraction: true

            Connections {
                target: root

                function onShowSeqChanged() {
                    if (osd.forThisScreen)
                        osd.show();
                }

                function onHideSeqChanged() {
                    if (osd.forThisScreen)
                        osd.hide();
                }
            }

            content: Loader {
                anchors.fill: parent
                sourceComponent: osd.isVerticalLayout ? verticalContent : horizontalContent
            }

            // Track, fill and grab handle copied from DMS's own vertical volume OSD.
            Component {
                id: verticalContent

                Item {
                    id: verticalLayout

                    readonly property int gap: Theme.spacingS

                    DankIcon {
                        id: verticalIcon

                        anchors.horizontalCenter: parent.horizontalCenter
                        y: verticalLayout.gap
                        name: root.iconName
                        size: Theme.iconSize
                        color: Theme.primary

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -Theme.spacingS
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onContainsMouseChanged: osd.setChildHovered(containsMouse || verticalSliderArea.containsMouse || verticalSliderArea.pressed)
                            onClicked: {
                                root.previewPercent(100);
                                root.applyPending();
                            }
                        }
                    }

                    Item {
                        id: verticalSlider

                        width: 12
                        height: parent.height - Theme.iconSize - verticalLayout.gap * 3 - 24
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: verticalLayout.gap * 2 + Theme.iconSize

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            anchors.centerIn: parent
                            color: Theme.outline
                            radius: Theme.cornerRadius
                        }

                        Rectangle {
                            width: parent.width
                            height: root.shownRatio * parent.height
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Theme.primary
                            radius: Theme.cornerRadius
                        }

                        Rectangle {
                            width: 24
                            height: 8
                            radius: Theme.cornerRadius
                            y: {
                                const travel = verticalSlider.height - height;
                                return Math.max(0, Math.min(travel, travel * (1 - root.shownRatio)));
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Theme.primary
                            border.width: 3
                            border.color: Theme.surfaceContainer
                        }

                        MouseArea {
                            id: verticalSliderArea

                            anchors.fill: parent
                            anchors.margins: -Theme.spacingM
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            // The hit area is padded, so map against the visible bar.
                            function ratioAt(y) {
                                return 1 - (y - Theme.spacingM) / verticalSlider.height;
                            }

                            onContainsMouseChanged: osd.setChildHovered(containsMouse || pressed)
                            onPressed: mouse => {
                                root.previewPercent(root.percentForRatio(ratioAt(mouse.y)));
                                osd.resetHideTimer();
                            }
                            onPositionChanged: mouse => {
                                if (pressed) {
                                    root.previewPercent(root.percentForRatio(ratioAt(mouse.y)));
                                    osd.resetHideTimer();
                                }
                            }
                            onReleased: root.applyPending()
                        }
                    }

                    StyledText {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: verticalLayout.gap
                        text: root.shownPercent + "%"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceText
                    }
                }
            }

            Component {
                id: horizontalContent

                Item {
                    Item {
                        id: horizontalIconSlot

                        width: Theme.iconSize
                        height: Theme.iconSize
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.spacingS
                        anchors.verticalCenter: parent.verticalCenter

                        DankIcon {
                            anchors.centerIn: parent
                            name: root.iconName
                            size: Theme.iconSize
                            color: Theme.primary
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -Theme.spacingS
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onContainsMouseChanged: osd.setChildHovered(containsMouse || horizontalSlider.containsMouse || horizontalSlider.isDragging)
                            onClicked: {
                                root.previewPercent(100);
                                root.applyPending();
                            }
                        }
                    }

                    StyledText {
                        id: horizontalValue

                        anchors.right: parent.right
                        anchors.rightMargin: Theme.spacingS
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.shownPercent + "%"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.surfaceText
                    }

                    DankSlider {
                        id: horizontalSlider

                        anchors.left: horizontalIconSlot.right
                        anchors.leftMargin: Theme.spacingS
                        anchors.right: horizontalValue.left
                        anchors.rightMargin: Theme.spacingS
                        anchors.verticalCenter: parent.verticalCenter
                        minimum: root.scaleMinimum
                        maximum: root.scaleMaximum
                        step: 5
                        // The value sits next to the slider instead of in the floating tooltip,
                        // which does not fit in an OSD-sized window.
                        showValue: false

                        onSliderValueChanged: newValue => {
                            root.previewPercent(newValue);
                            osd.resetHideTimer();
                            // Wheel and plain clicks are not drags: nothing gets released.
                            if (!horizontalSlider.isDragging)
                                root.applyPending();
                        }
                        onSliderDragFinished: finalValue => root.applyPending()
                        onContainsMouseChanged: osd.setChildHovered(containsMouse || horizontalSlider.isDragging)
                    }

                    Binding {
                        target: horizontalSlider
                        property: "value"
                        value: root.shownPercent
                        when: !horizontalSlider.isDragging
                    }
                }
            }
        }
    }
}
