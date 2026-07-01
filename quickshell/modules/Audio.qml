pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
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

    readonly property var sink: Pipewire.defaultAudioSink
    property var players: Mpris.players.values ?? []
    function orderPlayers() {
        if (!Mpris.players)
            return [];
        let playingPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Playing);
        let pausedPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Paused);
        audio.players = playingPlayers.concat(pausedPlayers);
    }
    readonly property int percent: Math.round(sink?.audio.volume * 100)

    RowLayout {
        id: container
        spacing: Config.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            iconName: Icons.volume?.find(i => i.muted == audio.sink?.audio?.muted || audio.percent <= i.max)?.icon
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
                audio.sink.audio.volume = Helpers.clamp(audio.sink.audio.volume + 0.02, 0, 1);
            else if (wheel.angleDelta.y < 0)
                audio.sink.audio.volume = Helpers.clamp(audio.sink.audio.volume - 0.02, 0, 1);
        }
    }

    Flyout {
        id: volumeFlyout
        parentX: audio.x
        rectWidth: pane.implicitWidth
        rectHeight: pane.implicitHeight
        onOpened: {
            audio.orderPlayers();
            list.highlightMoveDuration = 0;
            list.currentIndex = 0;
            list.highlightMoveDuration = Config.listAnimationDuration;
        }

        Pane {
            id: pane
            padding: Config.spacing
            background: null

            ColumnLayout {
                anchors.fill: parent
                spacing: Config.spacing

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: mediaContainer.width
                    Layout.preferredHeight: mediaContainer.height
                    visible: audio.players.length != 0

                    RowLayout {
                        id: mediaContainer
                        IconButton {
                            iconName: "chevron_backward"
                            buttonPixelSize: 23
                            onClicked: list.decrementCurrentIndex()
                            disabled: list.currentIndex == 0
                            visible: audio.players.length > 1
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
                                highlightMoveDuration: Config.listAnimationDuration

                                model: audio.players
                                delegate: ColumnLayout {
                                    id: item
                                    required property var modelData
                                    spacing: Config.spacing

                                    Text {
                                        id: identityText
                                        text: Config.playerIdentityNames[item.modelData.identity] ?? item.modelData.identity
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: buttonsContainer.implicitWidth
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
                                        id: buttonsContainer
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
                            visible: audio.players.length > 1
                            Layout.alignment: Qt.AlignTop
                        }
                    }
                }

                Slider {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 45
                    Layout.alignment: Qt.AlignHCenter

                    value: audio.sink?.audio?.volume ?? 0
                    onChanged: newValue => audio.sink.audio.volume = newValue
                    iconName: {
                        let btDevice = Helpers.sinkToBtDevice(audio.sink);
                        if (btDevice)
                            return Icons.devices[btDevice.icon] ?? Icons.devices["bluetooth"];
                        if (!audio.sink?.properties)
                            return Icons.devices["computer"];
                        let sinkIcon = audio.sink.properties["device.icon_name"] || audio.sink.properties["device.icon-name"];
                        console.log(sinkIcon);
                        if (sinkIcon)
                            return Icons.devices[sinkIcon] ?? Icons.devices["computer"];
                        return Icons.devices["computer"];
                    }
                }
            }
        }
    }
}
