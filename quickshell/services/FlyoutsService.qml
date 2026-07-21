pragma Singleton
import QtQuick
import Quickshell.Io
import ".."
import "../components"

QtObject {
    id: root

    property list<Flyout> flyouts: []
    property list<BottomAutoFlyout> bafs: []

    property IpcHandler flyoutsHandler: IpcHandler {
        target: "flyoutsHandler"

        function hideNonHoveredFlyouts(): void {
            for (const flyout of root.flyouts)
                if (!flyout.hovering)
                    flyout.isOpen = false;
            if (![...root.flyouts, ...root.bafs].some(x => x.hovering || x.isOpen))
                HyprlandService.reload();
        }

        function hideAllFlyouts(): void {
            for (const flyout of root.flyouts)
                flyout.isOpen = false;
            HyprlandService.reload();
        }
    }

    property IpcHandler bafsHandler: IpcHandler {
        target: "bafsHandler"

        function showBaf(type: string): void {
            for (const baf of root.bafs) {
                if (baf.type == type) {
                    baf.isOpen = true;
                    baf.autoHideTimer.restart();
                } else
                    baf.isOpen = false;
            }
            if (root.bafs.some(b => b.isOpen))
                HyprlandService.applyBafConf();
            else
                HyprlandService.applyFlyoutConf();
        }

        function hideAllBafs(): void {
            for (const baf of root.bafs)
                if (!baf.hovering)
                    baf.isOpen = false;
            if (![...root.flyouts, ...root.bafs].some(x => x.hovering || x.isOpen))
                HyprlandService.reload();
        }
    }

    function hideAllFlyoutsExcept(openFlyout: Flyout): void {
        for (const flyout of root.flyouts)
            if (flyout != openFlyout)
                flyout.isOpen = false;
        if (root.flyouts.some(f => f.isOpen))
            HyprlandService.applyFlyoutConf();
        else
            HyprlandService.reload();
    }

    function hideFlyout(flyoutToHide: Flyout): void {
        for (const flyout of root.flyouts)
            if (flyout == flyoutToHide)
                flyout.isOpen = false;
        if (root.flyouts.some(f => f.isOpen))
            HyprlandService.applyFlyoutConf();
        else
            HyprlandService.reload();
    }

    function hideBaf(baf: BottomAutoFlyout): void {
        if (baf.hovering) {
            baf.autoHideTimer.restart();
            return;
        }
        baf.isOpen = false;
        if (![...root.flyouts, ...root.bafs].some(f => f.isOpen))
            HyprlandService.reload();
    }
}
