pragma Singleton
import QtQuick
import Quickshell.Io
import "../.."

QtObject {
    id: fileSearchService

    function search(): var {
        return [];
    }

    function open(file: var, inNewWs: bool, checkStatus: var): void {
        if (!checkStatus) {
            checkCanOpenProcess.file = file;
            checkCanOpenProcess.inNewWs = inNewWs;
            checkCanOpenProcess.running = true;
        }

        if (inNewWs) {
            HyprlandService.focusWs("emptynm");
            openTimer.fileToOpen = file;
            openTimer.checkStatus = checkStatus;
            openTimer.running = true;
        } else {
            if (checkStatus == "success")
                HyprlandService.execWithQsTag(`xdg-open '${file.path}'`);
            else if (checkStatus == "fail")
                HyprlandService.execWithQsTag(`thunar '${file.path}'`);
        }
    }

    property Process checkCanOpenProcess: Process {
        id: checkCanOpenProcess
        property var file: null
        property var inNewWs: null
        command: file?.path ? ["sh", "-c", `xdg-mime query default $(xdg-mime query filetype '${file.path}')`] : []
        stdout: StdioCollector {
            onStreamFinished: {
                fileSearchService.open(checkCanOpenProcess.file, checkCanOpenProcess.inNewWs, text.trim() == "" ? "fail" : "success");
                checkCanOpenProcess.file = null;
                checkCanOpenProcess.inNewWs = null;
            }
        }
    }

    property Timer openTimer: Timer {
        property var fileToOpen: null
        property var checkStatus: null
        interval: 100
        onTriggered: {
            if (fileToOpen && checkStatus !== null) {
                parent.open(fileToOpen, false, checkStatus);
                fileToOpen = null;
                checkStatus = null;
            }
        }
    }
}
