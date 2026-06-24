import QtQuick
import Quickshell.Services.Pipewire
import QtQuick.Layouts
import ".."

Rectangle {
    id: volume
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    Layout.preferredHeight: Config.barHeight

    property var audio: Pipewire.defaultAudioSink.audio
    property int percent: Math.round(audio.volume * 100)

    RowLayout {
        id: container
        spacing: Config.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            iconName: Icons.audio.find(i => i.muted == volume.audio.muted || volume.percent <= i.max).icon
        }

        Text {
            text: volume.percent + "%"
            color: Config.colours.fg1
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: 40
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: volume.audio.muted = !volume.audio.muted
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                volume.audio.volume = Math.min(volume.audio.volume + 0.01, 1);
            else if (wheel.angleDelta.y < 0)
                volume.audio.volume -= 0.01;
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
