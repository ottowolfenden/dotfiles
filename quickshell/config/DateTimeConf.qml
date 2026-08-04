pragma Singleton
import QtQuick

QtObject {
    readonly property bool is24hrFormat: false
    readonly property bool showSecondsByDefault: false
    readonly property bool showNumberDateByDefault: false
    readonly property string dateSeparator: "/"
    readonly property bool time0Padding: true
    readonly property bool date0Padding: true
    readonly property bool variableTimeWidth: false
    readonly property bool variableDateWidth: false
    readonly property bool variableWordDateWidth: true
}
