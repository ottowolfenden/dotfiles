import QtQuick
import QtQuick.Layouts
import ".."
import "../animations"

Item {
    id: root
    property string bgColour: ColoursConf.bg4.t
    property string fgColour: ColoursConf.lightblue

    Layout.preferredHeight: DesignConf.progressBarHeight
    Layout.fillWidth: true

    Component.onCompleted: [leftTrack, activeTrack, rightTrack].forEach(t => {
        t.radius = Infinity;
        t.anchors.top = top;
        t.anchors.bottom = bottom;
    })

    Rectangle {
        id: leftTrack
        anchors.left: parent.left
        anchors.right: activeTrack.left
        anchors.rightMargin: DesignConf.spacing
        color: root.bgColour
    }
    Rectangle {
        id: activeTrack
        color: root.fgColour
    }
    Rectangle {
        id: rightTrack
        anchors.left: activeTrack.right
        anchors.right: parent.right
        anchors.leftMargin: DesignConf.spacing
        color: root.bgColour
    }

    LoadingBarAnim {
        width: root.width
        isPlaying: root.visible
        activeTrack: activeTrack
    }
}
