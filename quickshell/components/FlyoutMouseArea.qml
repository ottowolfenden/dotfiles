import QtQuick
import ".."

MouseArea {
    required property Flyout flyout
    property bool reopening: false

    signal leftClicked
    signal rightClicked
    signal middleClicked

    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onPressed: mouse => {
        switch (mouse.button) {
        case Qt.LeftButton:
            leftClicked();
            if (flyout.isOpen) {
                QsState.flyoutsHandler.hideNonHoveredFlyouts();
                reopening = true;
            } else
                reopening = false;
            break;
        case Qt.RightButton:
            rightClicked();
            break;
        case Qt.MiddleButton:
            middleClicked();
            break;
        }
    }
    onReleased: mouse => {
        if (mouse.button != Qt.LeftButton)
            return;
        flyout.parentX = parent.mapToItem(null, parent.width / 2, 0).x;
        flyout.isOpen = !flyout.isOpen && !reopening;
    }

    function open() {
        if (flyout.isOpen) {
            QsState.flyoutsHandler.hideNonHoveredFlyouts();
            reopening = true;
        } else
            reopening = false;

        flyout.parentX = parent.mapToItem(null, parent.width / 2, 0).x;
        flyout.isOpen = !flyout.isOpen && !reopening;
    }
}
