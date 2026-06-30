pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
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
    readonly property var players: {
        if (!Mpris.players)
            return [];
        let playingPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Playing);
        let pausedPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Paused);
        return playingPlayers.concat(pausedPlayers);
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
                Item {
                    Layout.preferredWidth: mediaContainer.width
                    Layout.preferredHeight: mediaContainer.height

                    RowLayout {
                        id: mediaContainer
                        IconButton {
                            iconName: "chevron_backward"
                            buttonPixelSize: 23
                            onClicked: list.decrementCurrentIndex()
                            disabled: list.currentIndex == 0
                            Layout.alignment: Qt.AlignTop
                        }
                        Rectangle {
                            Layout.preferredWidth: list.width + Config.spacing * 2
                            Layout.preferredHeight: list.height + Config.spacing * 2
                            color: Config.colours.bg2
                            radius: Config.radius
                            clip: true

                            ListView {
                                id: list
                                visible: audio.players.length != 0
                                width: currentItem?.width ?? 0
                                height: currentItem?.height ?? 0
                                anchors.centerIn: parent
                                orientation: ListView.Horizontal
                                spacing: Config.spacing * 2

                                boundsBehavior: Flickable.StopAtBounds
                                snapMode: ListView.SnapToItem
                                highlightRangeMode: ListView.StrictlyEnforceRange
                                highlightMoveDuration: 150

                                model: audio.players
                                delegate: ColumnLayout {
                                    id: item
                                    required property var modelData
                                    spacing: Config.spacing

                                    Text {
                                        id: identityText
                                        text: Config.playerIdentityNames[item.modelData.identity] ?? item.modelData.identity
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: 80
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                        color: Config.colours.fg1
                                        font.family: Config.fontFamily
                                        font.pixelSize: Config.smallFontSize
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (item.modelData.canRaise)
                                                    item.modelData.raise();
                                                else {
                                                    Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ window = 'initialclass:(?i)" + item.modelData.identity.toLowerCase() + "' })"]);
                                                    QsState.hideAllFlyouts();
                                                }
                                            }
                                        }
                                    }

                                    RowLayout {
                                        property bool validPlayerPresent: {
                                            if (audio.players.length == 0)
                                                return false;
                                            let isActive = [MprisPlaybackState.Paused, MprisPlaybackState.Playing].includes(item.modelData.playbackState);
                                            return isActive && Config.playerRequirements.every(r => item.modelData[r]);
                                        }
                                        onValidPlayerPresentChanged: {
                                            if (!validPlayerPresent)
                                                visibilityTimer.restart();
                                        }
                                        visible: validPlayerPresent || visibilityTimer.running
                                        spacing: Config.spacing * 2
                                        Layout.alignment: Qt.AlignHCenter
                                        IconButton {
                                            iconName: "skip_previous"
                                            disabled: !item.modelData.canGoPrevious && !visibilityTimer.running
                                            onClicked: {
                                                if (!disabled)
                                                    item.modelData.previous();
                                            }
                                        }
                                        IconButton {
                                            iconName: item.modelData.isPlaying || visibilityTimer.running ? "pause" : "play_arrow"
                                            buttonPixelSize: Config.circleButtonDiameter * 1.3
                                            onClicked: item.modelData.togglePlaying()
                                        }
                                        IconButton {
                                            iconName: "skip_next"
                                            disabled: !item.modelData.canGoNext && !visibilityTimer.running
                                            onClicked: {
                                                if (!disabled)
                                                    item.modelData.next();
                                            }
                                        }

                                        Timer {
                                            id: visibilityTimer
                                            interval: 1500
                                            repeat: false
                                            running: false
                                        }
                                    }
                                }
                            }
                        }
                        IconButton {
                            iconName: "chevron_forward"
                            buttonPixelSize: 23
                            onClicked: list.incrementCurrentIndex()
                            disabled: list.currentIndex == list.count - 1
                            Layout.alignment: Qt.AlignTop
                        }
                    }
                }
                ColumnLayout {
                    Repeater {}
                }
            }
        }
    }
}
