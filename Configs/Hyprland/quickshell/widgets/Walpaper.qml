import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Qcm.Material as MD
import Qt.labs.settings 1.0
import QtQuick.Effects

Item {

    Image {
        id: walpaper
        Settings {
            id: walpaper_settings
            category: "Walpaper"
            property alias source: walpaper.source
            property alias title: title.text
            property alias desc: desc.text
            property alias copyright: copyright.text
        }
        anchors.fill: parent
        onSourceChanged: walpaper_settings.sync()

        source: "/dev/shm/lock_eDP-1.ppm"
        property string newUrl: ""
        onNewUrlChanged: {
            walpaper_animation.running = true;
        }
    }

    Item {
        id: blur_root
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: title.width + 100
        height: mainPart.implicitHeight + (copyright.height * 2.5)

        anchors.margins: 20
        clip: true

        MultiEffect {
            id: background_effect
            x: -walpaper.width + blur_root.width + blur_root.anchors.rightMargin
            y: -walpaper.height + blur_root.height + blur_root.anchors.bottomMargin
            anchors.fill: walpaper
            source: walpaper
            blurEnabled: true
            width: walpaper.width
            height: walpaper.height
            blurMax: 64
            autoPaddingEnabled: false
            blur: 1
        }

        MD.Pane {
            id: info_panel
            anchors.fill: parent
            padding: 10
            backgroundColor: Qt.alpha(MD.MProp.color.surface, 0.2)
            radius: MD.Token.shape.corner.medium

            MD.MProp.textColor: MD.MProp.color.on_surface

            ColumnLayout {
                anchors.fill: parent

                Column {
                    id: mainPart
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 15
                    MD.Label {
                        id: title

                        property string newText: ""
                        anchors.right: parent.right
                        typescale: MD.Token.typescale.title_large
                    }
                    MD.Button {
                        id: control
                        width: parent.width
                        height: desc.implicitHeight + 4
                        Behavior on height {
                            NumberAnimation {
                                duration: 350
                                easing.type: Easing.InOutBack
                            }
                        }
                        clip: true

                        onClicked: state == "expanded" ? state = "" : state = "expanded"

                        states: [
                            State {
                                name: "expanded"
                                PropertyChanges {
                                    target: desc
                                    maximumLineCount: 100
                                }
                            }
                        ]

                        background: MD.Ripple2 {
                            anchors.fill: parent
                            radius: MD.Token.shape.corner.small
                            pressX: control.pressX
                            pressY: control.pressY
                            pressed: control.pressed
                            stateOpacity: control.mdState.stateLayerOpacity
                            // color: control.mdState.stateLayerColor
                        }

                        MD.Label {
                            id: desc
                            height: parent.height
                            property string newText: ""
                            width: parent.width
                            elide: Text.ElideRight
                            maximumLineCount: 5
                            anchors.centerIn: parent
                            verticalAlignment: Text.AlignTop

                            typescale: MD.Token.typescale.body_small
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                MD.Label {
                    id: copyright

                    property string newText: ""
                    // Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                    text: "test"
                }
            }
        }
    }

    Rectangle {
        id: walpaper_bg
        color: "transparent"
        anchors.fill: parent

        SequentialAnimation {
            id: walpaper_animation
            running: false
            ColorAnimation {
                target: walpaper_bg
                property: "color"
                to: MD.MProp.color.surface
                duration: 1000
            }
            PropertyAnimation {
                target: walpaper
                property: "source"
                to: walpaper.newUrl
                duration: 100
            }
            PropertyAnimation {
                target: title
                property: "text"
                to: title.newText
            }
            PropertyAnimation {
                target: desc
                property: "text"
                to: desc.newText
            }
            PropertyAnimation {
                target: copyright
                property: "text"
                to: copyright.newText
            }

            ColorAnimation {
                target: walpaper_bg
                property: "color"
                to: "transparent"
                duration: 1000
            }
        }
        IpcHandler {
            target: "walpaper"

            function set(url: string, _title: string, _desc: string, _copyright: string) {
                walpaper.newUrl = url;
                title.newText = _title;
                desc.newText = _desc;
                copyright.newText = _copyright;
            }
        }
    }
}
