import QtQuick
import QtQuick.Layouts
import ".."
import "../modules"

Item {
    id: root
    required property Search search
    default property alias content: contentContainer.children

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.bottomMargin: DesignConf.spacing + DesignConf.radius
    anchors.topMargin: DesignConf.spacing
    anchors.horizontalCenter: parent.horizontalCenter
    width: search.isOpen ? DesignConf.searchGroupWidth : DesignConf.componentHeight

    Behavior on width {
        NumberAnimation {
            duration: DesignConf.animationDuration
            easing: DesignConf.easing
        }
    }

    RowLayout {
        id: contentContainer
        anchors.fill: parent
        spacing: root.search.mode != "default" ? DesignConf.spacing : 0

        Behavior on spacing {
            NumberAnimation {
                duration: DesignConf.animationDuration
                easing: DesignConf.easing
            }
        }
    }
}
