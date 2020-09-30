/* SPDX-FileCopyrightText: (c) 2018 Patricia Aas
 * SPDX-License-Identifier: MIT
 */
import QtQml 2.15
import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "icons.js" as Icons

FramelessTopLevelWindow {
    id: window

    visibility: Window.Maximized

    property QtObject globalContext
    property QtObject windowProfile
    property bool windowOffTheRecord: windowProfile ? windowProfile.offTheRecord : false

    function showLicenses() {
        tabBar.makeLicenseTab()
    }

    function getTitle(currentIndex) {
        var current = tabModel.get(currentIndex)
        return current ? current.tabTitle + " - " : ""
    }

    title: getTitle(tabBar.currentIndex) + "TurtleBrowser"

    ListModel {
        id: tabModel

        readonly property string speedDial: "https://www.google.com"
        readonly property string speedDialTitle: "Google"
        readonly property string speedDialIcon: Icons.webIcon

        ListElement {
            tabUrl: "https://www.google.com"
            tabTitle: "Google"
            tabIcon: ""
            isPage: true
        }
    }

    ColumnLayout {

        anchors.fill: parent
        anchors.margins: window.visibility === Window.Windowed ? window.windowMargin : 0
        spacing: 0

        TabToolbar {
            id: tabBar
            Layout.maximumWidth: window.width
            height: 40
            currentIndex: pagesStack.currentIndex
            model: tabModel
            offTheRecord: window.windowOffTheRecord
        }

        StackLayout {
            id: pagesStack
            currentIndex: tabBar.currentIndex

            Repeater {
                id: pages
                model: tabModel

                Layout.fillWidth: true
                Layout.fillHeight: true

                Loader {
                    id: pageLoader
                    property variant modelData: model
                    sourceComponent: modelData.isPage ? webDelegate : licenseDelegate
                }
            }

            Component {
                id: webDelegate
                WebPage {
                    id: page
                    address: modelData ? modelData.tabUrl : ""
                    windowProfile: window.windowProfile
                    offTheRecord: window.windowOffTheRecord
                    onShowLicenses: window.showLicenses()
                    onTitleChanged: modelData.tabTitle = page.title
                    onAddressChanged: modelData.tabUrl = page.address
                    onIconChanged: {
                        console.log("fav icon changed : " + page.icon)
                        modelData.tabIcon = Icons.webIcon
                    }
                }
            }

            Component {
                id: licenseDelegate
                LicensePage {}
            }
        }
    }

    Action {
        shortcut: "Ctrl+T"
        onTriggered: tabBar.makeNewTab()
    }

    Action {
        shortcut: "Ctrl+W"
        onTriggered: tabBar.closeCurrentTab()
    }

    Action {
        shortcut: "F11"
        onTriggered: {
            if (window.visibility == Window.FullScreen) {
                window.visibility = Window.Maximized
            } else {
                window.visibility = Window.FullScreen
            }
        }
    }

    Action {
        shortcut: "Ctrl+Q"
        onTriggered: Qt.quit()
    }

    Action {
        shortcut: "Ctrl+N"
        onTriggered: globalContext.createPublicWindow()
    }

    Action {
        shortcut: "Ctrl+Shift+N"
        onTriggered: globalContext.createPrivateWindow()
    }
}
