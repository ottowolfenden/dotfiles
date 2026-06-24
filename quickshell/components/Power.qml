import QtQuick
import ".."

Rectangle {
    color: Config.colours.bg
    radius: Config.borderRadius
    implicitWidth: Config.barHeight
    implicitHeight: Config.barHeight

    Icon {
        id: icon
        pixelSize: 17
        anchors.centerIn: parent
        iconName: "power_settings_new"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            powerFlyout.visible = true;
            QsState.flyoutsVisible = true;
        }
    }

    PowerFlyout {
        id: powerFlyout
    }
}
