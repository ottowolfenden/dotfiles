pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../.."

QtObject {
    id: fileSearchService

    property list<var> fsEntries: [
        {
            type: "file",
            path: "invalid",
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
            type: "file",
            path: "",
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
            type: "file",
            path: "/home/otto/wallpapers/artemis\\\\.jpg",
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
            type: "file",
            path: "/home/otto/wallpapers/cumulus (copy 1).jpg",
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
            type: "file",
            path: "/home/otto/wallpapers/cumulus (copy 2)",
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
            type: "file",
            path: "/home/otto/wallpapers/test",
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
            type: "file",
            path: "/home/otto/wallpapers/test\\test.jpg",
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
        },
        {
            type: "folder",
            path: "/home/otto/t\\\\\\\\est",
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

    function open(fsEntry: var, inNewWs: bool, checkStatus: var): void {
        if (!checkStatus && fsEntry.type == "file") {
            proc.fsEntry = fsEntry;
            proc.inNewWs = inNewWs;
            proc.running = true;
        }
        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            openTimer.fsEntryToOpen = fsEntry;
            openTimer.checkStatus = checkStatus;
            openTimer.running = true;
        } else {
            if (fsEntry.type == "folder" || checkStatus == "fail")
                HyprlandService.execWithQsTag(`thunar '${fsEntry.path}'`);
            else if (fsEntry.type == "file" && checkStatus == "success")
                HyprlandService.execWithQsTag(`xdg-open '${fsEntry.path}'`);
        }
    }

    property Process checkCanOpenProcess: Process {
        id: proc
        property var fsEntry: null
        property var inNewWs: null
        command: fsEntry?.path ? ["sh", "-c", `xdg-mime query default $(xdg-mime query filetype '${fsEntry.path}')`] : []
        stdout: StdioCollector {
            onStreamFinished: {
                fileSearchService.open(proc.fsEntry, proc.inNewWs, text.trim() == "" ? "fail" : "success");
                proc.fsEntry = null;
                proc.inNewWs = null;
            }
        }
    }

    property Timer openTimer: Timer {
        property var fsEntryToOpen: null
        property var checkStatus: null
        interval: 100
        onTriggered: {
            if (fsEntryToOpen && checkStatus !== null) {
                parent.open(fsEntryToOpen, false, checkStatus);
                fsEntryToOpen = null;
                checkStatus = null;
            }
        }
    }
}
