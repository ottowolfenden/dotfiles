import QtQuick
import Quickshell
import ".."
import "../components"
import "../animations/transitions"

Rectangle {
    color: "transparent"
    radius: DesignConf.radius
    implicitWidth: time.width + date.width + DesignConf.spacing * 3
    implicitHeight: DesignConf.componentHeight

    ShortTrans on implicitWidth {}

    Cutout {}

    SystemClock {
        id: clock
    }

    Item {
        id: time
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: DesignConf.spacing
        width: {
            if (DateTimeConf.variableTimeWidth)
                return timeText.implicitWidth;
            let getMaxW = (strings, pad) => UtilsService.getMaxTextWidth(timeText.font, strings, pad ? 2 : 0);
            let getMaxWRange = (min, max, pad) => getMaxW(UtilsService.getRangeArray(min, max), pad);
            let result = getMaxWRange(0, 59, true) + getMaxW([":"]);
            if (DateTimeConf.is24hrFormat)
                result += getMaxWRange(0, 23, true);
            else
                result += getMaxWRange(1, 12, DateTimeConf.time0Padding) + getMaxW([" am", " pm"]);
            if (isSecondsFormat)
                result += getMaxWRange(0, 59, true) + getMaxW([":"]);
            return result;
        }

        property bool isSecondsFormat: DateTimeConf.showSecondsByDefault
        property string format: {
            let hrs = DateTimeConf.time0Padding ? "hh" : "h";
            let mins = ":mm";
            let secs = isSecondsFormat ? ":ss" : "";
            let suffix = DateTimeConf.is24hrFormat ? "" : " ap";
            return hrs + mins + secs + suffix;
        }

        Text {
            id: timeText
            text: Qt.formatDateTime(clock.date, time.format)
            color: ColoursConf.fg1.t
            font.family: FontsConf.mainFamily
            font.pixelSize: FontsConf.pixelSize
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.isSecondsFormat = !parent.isSecondsFormat
        }
    }

    Item {
        id: date
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: DesignConf.spacing
        anchors.rightMargin: DesignConf.spacing
        width: {
            if (DateTimeConf.variableDateWidth || (DateTimeConf.variableWordDateWidth && !isNumberFormat))
                return dateText.implicitWidth;
            let getMaxW = (strings, pad) => UtilsService.getMaxTextWidth(dateText.font, strings, pad ? 2 : 0);
            let getMaxWRange = (min, max, pad) => getMaxW(UtilsService.getRangeArray(min, max), pad);
            if (isNumberFormat) {
                let maxDayW = getMaxWRange(1, 31, DateTimeConf.date0Padding);
                let maxMonthW = getMaxWRange(1, 12, DateTimeConf.date0Padding);
                let maxYrW = getMaxWRange(0, 99, true);
                let seps = getMaxW([DateTimeConf.dateSeparator]) * 2;
                return maxDayW + maxMonthW + maxYrW + seps;
            } else {
                let maxWeekDayW = getMaxW(["Mon", "Tue", "Wed", "Thu", "Fri"]);
                let maxDayW = getMaxWRange(1, 31);
                let maxMonthW = getMaxW(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);
                let seps = getMaxW([" "]) * 2;
                return maxWeekDayW + maxDayW + maxMonthW + seps;
            }
        }

        property bool isNumberFormat: DateTimeConf.showNumberDateByDefault
        property string format: {
            let days = DateTimeConf.date0Padding ? "dd" : "d";
            let months = DateTimeConf.date0Padding ? "MM" : "M";
            let yrs = "yy";
            return isNumberFormat ? [days, months, yrs].join(`'${DateTimeConf.dateSeparator}'`) : "ddd d MMM";
        }

        Text {
            id: dateText
            text: Qt.formatDateTime(clock.date, date.format)
            color: ColoursConf.fg1.t
            font.family: FontsConf.mainFamily
            font.pixelSize: FontsConf.pixelSize
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.isNumberFormat = !parent.isNumberFormat
        }
    }
}
