pragma Singleton
import QtQuick
import Quickshell.Bluetooth

QtObject {
    function getWorkspaceExists(workspaces: var, id: int): bool {
        if (workspaces && workspaces.values)
            for (var i = 0; i < workspaces.values.length; i++)
                if (workspaces.values[i] && workspaces.values[i].id == id)
                    return true;
        return false;
    }

    function getRelevantWorkspaceIds(workspaces: var): list<int> {
        var ids = workspaces.values.map(value => value.id);
        return Array.from({
            length: Math.max(...ids)
        }, (_, i) => i + 1);
    }

    function clamp(num: real, min: real, max: real): real {
        return Math.min(Math.max(num, min), max);
    }

    function secsToHrsMins(secs: real): string {
        secs = Math.round(secs);

        if (secs <= 0)
            return "0 secs";

        var hrs = Math.trunc(secs / 3600);
        var minsLeft = Math.trunc((secs % 3600) / 60);
        var secsLeft = secs % 60;

        var hrsLabel = "hr" + (hrs == 1 ? "" : "s");
        var minsLabel = "min" + (minsLeft == 1 ? "" : "s");
        var secsLabel = "sec" + (secsLeft == 1 ? "" : "s");

        if (hrs == 0 && minsLeft == 0)
            return `${secsLeft} ${secsLabel}`;
        if (hrs == 0)
            return `${minsLeft} ${minsLabel}`;
        return `${hrs} ${hrsLabel} ${minsLeft} ${minsLabel}`;
    }

    function sinkToBtDevice(sink: var): BluetoothDevice {
        if (!sink || !sink.properties)
            return null;

        let macAddress = sink.properties["api.bluez5.address"];
        let dbusPath = sink.properties["device.bus-path"];

        if (!macAddress && !dbusPath)
            return null;

        for (const device of Bluetooth.devices.values)
            if ((macAddress && device.address == macAddress) || (dbusPath && device.dbusPath == dbusPath))
                return device;

        return null;
    }
}
