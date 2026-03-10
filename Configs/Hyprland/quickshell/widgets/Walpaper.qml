import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Qcm.Material as MD
import Qt.labs.settings 1.0

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
    onSourceChanged: walpaper_settings.sync()

    source: "/dev/shm/lock_eDP-1.ppm"
    property string newUrl: ""
    onNewUrlChanged: {
        walpaper_animation.running = true;
    }

    MD.Pane {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: title.width + 100
        height: mainPart.implicitHeight + (copyright.height * 2.5)
        anchors.margins: 20
        padding: 10
        backgroundColor: Qt.alpha(MD.MProp.color.surface, 0.4)
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
                    anchors.right: parent.right
                    typescale: MD.Token.typescale.title_large
                    text: "Salt evaporation ponds on the island of Gozo, Malta"
                }
                MD.Button {
                    id: control
                    width: parent.width
                    height: desc.implicitHeight + 4

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
                        width: parent.width
                        elide: Text.ElideRight
                        maximumLineCount: 5
                        anchors.centerIn: parent

                        typescale: MD.Token.typescale.body_small
                        wrapMode: Text.WordWrap
                        text: "Xwejni Bay in Gozo, Malta, has a way of making everyday elements look like a quiet choreography between sea, stone and sun. You can't help but pause and look closer, right? Centuries back, families began carving these limestone pans, shaping hundreds of basins that trap seawater with each wave. Once the water settles in, the sun's heat does the rest, slowly evaporating it into natural Mediterranean salt. Gozo became a salt-making hub because its limestone coast is easy to shape, and its warm, dry summers keep the crystallisation process steady. The first crystals form around May, marking the beginning of the harvesting season. Workers rake the salt by hand, sweep it with brooms and brushes, gather it into small piles to dry for another day, then bag it and store it in the caves.\nVisitors can walk right up to the pans along the shore, but look out for 'no trespassing' signs. If you swing by in the summer, you might spot active raking and drying. Take a moment to enjoy the view, and before you head back, consider collecting a salty souvenir from one of the many gourmet shops around Malta."
                    }
                }
            }
            MD.Label {
                id: copyright
                // Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                text: "test"
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
                title.text = _title;
                desc.text = _desc;
                copyright.text = _copyright;
            }
        }
    }
}
