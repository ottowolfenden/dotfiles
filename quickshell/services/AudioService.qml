pragma Singleton
import QtQuick
import Quickshell.Bluetooth
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import ".."

QtObject {
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

    function isEarbud(btDevice: var): bool {
        return AudioConf.earbudSubstrings.some(s => btDevice.name.toLowerCase().includes(s) || btDevice.deviceName.toLowerCase().includes(s));
    }

    function containsHdmi(pwNode: PwNode): bool {
        return pwNode.name.concat(pwNode.description).toLowerCase().includes("hdmi");
    }

    function getFilteredPlayers(): list<MprisPlayer> {
        if (!Mpris.players)
            return;
        let playingPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Playing);
        let pausedPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Paused);
        return playingPlayers.concat(pausedPlayers);
    }

    function getSortedPlayers(): list<MprisPlayer> {
        if (!Mpris.players)
            return [];
        let playingPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Playing);
        let pausedPlayers = Mpris.players.values.filter(p => p.playbackState == MprisPlaybackState.Paused);
        return playingPlayers.concat(pausedPlayers);
    }

    function getSinkDetails(sink: PwNode): var {
        let unknown = {
            icon: IconsConf.devices["computer"],
            name: "Laptop"
        };

        let btDevice = sinkToBtDevice(sink);
        if (btDevice)
            return {
                icon: isEarbud(btDevice) ? IconsConf.devices["earbud"] : IconsConf.devices[btDevice.icon] ?? IconsConf.devices["bluetooth"],
                name: btDevice.name
            };

        if (!sink?.properties)
            return unknown;
        let sinkIcon = sink.properties["device.icon_name"] || sink.properties["device.icon-name"];
        let sinkName = sink.nickname != "" && sink.nickname ? sink.nickname : sink.description;
        if (sinkIcon)
            return {
                icon: IconsConf.devices[sinkIcon] ?? IconsConf.devices["computer"],
                name: sinkName && !["", "Speaker"].includes(sinkName) ? sinkName : "Laptop"
            };
        return unknown;
    }

    function getFilteredSinks(): list<PwNode> {
        let filtered = Pipewire.nodes.values.filter(n => n.audio && n.ready && !n.isStream && n.isSink && (SystemConf.showHdmiSinks || !containsHdmi(n)));
        filtered.sort((a, b) => getSinkDetails(a).name > getSinkDetails(b).name ? 1 : -1);
        let target = filtered.find(n => n.name == SystemConf.mainPwNodeName);
        if (!target)
            return filtered;
        return [target, ...filtered.filter(item => item != target)];
    }
}
