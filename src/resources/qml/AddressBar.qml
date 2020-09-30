/* SPDX-FileCopyrightText: (c) 2018 TurtleSec AS
 * SPDX-License-Identifier: MIT
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "icons.js" as Icons

ToolBar {
    id: root

    property alias url: labelText.text
    property bool offTheRecord: false

    signal goToAddress(string address)
    signal back
    signal forward
    signal reload
    signal showLicenses

    property int barPadding: 4
    property int barRadius: 2

    Component.onCompleted: focusAddressField()

    function focusAddressField() {
        addressField.currentIndex = addressField.fieldIndex
    }

    function unfocusAddressField() {
        addressField.currentIndex = addressField.labelIndex
    }

    RowLayout {
        id: displaybox
        anchors.fill: parent
        spacing: root.barPadding

        property int itemHeight: root.height - (2 * root.barPadding)
        property int buttonWidth: itemHeight

        ToolButton {
            id: backButton
            Layout.leftMargin: root.barPadding
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth

            display: AbstractButton.IconOnly
            spacing: 0
            padding: 2

            icon.source: Icons.backIcon
            icon.name: qsTr("Back")

            onClicked: root.back()
        }

        ToolButton {
            id: forwardButton
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth

            display: AbstractButton.IconOnly
            spacing: 0
            padding: 2

            icon.source: Icons.forwardIcon
            icon.name: qsTr("Forward")

            onClicked: root.forward()
        }

        ToolButton {
            id: reloadButton
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth

            display: AbstractButton.IconOnly
            spacing: 0
            padding: 2

            icon.source: Icons.reloadIcon
            icon.name: qsTr("Reload")

            onClicked: root.reload()
        }

        StackLayout {
            id: addressField

            Layout.rightMargin: 2
            Layout.preferredHeight: displaybox.itemHeight
            Layout.margins: root.barPadding

            property int labelIndex: 0
            property int fieldIndex: 1

            currentIndex: addressField.labelIndex

            onCurrentIndexChanged: {
                inputField.text = labelText.text
                if (currentIndex == fieldIndex)
                    inputField.forceActiveFocus()
            }

            Rectangle {
                id: label
                Layout.fillHeight: true
                Layout.fillWidth: true
                radius: 4

                Text {
                    id: labelText
                    anchors.fill: label
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: root.barPadding
                    clip: true
                }

                MouseArea {
                    id: clickToFocusArea
                    anchors.fill: label
                    hoverEnabled: true
                    cursorShape: Qt.IBeamCursor
                    onClicked: root.focusAddressField()
                }
            }

            Rectangle {
                id: field
                Layout.fillHeight: true
                Layout.fillWidth: true
                radius: 4
                border.color : "#FFC107"
                border.width : 2

                TextInput {
                    id: inputField
                    anchors.fill: parent
                    verticalAlignment: TextInput.AlignVCenter
                    leftPadding: labelText.leftPadding

                    clip: true
                    focus: true
                    selectByMouse: true

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            inputField.selectAll()
                        } else {
                            root.unfocusAddressField()
                        }
                    }

                    onAccepted: {
                        root.goToAddress(inputField.text)
                        root.unfocusAddressField()
                    }
                }
            }
        }
        ToolButton {
            id: settingsButton
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth
            Layout.rightMargin: root.barPadding
            spacing: 0
            padding: 2

            display: AbstractButton.IconOnly
            icon.source: Icons.menuIcon
            icon.name: qsTr("Open Browser Menu")

            onClicked: menu.popup((settingsButton.width - menu.width),
                                  settingsButton.height)

            Menu {
                id: menu

                Action {
                    text: qsTr("Licenses")
                    icon.source: Icons.checkIcon
                    onTriggered: root.showLicenses()
                }
            }
        }
    }
}
