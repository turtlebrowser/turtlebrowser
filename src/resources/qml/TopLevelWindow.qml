import QtQml 2.0
import QtQml.Models 2.11
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11
import QtWebEngine 1.7

import "addresses.js" as Addesses
import "loading.js" as Loading
import "theme.js" as Theme
import "url.js" as URL

Window {
    id: root
    property QtObject globalContext
    property Item currentPage: pagesStack.currentPage
    property QtObject windowProfile
    property bool windowOffTheRecord: windowProfile ? windowProfile.offTheRecord : false
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    visible: true

    onWindowProfileChanged: {
        if (windowProfile) {
            tabBar.makeNewTab()
        }
    }

    function getTitle(currentIndex) {
        var current = tabModel.get(currentIndex)
        return current ? current.tabTitle + " - " : ""
    }

    title: getTitle(tabBar.currentIndex) + "TurtleBrowser"

    ListModel {
        id: tabModel
    }

    ColumnLayout {

        anchors.fill: parent
        spacing: 0

        TabToolbar {
            id: tabBar
            currentIndex: pagesStack.currentIndex
            model: tabModel
            offTheRecord: root.windowOffTheRecord
        }

        StackLayout {
            id: pagesStack
            currentIndex: tabBar.currentIndex

            property Item currentPage

            onCurrentIndexChanged: {
                var currentItem = pages.itemAt(currentIndex)
                if (currentItem)
                    currentPage = currentItem.view
                else
                    currentPage = null
            }

            Repeater {
                id: pages
                model: tabModel

                Layout.fillWidth: true
                Layout.fillHeight: true

                WebPage {
                    id: page
                    windowProfile: root.windowProfile
                    offTheRecord: root.windowOffTheRecord
                    Component.onCompleted: address = tabUrl

                    onTitleChanged: tabTitle = page.title
                    onAddressChanged: tabUrl = page.address
                }
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
            if (root.visibility == Window.FullScreen) {
                root.visibility = Window.Maximized
            } else {
                root.visibility = Window.FullScreen
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
