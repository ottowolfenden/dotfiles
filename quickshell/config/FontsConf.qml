pragma Singleton
import QtQuick

QtObject {
    readonly property int pixelSize: 15
    readonly property int smallPixelSize: 13
    readonly property string mainFamily: googleSansFlex
    readonly property string monospaceFamily: inconsolata

    readonly property string googleSansFlex: googleSansFlexLoader.name
    readonly property FontLoader googleSansFlexLoader: FontLoader {
        source: "../assets/fonts/google-sans-flex.ttf"
    }

    readonly property string materialSymbolsOutlined: materialSymbolsOutlinedLoader.name
    readonly property FontLoader materialSymbolsOutlinedLoader: FontLoader {
        source: "../assets/fonts/material-symbols-outlined.ttf"
    }

    readonly property string customMaterialSymbolsOutlined: customMaterialSymbolsOutlinedLoader.name
    readonly property FontLoader customMaterialSymbolsOutlinedLoader: FontLoader {
        source: "../assets/fonts/custom-material-symbols-outlined.ttf"
    }

    readonly property string inconsolata: inconsolataLoader.name
    readonly property FontLoader inconsolataLoader: FontLoader {
        source: "../assets/fonts/inconsolata.ttf"
    }
}
