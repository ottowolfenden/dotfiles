import QtQuick
import Quickshell.Services.Pipewire
import QtQuick.Layouts
import ".."

Rectangle {
    id: volume
    color: Config.colours.bg
    radius: Config.borderRadius
    Layout.fillHeight: true
    implicitWidth: container.implicitWidth + (Config.spacing * 2)
    implicitHeight: container.implicitHeight + (Config.spacing * 2)

    property var audio: Pipewire.defaultAudioSink.audio
    property int percent: Math.round(audio.volume * 100)

    RowLayout {
        id: container
        spacing: Config.spacing
        anchors.fill: parent
        anchors.leftMargin: Config.spacing
        anchors.rightMargin: Config.spacing

        Icon {
            iconName: Config.audioIcons.find(i => i.muted == volume.audio.muted || volume.percent <= i.max).icon
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

    Timer {
        interval: 300
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: volume.percent = Math.min(Math.random() * 300, 100)
    }
}
