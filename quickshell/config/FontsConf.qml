pragma Singleton
import QtQuick
import ".."

QtObject {
    readonly property int pixelSize: 15
    readonly property int smallPixelSize: 13
    readonly property string mainFamily: googleSansFlex

    readonly property string googleSansFlex: googleSansFlexLoader.name
    readonly property FontLoader googleSansFlexLoader: FontLoader {
        source: "../fonts/google-sans-flex.ttf"
    }

    readonly property string materialSymbolsExtended: materialSymbolsExtendedLoader.name
    readonly property FontLoader materialSymbolsExtendedLoader: FontLoader {
        source: "../fonts/material-symbols-extended-24px.ttf"
    }

    readonly property string materialSymbolsExtendedFill: materialSymbolsExtendedFillLoader.name
    readonly property FontLoader materialSymbolsExtendedFillLoader: FontLoader {
        source: "../fonts/material-symbols-extended-24px-fill.ttf"
    }
}
