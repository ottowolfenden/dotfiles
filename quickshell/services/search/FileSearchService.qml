pragma Singleton
import QtQuick
import "../.."

QtObject {
    property list<var> fsEntries: [
        {
            type: "file",
            path: "/home/otto/wallpapers/artemis.jpg",
            created: new Date(),
            modified: new Date(),
            accessed: new Date(),
            byteSize: null,
            isRootOwned: false,
            get name() {
                return getName(this);
            },
            get format() {
                return getFormat(this);
            },
            get icon() {
                return getIcon(this);
            }
        },
        {
            type: "folder",
            path: "/home/otto/wallpapers",
            created: new Date(),
            modified: new Date(),
            accessed: new Date(),
            byteSize: null,
            isRootOwned: false,
            numFiles: 20,
            numFolders: 4,
            get name() {
                return getName(this);
            },
            get format() {
                return getFormat(this);
            },
            get icon() {
                return getIcon(this);
            }
        }
    ]

    function getName(fsEntry: var): string {
        let parts = fsEntry.path.split("/");
        return parts[parts.length - 1];
    }
    function getFormat(file: var): string {
        let parts = getName(file).split(".");
        if (parts.length <= 1)
            return "";
        return parts[parts.length - 1].toLowerCase();
    }
    function getIcon(fsEntry: var): string {
        if (fsEntry.type == "file")
            return IconsConf.fileFormats[getFormat(fsEntry)] ?? IconsConf.fileFormats.default;
        else if (fsEntry.type == "folder")
            return IconsConf.folders[fsEntry.isRootOwned ? "rootOwned" : "default"];
    }

    function search(text: string, mode: string): var {
        let max = MiscService.getMaxSearchResults("files", mode);

        return fsEntries;
    }

    function open(fsEntry: var, inNewWs: bool): void {
        console.log(fsEntry.name);
    }
}
