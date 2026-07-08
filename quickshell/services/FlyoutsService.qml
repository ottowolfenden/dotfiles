pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."
import "../components"

QtObject {
    id: flyoutsService

    property list<Flyout> flyouts: []
    property list<BottomAutoFlyout> bafs: []

    property IpcHandler flyoutsHandler: IpcHandler {
        target: "flyoutsHandler"

        function hideNonHoveredFlyouts() {
            for (const flyout of flyoutsService.flyouts)
                if (!flyout.hovering)
                    flyout.isOpen = false;
            if (![...flyoutsService.flyouts, ...flyoutsService.bafs].some(x => x.hovering || x.isOpen))
                Quickshell.execDetached(HyprlandService.hyprlandCommands.reset);
        }
    }

    property IpcHandler bafsHandler: IpcHandler {
        target: "bafsHandler"

        function showBaf(type: string): void {
            for (const baf of flyoutsService.bafs) {
                if (baf.type == type) {
                    baf.isOpen = true;
                    baf.autoHideTimer.restart();
                } else
                    baf.isOpen = false;
            }
            Quickshell.execDetached(HyprlandService.hyprlandCommands[flyoutsService.bafs.some(b => b.isOpen) ? "bafOpen" : "reset"]);
        }

        function hideAllBafs(): void {
            for (const baf of flyoutsService.bafs)
                if (!baf.hovering)
                    baf.isOpen = false;
            if (![...flyoutsService.flyouts, ...flyoutsService.bafs].some(x => x.hovering || x.isOpen))
                Quickshell.execDetached(HyprlandService.hyprlandCommands.reset);
        }
    }

    function hideAllFlyouts() {
        for (const flyout of flyoutsService.flyouts)
            flyout.isOpen = false;
        Quickshell.execDetached(HyprlandService.hyprlandCommands.reset);
    }

    function hideAllFlyoutsExcept(openFlyout) {
        for (const flyout of flyoutsService.flyouts)
            if (flyout != openFlyout)
                flyout.isOpen = false;
        Quickshell.execDetached(HyprlandService.hyprlandCommands[flyoutsService.flyouts.some(f => f.isOpen) ? "flyoutOpen" : "reset"]);
    }

    function hideFlyout(flyoutToHide: Flyout): void {
        for (const flyout of flyoutsService.flyouts)
            if (flyout == flyoutToHide)
                flyout.isOpen = false;
        Quickshell.execDetached(HyprlandService.hyprlandCommands[flyoutsService.flyouts.some(f => f.isOpen) ? "flyoutOpen" : "reset"]);
    }

    function hideBaf(baf: BottomAutoFlyout): void {
        if (baf.hovering) {
            baf.autoHideTimer.restart();
            return;
        }
        baf.isOpen = false;
        if (![...flyoutsService.flyouts, ...flyoutsService.bafs].some(f => f.isOpen))
            Quickshell.execDetached(HyprlandService.hyprlandCommands.reset);
    }
}
