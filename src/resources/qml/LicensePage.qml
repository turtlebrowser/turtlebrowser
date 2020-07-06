import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as Classic
import QtQml.Models 2.15

import "icons.js" as Icons

// Review
ColumnLayout {
    id: root
    spacing: 0

    property int padding: 20

    SystemPalette {
        id: sysPalette
    }

    function search(text) {
        licenseSelector.search(text)
    }

    function clearSearch() {
        searchField.text = ""
    }

    Rectangle {
        color: sysPalette.window
        height: root.padding * 4
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignTop

        Rectangle {
            anchors.centerIn: parent
            width: parent.width / 3
            height: root.padding * 2
            clip: true
            color: sysPalette.base
            radius: root.padding
            border.color: "#FFC107"
            border.width: searchField.activeFocus ? 2 : 0

            TextInput {
                id: searchField
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                font.pointSize: 12
                selectByMouse: true
                onTextEdited: root.search(text)
            }

            Text {
                anchors.centerIn: parent
                text: "Search Licenses"
                color: sysPalette.midlight
                font.pointSize: 12
                visible: !searchField.text && !searchField.activeFocus
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignTop
        spacing: 0

        Rectangle {
            id: tabColumn
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            color: sysPalette.window
            width: 40

            TabBar {
                id: tabBar
                width: parent.height
                height: parent.width
                y: parent.height
                currentIndex: 3

                transform: Rotation { origin.x: 0; origin.y: 0; angle: -90 }

                TabButton {
                    text: "Other"
                    display: AbstractButton.TextBesideIcon
                    icon.source: Icons.checkIcon
                    icon.name: qsTr("Favicon")
                }

                TabButton {
                    text: "Qt"
                    display: AbstractButton.TextBesideIcon
                    icon.source: Icons.checkIcon
                    icon.name: qsTr("Favicon")
                }

                TabButton {
                    text: "Chromium"
                    display: AbstractButton.TextBesideIcon
                    icon.source: Icons.checkIcon
                    icon.name: qsTr("Favicon")
                }

                TabButton {
                    text: "All"
                    display: AbstractButton.TextBesideIcon
                    icon.source: Icons.checkIcon
                    icon.name: qsTr("Favicon")
                }
            }
        }

        Classic.SplitView {
            id: grid
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            orientation: Qt.Horizontal

            Rectangle {
                id: licenseSelector
                width: parent.width / 3

                color: sysPalette.window

                property alias licenseView: displayLicense.text

                function clearText() {
                    displayLicense.text = ""
                    root.clearSearch()
                }

                function search(text) {
                    treeStack.children[tabBar.currentIndex].search(text)
                }

                StackLayout {
                    id: treeStack
                    anchors.fill: parent

                    currentIndex: tabBar.currentIndex
                    onCurrentIndexChanged: licenseSelector.clearText()

                    LicenseNavigator {
                        model: licenseModelPlatform
                        onDisplayLicense: licenseSelector.licenseView = licenseText
                    }
                    LicenseNavigator {
                        model: licenseModelToolkit
                        onDisplayLicense: licenseSelector.licenseView = licenseText
                    }
                    LicenseNavigator {
                        model: licenseModelWebView
                        onDisplayLicense: licenseSelector.licenseView = licenseText
                    }
                    LicenseNavigator {
                        model: licenseModelAll
                        onDisplayLicense: licenseSelector.licenseView = licenseText
                    }
                }
            }

            Rectangle {
                id: displayLicense
                width: (parent.width / 3) * 2

                property alias text: content.text
                clip: true

                Flickable {
                    anchors.fill: parent

                    contentWidth: content.contentWidth
                    contentHeight: content.contentHeight

                    boundsBehavior: Flickable.StopAtBounds

                    TextArea.flickable: TextArea {
                        id: content
                        readOnly: true
                        focus: false
                        selectByMouse: true
                        wrapMode: Text.NoWrap
                        font.family: "monospace"
                        font.pointSize: 12
                        font.weight: Font.Normal
                        color: sysPalette.text
                        background: Rectangle { color: sysPalette.base }
                    }

                    ScrollBar.horizontal: ScrollBar {}
                    ScrollBar.vertical: ScrollBar {}
                    ScrollIndicator.horizontal: ScrollIndicator {}
                    ScrollIndicator.vertical: ScrollIndicator {}
                }
            }
        }

        Rectangle {
            color: sysPalette.window
            width: root.padding
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
        }
    }

    Rectangle {
        color: sysPalette.window
        height: root.padding
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignBottom
    }
}
