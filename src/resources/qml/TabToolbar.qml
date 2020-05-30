import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

import "theme.js" as Theme
import "addresses.js" as Addesses

RowLayout {
    id: root

    Layout.fillWidth: true
    spacing: 0

    property bool offTheRecord: false
    property alias currentIndex: tabs.currentIndex
    property alias model: tabsRepeater.model

    function makeNewTab() {
        console.log("Make new tab")
        tabModel.append({
                            tabUrl: Addesses.speedDial,
                            tabTitle: Addesses.speedDialTitle
                        })
        tabs.currentIndex = (tabModel.count - 1)
    }

    function closeTabByIndex(tabIndex) {
        console.log("Close tab : " + tabIndex)
        tabModel.remove(tabIndex)
        if (tabModel.count === 0) {
            makeNewTab()
        }
    }

    function closeCurrentTab() {
        console.log("Close current tab")
        closeTabByIndex(tabs.currentIndex)
    }

    TabBar {
        id: tabs
        position: TabBar.Header
        Layout.maximumWidth: window.width - (root.height * 5)

        TapHandler {
            onTapped: if (tapCount === 2)
                          toggleMaximized()
            gesturePolicy: TapHandler.DragThreshold
        }

        DragHandler {
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active)
                    window.startSystemMove()
            }
        }

        Repeater {
            id: tabsRepeater

            TabButton {
                id: tab
                text: tabTitle
                implicitWidth: 240

                Button {
                    id: closeTab

                    width: tab.height
                    height: tab.height
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    display: AbstractButton.IconOnly
                    padding: 0

                    icon.source: Theme.closeTabIcon
                    icon.name: qsTr("Close Tab")

                    onClicked: closeTabByIndex(index)
                }
            }
        }
    }

    ToolButton {
        id: newTab
        Layout.preferredHeight: root.height
        Layout.preferredWidth: root.height

        display: AbstractButton.IconOnly
        spacing: 0
        padding: 2

        icon.source: Theme.newTabIcon
        icon.name: qsTr("New Tab")

        onClicked: makeNewTab()
    }

    Rectangle {
        id: barSpacer
        Layout.fillWidth: true
        Layout.preferredHeight: root.height
        Layout.minimumWidth: 20
        color: "transparent"
        MouseArea {
            anchors.fill: parent

            property point pressedPosition
            property bool isMovable: !(window.visibility === Window.Maximized)

            onDoubleClicked: toggleMaximized()

            onPressed: {
                if (isMovable) {
                    pressedPosition = Qt.point(mouse.x, mouse.y)
                }
            }

            onPositionChanged: {
                if (isMovable) {
                    var delta = Qt.point(mouse.x - pressedPosition.x,
                                         mouse.y - pressedPosition.y)
                    window.x += delta.x
                    window.y += delta.y
                }
            }
        }
    }

    ToolButton {
        id: minimizeWindow
        Layout.preferredHeight: root.height
        Layout.preferredWidth: root.height

        display: AbstractButton.IconOnly
        spacing: 0
        padding: 2

        icon.source: Theme.minimizeIcon
        icon.name: qsTr("Minimize Window")

        onClicked: window.showMinimized()
    }

    ToolButton {
        id: restoreToggleWindow

        property bool isMaximized: (window.visibility === Window.Maximized)

        Layout.preferredHeight: root.height
        Layout.preferredWidth: root.height

        display: AbstractButton.IconOnly
        spacing: 0
        padding: 2

        icon.source: isMaximized ? Theme.restoreIcon : Theme.maximizeIcon
        icon.name: isMaximized ? qsTr("Restore Window") : qsTr("Maximize Window")

        onClicked: window.toggleMaximized()
    }

    ToolButton {
        id: closeWindow

        Layout.preferredHeight: root.height
        Layout.preferredWidth: root.height

        display: AbstractButton.IconOnly
        spacing: 0
        padding: 2

        icon.source: Theme.closeTabIcon
        icon.name: qsTr("Close Window")

        onClicked: window.close()
    }
}
