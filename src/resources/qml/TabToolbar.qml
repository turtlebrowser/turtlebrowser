/* SPDX-FileCopyrightText: (c) 2018 Patricia Aas
 * SPDX-License-Identifier: MIT
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "icons.js" as Icons

RowLayout {
    id: root

    Layout.fillWidth: true
    spacing: 0

    property bool offTheRecord: false
    property alias currentIndex: tabs.currentIndex
    property alias model: tabsRepeater.model

    function openTab(url, title, icon, page) {
        tabModel.append({
                            tabUrl: url,
                            tabTitle: title,
                            tabIcon: icon,
                            isPage: page
                        })
        tabs.currentIndex = (tabs.count - 1)
    }

    function makeLicenseTab() {
        root.openTab("", "Licenses", Icons.checkIcon, false);
    }

    function makeNewTab() {
        root.openTab(tabModel.speedDial, tabModel.speedDialTitle, tabModel.speedDialIcon, true);
    }

    function closeTabByIndex(tabIndex) {
        tabModel.remove(tabIndex)
        if (tabModel.count === 0) {
            makeNewTab()
        }
    }

    function closeCurrentTab() {
        closeTabByIndex(tabs.currentIndex)
    }

    TabBar {
        id: tabs
        position: TabBar.Header
        Layout.maximumWidth: window.width - (root.height * 5)
        Layout.maximumHeight: root.height

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

                display: AbstractButton.TextBesideIcon

                icon.source: tabIcon
                icon.name: qsTr("Favicon")

                TapHandler {
                    acceptedButtons: Qt.MiddleButton
                    onTapped: closeTabByIndex(index)
                }

                RoundButton {
                    id: closeTab

                    width: tab.height * 0.45
                    height: tab.height * 0.45
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: tab.width * 0.05

                    display: AbstractButton.IconOnly
                    padding: 0

                    icon.source: Icons.closeTabIcon
                    icon.name: qsTr("Close Tab")

                    onClicked: closeTabByIndex(index)
                }
            }
        }
    }

    RoundButton {
        id: newTab
        Layout.leftMargin: root.height * 0.15
        Layout.preferredWidth: root.height * 0.55
        Layout.preferredHeight: root.height * 0.55
        Layout.alignment: Qt.AlignVCenter

        display: AbstractButton.IconOnly
        spacing: 0
        padding: 2

        icon.source: Icons.newTabIcon
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

        icon.source: Icons.minimizeIcon
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

        icon.source: isMaximized ? Icons.restoreIcon : Icons.maximizeIcon
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

        icon.source: Icons.closeTabIcon
        icon.name: qsTr("Close Window")

        onClicked: window.close()
    }
}
