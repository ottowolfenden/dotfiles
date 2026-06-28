import QtQuick
import ".."

MouseArea {
    required property Flyout flyout

    property bool reopening: false
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onPressed: {
        if (flyout.isOpen) {
            QsState.flyoutsHandler.hide();
            reopening = true;
        } else
            reopening = false;
    }
    onReleased: {
        flyout.parentX = parent.mapToItem(null, parent.width / 2, 0).x;
        flyout.isOpen = !flyout.isOpen && !reopening;
    }
}
