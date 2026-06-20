import QtQuick
import Quickshell.Services.Pipewire
import QtQuick.Layouts
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: container.width + (Config.spacing * 2)
    Layout.fillHeight: true

    RowLayout {
        id: container
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.spacing * 1.7

        property bool isBluetooth: Pipewire.defaultAudioSink.properties["device.api"] == "bluez5"
        property int volPercent: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)

        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink]
        }

        Item {
            implicitHeight: icon.height
            implicitWidth: icon.width
            Icon {
                id: icon
                iconName: {
                    if (Pipewire.defaultAudioSink.audio.muted)
                        return "no_sound";
                    if (container.volPercent == 0)
                        return "volume_mute";
                    if (container.volPercent <= 50)
                        return "volume_down";
                    if (container.volPercent > 50)
                        return "volume_up";
                    return "error";
                }
            }
        }

        Item {
            implicitHeight: volPercentage.height
            implicitWidth: volPercentage.width
            Text {
                id: volPercentage
                text: container.volPercent + "%"
                color: Config.colours.fg1
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
                width: 50
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        property var audio: Pipewire.defaultAudioSink.audio
        onClicked: audio.muted = !audio.muted
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                audio.volume = Math.min(audio.volume + 0.01, 1);
            else if (wheel.angleDelta.y < 0)
                audio.volume -= 0.01;
        }
    }
}
