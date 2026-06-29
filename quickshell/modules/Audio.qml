import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import ".."
import "../components"

Rectangle {
    id: audio
    color: "transparent"
    radius: Config.radius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    Layout.preferredHeight: Config.componentHeight

    Cutout {}

    readonly property var sink: Pipewire.defaultAudioSink?.audio
    readonly property var player: {
        if (!Mpris.players || Mpris.players.values.length == 0)
            return null;
        return Mpris.players.values.find(p => p.playbackState);
    }
    readonly property int percent: Math.round(sink?.volume * 100)

    RowLayout {
        id: container
        spacing: Config.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            iconName: Icons.volume?.find(i => i.muted == audio.sink?.muted || audio.percent <= i.max)?.icon
        }

        Text {
            text: audio.percent + "%"
            color: Config.colours.fg1
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 40
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    FlyoutMouseArea {
        flyout: volumeFlyout

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                audio.sink.volume = Math.min(audio.sink.volume + 0.01, 1);
            else if (wheel.angleDelta.y < 0)
                audio.sink.volume -= 0.01;
        }
    }

    Flyout {
        id: volumeFlyout
        parentX: audio.x
        rectWidth: pane.implicitWidth
        rectHeight: pane.implicitHeight

        Pane {
            id: pane
            padding: Config.spacing
            background: null

            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                RowLayout {
                    property bool validPlayerPresent: (audio?.player?.playbackState ?? false) && Config.playerRequirements.every(r => audio?.player[r])
                    onValidPlayerPresentChanged: visibilityTimer.running = !validPlayerPresent
                    visible: validPlayerPresent || visibilityTimer.running
                    spacing: Config.spacing * 2
                    Layout.alignment: Qt.AlignHCenter

                    IconButton {
                        iconName: "skip_previous"
                        onClicked: audio.player.previous()
                    }
                    IconButton {
                        iconName: audio?.player?.isPlaying ? "pause" : "play_arrow"
                        buttonPixelSize: Config.circleButtonDiameter * 1.3
                        onClicked: audio.player.playbackState == MprisPlaybackState.Playing ? audio.player.pause() : audio.player.play()
                    }
                    IconButton {
                        iconName: "skip_next"
                        onClicked: audio.player.next()
                    }

                    Timer {
                        id: visibilityTimer
                        interval: 1500
                        repeat: false
                        running: false
                    }
                }
                ColumnLayout {
                    Repeater {}
                }
            }
        }
    }
}
