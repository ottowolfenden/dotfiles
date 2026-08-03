pragma Singleton
import QtQuick

QtObject {
    readonly property bool is24hrFormat: false
    readonly property bool showSecondsByDefault: false
    readonly property bool showNumberDateByDefault: false
    readonly property string dateSeparator: "/"
}
