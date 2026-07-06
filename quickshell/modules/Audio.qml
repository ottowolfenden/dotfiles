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
    radius: Config.radius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    Layout.preferredHeight: Config.componentHeight

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property int percent: Math.round(sink?.audio.volume * 100)
    property list<MprisPlayer> players: Mpris.players.values ?? []

    function isEarbud(btDevice: string): bool {
        return btDevice => Config.earbudSubstrings.some(s => btDevice.name.toLowerCase().includes(s) || btDevice.deviceName.toLowerCase().includes(s));
    }
    function filterPlayers(): void {
        if (!Mpris.players)
            return;
        let playingPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Playing);
        let pausedPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Paused);
        audio.players = playingPlayers.concat(pausedPlayers);
    }
    function getSinkDetails(sink: PwNode): var {
        let unknown = {
            icon: Icons.devices["computer"],
            name: "Laptop"
        };

        let btDevice = Helpers.sinkToBtDevice(sink);
        if (btDevice)
            return {
                icon: isEarbud(btDevice) ? Icons.devices["earbud"] : Icons.devices[btDevice.icon] ?? Icons.devices["bluetooth"],
                name: btDevice.name
            };

        if (!sink?.properties)
            return unknown;
        let sinkIcon = sink.properties["device.icon_name"] || sink.properties["device.icon-name"];
        let sinkName = sink.nickname != "" && sink.nickname ? sink.nickname : sink.description;
        if (sinkIcon)
            return {
                icon: Icons.devices[sinkIcon] ?? Icons.devices["computer"],
                name: sinkName && !["", "Speaker"].includes(sinkName) ? sinkName : "Laptop"
            };
        return unknown;
    }

    Cutout {}

    RowLayout {
        id: container
        spacing: Config.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            id: barIcon
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
        objects: Pipewire.nodes.values
    }

    FlyoutMouseArea {
        flyout: volumeFlyout

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                audio.sink.audio.volume = Helpers.clamp(audio.sink.audio.volume + 0.02, 0, 1);
            else if (wheel.angleDelta.y < 0)
                audio.sink.audio.volume = Helpers.clamp(audio.sink.audio.volume - 0.02, 0, 1);
        }

        onMiddleClicked: audio.sink.audio.muted = !audio.sink.audio.muted
    }

    Timer {
        id: refilterPlayersTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: audio.filterPlayers()
    }

    Flyout {
        id: volumeFlyout
        parentX: audio.x
        rectWidth: pane.implicitWidth
        rectHeight: pane.implicitHeight
        onOpened: {
            audio.filterPlayers();
            list.highlightMoveDuration = 0;
            list.currentIndex = 0;
            list.highlightMoveDuration = Config.listAnimationDuration;
            refilterPlayersTimer.restart();
        }

        Pane {
            id: pane
            padding: Config.spacing
            background: null

            ColumnLayout {
                spacing: Config.spacing

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: mediaContainer.width
                    Layout.preferredHeight: mediaContainer.height
                    visible: audio.players.length != 0

                    RowLayout {
                        id: mediaContainer
                        IconButton {
                            iconName: Icons.backward
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
                                    required property MprisPlayer modelData
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
                                            iconName: Icons.media.skipBack
                                            disabled: !item.modelData.canGoPrevious && !visibilityTimer.running
                                            buttonPixelSize: Config.circleButtonDiameter * 0.9
                                            onClicked: {
                                                if (!disabled)
                                                    item.modelData.previous();
                                            }
                                        }
                                        IconButton {
                                            iconName: Icons.media[item.modelData.isPlaying || visibilityTimer.running ? "pause" : "play"]
                                            buttonPixelSize: Config.circleButtonDiameter * 1.2
                                            onClicked: item.modelData.togglePlaying()
                                        }
                                        IconButton {
                                            iconName: Icons.media.skip
                                            disabled: !item.modelData.canGoNext && !visibilityTimer.running
                                            buttonPixelSize: Config.circleButtonDiameter * 0.9
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
                            iconName: Icons.forward
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
                    iconName: repeater.model.length > 1 ? audio.getSinkDetails(audio.sink).icon : barIcon.iconName
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: sinkSelection.implicitHeight + Config.spacing * 2
                    color: Config.colours.bg2
                    radius: Config.radius
                    visible: repeater.model.length > 1

                    ColumnLayout {
                        id: sinkSelection
                        spacing: Config.spacing
                        anchors.fill: parent
                        anchors.margins: Config.spacing

                        Repeater {
                            id: repeater
                            model: {
                                let containsHdmi = pwNode => pwNode.name.concat(pwNode.description).toLowerCase().includes("hdmi");
                                let filtered = Pipewire.nodes.values.filter(n => n.audio && n.ready && !n.isStream && n.isSink && (Config.showHdmiSinks || !containsHdmi(n)));
                                filtered.sort((a, b) => audio.getSinkDetails(a).name > audio.getSinkDetails(b).name ? 1 : -1);
                                let target = filtered.find(n => n.name == Config.mainPwNodeName);
                                if (!target)
                                    return filtered;
                                let result = [target, ...filtered.filter(item => item != target)];
                                return result;
                            }

                            delegate: Rectangle {
                                id: node
                                required property PwNode modelData
                                property bool isActive: node.modelData == audio.sink
                                property string colour: isActive ? Config.colours.lightblue : Config.colours.fg1
                                radius: Config.radius
                                color: {
                                    if (isActive)
                                        return Config.colours.selectedBg;
                                    if (mouseArea.pressed)
                                        return Config.colours.buttonPressedBg;
                                    else if (mouseArea.containsMouse)
                                        return Config.colours.buttonHoveredBg;
                                    return Config.colours.buttonInactiveBg;
                                }
                                Layout.fillWidth: true
                                Layout.preferredHeight: row.implicitHeight + Config.spacing

                                RowLayout {
                                    id: row
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: Config.spacing / 2
                                    anchors.rightMargin: Config.spacing / 2
                                    Icon {
                                        iconName: node.isActive ? Icons.tick : audio.getSinkDetails(node.modelData).icon
                                        colour: node.colour
                                        Layout.leftMargin: Config.spacing / 2
                                    }
                                    Text {
                                        id: text
                                        text: audio.getSinkDetails(node.modelData).name
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        font.family: Config.fontFamily
                                        font.pixelSize: Config.smallFontSize
                                        color: node.colour
                                        Layout.leftMargin: Config.spacing / 2
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: Math.round(node.modelData.audio.volume * 100) + "%"
                                        font.strikeout: node.modelData.audio.muted
                                        font.family: Config.fontFamily
                                        font.pixelSize: Config.smallFontSize
                                        color: node.colour
                                        Layout.rightMargin: Config.spacing / 2
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
                                        duration: 100
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
