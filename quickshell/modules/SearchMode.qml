import QtQuick
import QtQuick.Layouts
import ".."
import "../components"

Rectangle {
    id: root
    required property Search search
    readonly property string mode: search.mode
    property string cachedMode

    color: "transparent"
    radius: DesignConf.radius
    Layout.preferredHeight: DesignConf.componentHeight
    clip: true

    implicitWidth: search.mode == "default" ? 0 : modeRow.implicitWidth + DesignConf.spacing * 2
    onModeChanged: cachedMode = mode == "default" ? cachedMode : mode
    opacity: root.search.mode != "default"

    Behavior on opacity {
        NumberAnimation {
            duration: DesignConf.listAnimationDuration
            easing: DesignConf.easing
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: DesignConf.listAnimationDuration
            easing: DesignConf.easing
        }
    }

    Cutout {}

    RowLayout {
        id: modeRow
        spacing: DesignConf.iconTextSpacing
        anchors.fill: parent
        anchors.leftMargin: DesignConf.spacing
        anchors.rightMargin: DesignConf.spacing

        Icon {
            iconName: root.cachedMode ? IconsConf.searchMode[root.cachedMode] : ""
        }

        Text {
            text: SearchConf.modes.find(m => m.name == root.cachedMode)?.displayName ?? ""
            color: ColoursConf.fg1.t
            font.family: FontsConf.mainFamily
            font.pixelSize: FontsConf.pixelSize
            Layout.fillWidth: true
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        onWheel: wheel => root.search.changeMode(wheel.angleDelta.y > 0 ? 1 : -1)
        onClicked: root.search.mode = "default"
    }
}
