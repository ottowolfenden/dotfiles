pragma Singleton
import QtQuick

QtObject {
    readonly property int pixelSize: 15
    readonly property int smallPixelSize: 13
    readonly property string mainFamily: googleSansFlex
    readonly property string monospaceFamily: "Consolas"

    readonly property string googleSansFlex: googleSansFlexLoader.name
    readonly property FontLoader googleSansFlexLoader: FontLoader {
        source: "../assets/fonts/google-sans-flex.ttf"
    }

    readonly property string materialSymbols: materialSymbolsLoader.name
    readonly property FontLoader materialSymbolsLoader: FontLoader {
        source: "../assets/fonts/material-symbols.ttf"
    }

    readonly property string customMaterialSymbols: customMaterialSymbolsLoader.name
    readonly property FontLoader customMaterialSymbolsLoader: FontLoader {
        source: "../assets/fonts/custom-material-symbols.ttf"
    }

    readonly property string inconsolata: inconsolataLoader.name
    readonly property FontLoader inconsolataLoader: FontLoader {
        source: "../assets/fonts/inconsolata.ttf"
    }
}
