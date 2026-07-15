import QtQuick
import QtQuick.Controls

Repeater {
    required property string mode
    required property TextField searchInput
    required property int activeIndex
    readonly property QtObject activeItem: model[activeIndex] ?? null
    readonly property string modeSupplied: "web"
    signal activeIndexSet(index: int)

    model: []
}
