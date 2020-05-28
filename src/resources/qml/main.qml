import QtQuick 2.11
import QtWebEngine 1.7

QtObject {
    id: root

    property QtObject publicProfile: WebEngineProfile {
        storageName: "Profile"
    }

    property QtObject privateProfile: WebEngineProfile {
        offTheRecord: true
    }

    property Component topLevelWindowComponent: TopLevelWindow {
        globalContext: root
    }

    function createTopLevelWindow(profile) {
        var window = topLevelWindowComponent.createObject(root)
        window.windowProfile = profile
        return window
    }

    function createPublicWindow() {
        createTopLevelWindow(publicProfile)
    }

    function createPrivateWindow() {
        createTopLevelWindow(privateProfile)
    }

    function start() {
        createPublicWindow()
    }
}
