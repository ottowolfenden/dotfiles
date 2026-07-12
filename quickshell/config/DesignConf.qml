pragma Singleton
import QtQuick
import ".."

QtObject {
    readonly property int spacing: 8
    readonly property int iconTextSpacing: 4
    readonly property int componentHeight: 30
    readonly property int barHeight: componentHeight + spacing * 2
    readonly property int fontSize: 15
    readonly property int smallFontSize: 13
    readonly property int radius: 7
    readonly property int smallRadius: 4
    readonly property int blurRadius: 70
    readonly property string fontFamily: FontsConf.googleSansFlex
    readonly property string monospaceFontFamily: FontsConf.inconsolata
    readonly property int animationDuration: 200
    readonly property int listAnimationDuration: 150
    readonly property int buttonColourAnimationDuration: 100
    readonly property int circleButtonDiameter: 33
    readonly property int easing: Easing.OutCubic
    readonly property int bafMsDelay: 1500
    readonly property int sliderWidth: 250
    readonly property int sliderHeight: 45
    readonly property int sliderHandleOffset: 15
    readonly property int searchBoxWidth: 320
}
