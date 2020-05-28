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

    property string buttonColor: root.offTheRecord ? Theme.offTheRecordColor : Theme.addressBarColor
    property string buttonHightlightColor: root.offTheRecord ? Theme.offTheRecordHightlight : Theme.addressBarHighlight

    function makeNewTab() {
        console.log("Make new tab")
        tabModel.append({
                            "tabUrl": Addesses.speedDial,
                            "tabTitle": Addesses.speedDialTitle
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

        TapHandler {
            onTapped: if (tapCount === 2)
                          toggleMaximized()
            gesturePolicy: TapHandler.DragThreshold
        }
        DragHandler {
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: if (active) {
                                 window.startSystemMove()
                             }
        }

        Repeater {
            id: tabsRepeater

            TabButton {
                id: tab
                text: tabTitle

                property bool currentTab: (index == tabs.currentIndex)

                width: 120

                contentItem: Text {
                    id: tabLabel

                    text: tab.text
                    font: tab.font
                    color: root.offTheRecord ? Theme.offTheRecordTextColor : Theme.textColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    // Possibly use text? "🗙"
                    Button {
                        id: closeTab

                        height: 12
                        width: 12
                        anchors.right: tabLabel.right
                        anchors.verticalCenter: tabLabel.verticalCenter
                        spacing: 0
                        padding: 0

                        onClicked: closeTabByIndex(index)

                        icon.source: Theme.closeTabIcon
                        property string iconColor: root.offTheRecord ? Theme.offTheRecordIconColor : Theme.addressBarIconColor
                        icon.color: tab.hovered ? iconColor : tabBackground.color
                        icon.height: 12
                        icon.width: 12
                        icon.name: qsTr("Close Tab")

                        background: Rectangle {
                            color: tab.hovered ? root.buttonColor : "transparent"
                            border.color: tabBackground.color
                            border.width: tab.hovered
                                          && closeTab.hovered ? (closeTab.down ? 1 : 0) : 1
                            radius: 2
                        }
                    }
                }

                background: Rectangle {
                    id: tabBackground
                    property string offTheRecordColor: tab.hovered ? Theme.offTheRecordHightlight : (tab.currentTab ? Theme.offTheRecordColor : Theme.offTheRecordLowlight)
                    property string onTheRecordColor: tab.hovered ? Theme.addressBarHighlight : (tab.currentTab ? Theme.addressBarColor : Theme.addressBarLowlight)

                    color: root.offTheRecord ? offTheRecordColor : onTheRecordColor
                }
            }
        }
    }

    // Possibly use text? ToolButton { text: "+" }
    Button {
        id: newTab
        Layout.preferredHeight: 12
        Layout.preferredWidth: 12
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 2

        onClicked: makeNewTab()

        background: Rectangle {
            color: newTab.hovered ? root.buttonHightlightColor : root.buttonColor
            border.color: Theme.tabBarBackground
            border.width: newTab.hovered ? 0 : 1
            radius: 2
        }
    }

    Item {
        Layout.fillWidth: true
    }
    ToolButton {
        id: minimizeWindow
        text: "🗕"
        onClicked: window.showMinimized()

        background: Rectangle {
            color: minimizeWindow.hovered ? root.buttonHightlightColor : "transparent"
        }
    }
    ToolButton {
        id: restoreToggleWindow
        text: window.visibility === Window.Maximized ? "🗗" : "🗖"
        onClicked: window.toggleMaximized()
        background: Rectangle {
            color: restoreToggleWindow.hovered ? root.buttonHightlightColor : "transparent"
        }
    }
    ToolButton {
        id: closeWindow
        text: "🗙"
        onClicked: window.close()
        background: Rectangle {
            color: closeWindow.hovered ? "#F44336" : "transparent"
        }
    }
}
