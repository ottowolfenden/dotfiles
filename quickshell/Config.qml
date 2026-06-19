pragma Singleton
import QtQuick

QtObject {
    property bool darkMode: false
    property int fontSize: 15
    property int borderRadius: 5
    property int spacing: 9
    property string font: "Google Sans Flex"
    property var colours: this.darkMode ? {
        bg: "#aa000000",
        fg1: "#d8ffffff",
        fg2: "#55ffffff",
        fg3: "#a2a2a2",
        red: "#f07178",
        orange: "#f78c6c",
        yellow: "#ffcb6b",
        green: "#c3e88d",
        lightblue: "#89ddff",
        darkblue: "#82aaff",
        purple: "#c792ea",
        pink: "#ff9cac"
    } : {
        bg: "#aaffffff",
        fg1: "#d8000000",
        fg2: "#55000000",
        fg3: "#545454",
        red: "#ea4335",
        orange: "#f57c00",
        yellow: "#fbbc05",
        green: "#34a853",
        lightblue: "#4285f4",
        darkblue: "#0057ca",
        purple: "#7248b9",
        pink: "#ff80ab"
    }
}
