pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import ".."
import "../components"

Rectangle {
    id: audio
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: container.implicitWidth + (DesignConf.spacing * 2)
    Layout.preferredHeight: DesignConf.componentHeight

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property int percent: Math.round(sink?.audio.volume * 100)
    property list<MprisPlayer> players: Mpris.players.values ?? []

    Cutout {}

    RowLayout {
        id: container
        spacing: DesignConf.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: DesignConf.spacing
        anchors.rightMargin: DesignConf.spacing

        Icon {
            id: barIcon
            iconName: IconsConf.volume?.find(i => i.muted == audio.sink?.audio?.muted || audio.percent <= i.max)?.icon
        }

        Text {
            text: audio.percent + "%"
            color: ColoursConf.fg1
            font.family: FontsConf.mainFamily
            font.pixelSize: FontsConf.pixelSize
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 40
        }
    }

    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    FlyoutMouseArea {
        flyout: volumeFlyout

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                audio.sink.audio.volume = MiscService.clamp(audio.sink.audio.volume + 0.02, 0, 1);
            else if (wheel.angleDelta.y < 0)
                audio.sink.audio.volume = MiscService.clamp(audio.sink.audio.volume - 0.02, 0, 1);
        }

        onMiddleClicked: audio.sink.audio.muted = !audio.sink.audio.muted
    }

    Timer {
        id: refilterPlayersTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: audio.players = AudioService.getFilteredPlayers()
    }

    Flyout {
        id: volumeFlyout
        parentX: audio.x
        rectWidth: pane.implicitWidth
        rectHeight: pane.implicitHeight
        onOpened: {
            audio.players = AudioService.getFilteredPlayers();
            list.highlightMoveDuration = 0;
            list.currentIndex = 0;
            list.highlightMoveDuration = DesignConf.listAnimationDuration;
            refilterPlayersTimer.restart();
        }

        Pane {
            id: pane
            padding: DesignConf.spacing
            background: null

            ColumnLayout {
                spacing: DesignConf.spacing

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: mediaContainer.width
                    Layout.preferredHeight: mediaContainer.height
                    visible: audio.players.length != 0

                    RowLayout {
                        id: mediaContainer
                        IconButton {
                            iconName: IconsConf.backward
                            buttonPixelSize: 23
                            onClicked: list.decrementCurrentIndex()
                            disabled: list.currentIndex == 0
                            visible: audio.players.length > 1
                            Layout.alignment: Qt.AlignTop
                        }
                        Rectangle {
                            Layout.preferredWidth: list.width + DesignConf.spacing * 2
                            Layout.preferredHeight: list.height + DesignConf.spacing * 2
                            color: ColoursConf.bg2
                            radius: DesignConf.radius
                            clip: true

                            ListView {
                                id: list
                                visible: audio.players.length != 0
                                width: currentItem?.width ?? 0
                                height: currentItem?.height ?? 0
                                anchors.centerIn: parent
                                orientation: ListView.Horizontal
                                spacing: DesignConf.spacing * 2

                                boundsBehavior: Flickable.StopAtBounds
                                snapMode: ListView.SnapToItem
                                highlightRangeMode: ListView.StrictlyEnforceRange
                                highlightMoveDuration: DesignConf.listAnimationDuration

                                model: audio.players
                                delegate: ColumnLayout {
                                    id: item
                                    required property MprisPlayer modelData
                                    spacing: DesignConf.spacing

                                    Text {
                                        id: identityText
                                        text: AudioConf.playerIdentityNames[item.modelData.identity] ?? item.modelData.identity
                                        Layout.fillWidth: true
                                        Layout.preferredWidth: buttonsContainer.implicitWidth
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                        color: ColoursConf.fg1
                                        font.family: FontsConf.mainFamily
                                        font.pixelSize: FontsConf.smallPixelSize
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (item.modelData.canRaise)
                                                    item.modelData.raise();
                                                else {
                                                    Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ window = 'initialclass:(?i)" + item.modelData.identity.toLowerCase() + "' })"]);
                                                    FlyoutsService.hideAllFlyouts();
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
                                            return isActive && AudioConf.playerRequirements.every(r => item.modelData[r]);
                                        }
                                        onValidPlayerPresentChanged: {
                                            if (!validPlayerPresent)
                                                visibilityTimer.restart();
                                        }
                                        visible: validPlayerPresent || visibilityTimer.running
                                        spacing: DesignConf.spacing * 2
                                        Layout.alignment: Qt.AlignHCenter

                                        IconButton {
                                            iconName: IconsConf.media.skipBack
                                            disabled: !item.modelData.canGoPrevious && !visibilityTimer.running
                                            buttonPixelSize: DesignConf.circleButtonDiameter * 0.9
                                            onClicked: {
                                                if (!disabled)
                                                    item.modelData.previous();
                                            }
                                        }
                                        IconButton {
                                            iconName: IconsConf.media[item.modelData.isPlaying || visibilityTimer.running ? "pause" : "play"]
                                            buttonPixelSize: DesignConf.circleButtonDiameter * 1.2
                                            onClicked: item.modelData.togglePlaying()
                                        }
                                        IconButton {
                                            iconName: IconsConf.media.skip
                                            disabled: !item.modelData.canGoNext && !visibilityTimer.running
                                            buttonPixelSize: DesignConf.circleButtonDiameter * 0.9
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
                            iconName: IconsConf.forward
                            buttonPixelSize: 23
                            onClicked: list.incrementCurrentIndex()
                            disabled: list.currentIndex == list.count - 1
                            visible: audio.players.length > 1
                            Layout.alignment: Qt.AlignTop
                        }
                    }
                }

                Slider {
                    value: audio.sink?.audio?.volume ?? 0
                    onChanged: newValue => audio.sink.audio.volume = newValue
                    iconName: repeater.model.length > 1 ? AudioService.getSinkDetails(audio.sink).icon : barIcon.iconName
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: sinkSelection.implicitHeight + DesignConf.spacing * 2
                    color: ColoursConf.bg2
                    radius: DesignConf.radius
                    visible: repeater.model.length > 1

                    ColumnLayout {
                        id: sinkSelection
                        spacing: DesignConf.spacing
                        anchors.fill: parent
                        anchors.margins: DesignConf.spacing

                        Repeater {
                            id: repeater
                            model: AudioService.getFilteredSinks()

                            delegate: Rectangle {
                                id: node
                                required property PwNode modelData
                                property bool isActive: node.modelData == audio.sink
                                property color colour: isActive ? ColoursConf.lightblue : ColoursConf.fg1
                                radius: DesignConf.radius
                                color: {
                                    if (isActive)
                                        return ColoursConf.selectedBg;
                                    if (mouseArea.pressed)
                                        return ColoursConf.buttonPressedBg;
                                    else if (mouseArea.containsMouse)
                                        return ColoursConf.buttonHoveredBg;
                                    return ColoursConf.buttonInactiveBg;
                                }
                                Layout.fillWidth: true
                                Layout.preferredHeight: row.implicitHeight + DesignConf.spacing

                                RowLayout {
                                    id: row
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: DesignConf.spacing / 2
                                    anchors.rightMargin: DesignConf.spacing / 2
                                    Icon {
                                        iconName: node.isActive ? IconsConf.tick : AudioService.getSinkDetails(node.modelData).icon
                                        colour: node.colour
                                        Layout.leftMargin: DesignConf.spacing / 2
                                    }
                                    Text {
                                        id: text
                                        text: AudioService.getSinkDetails(node.modelData).name
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        font.family: FontsConf.mainFamily
                                        font.pixelSize: FontsConf.smallPixelSize
                                        color: node.colour
                                        Layout.leftMargin: DesignConf.spacing / 2
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: Math.round(node.modelData.audio.volume * 100) + "%"
                                        font.strikeout: node.modelData.audio.muted
                                        font.family: FontsConf.mainFamily
                                        font.pixelSize: FontsConf.smallPixelSize
                                        color: node.colour
                                        Layout.rightMargin: DesignConf.spacing / 2
                                    }
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: node.isActive ? undefined : Qt.PointingHandCursor
                                    onClicked: Pipewire.preferredDefaultAudioSink = node.modelData
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: DesignConf.buttonColourAnimationDuration
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
