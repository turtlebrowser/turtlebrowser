/* SPDX-FileCopyrightText: (c) 2018 TurtleSec AS
 * SPDX-License-Identifier: MIT
 */
import QtQuick 2.15
import QtWebEngine 1.10

QtObject {
    id: root

    property QtObject publicProfile: WebEngineProfile {
        storageName: "Profile"
        useForGlobalCertificateVerification: true
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
