import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

import "theme.js" as Theme

ToolBar {
    id: root

    property alias url: labelText.text
    property bool offTheRecord: false

    signal goToAddress(string address)
    signal back
    signal forward
    signal reload

    property int barPadding: 4
    property int barRadius: 2

    function focusAddressField() {
        console.log("Focus Address Field: Set label visible to false")
        label.visible = false
    }

    function unfocusAddressField() {
        console.log("Unfocus Address Field: Set label visible to true")
        label.visible = true
    }

    RowLayout {
        id: displaybox
        anchors.fill: parent
        spacing: root.barPadding

        property int itemHeight: root.height - (2 * root.barPadding)
        property int buttonWidth: itemHeight
        property string iconColor: root.offTheRecord ? Theme.offTheRecordIconColor : Theme.addressBarIconColor

        ToolButton {
            id: backButton
            Layout.leftMargin: root.barPadding
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth

            display: AbstractButton.IconOnly
            spacing: 0
            padding: 2

            icon.source: Theme.backIcon
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

            icon.source: Theme.forwardIcon
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

            icon.source: Theme.reloadIcon
            icon.name: qsTr("Reload")

            onClicked: root.reload()
        }

        Item {
            Layout.rightMargin: 2
            Layout.fillWidth: true
            Layout.preferredHeight: displaybox.itemHeight

            Rectangle {
                id: label
                anchors.fill: parent
                radius: 4

                Text {
                    id: labelText
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: root.barPadding
                    color: Theme.textColor
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
                anchors.fill: parent
                radius: 4

                visible: !label.visible

                TextInput {
                    id: inputField
                    anchors.fill: parent
                    verticalAlignment: TextInput.AlignVCenter
                    leftPadding: labelText.leftPadding

                    focus: visible
                    selectByMouse: true
                    selectedTextColor: Theme.selectedTextColor
                    selectionColor: Theme.selectionColor
                    color: Theme.textColor

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            inputField.text = labelText.text
                            root.focusAddressField()
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
            icon.source: Theme.menuIcon
            icon.name: qsTr("Open Browser Menu")

            onClicked: menu.popup((settingsButton.width - menu.width),
                                  settingsButton.height)

            Menu {
                id: menu

                Action {
                    text: qsTr("First")
                }
                Action {
                    text: qsTr("Second")
                }
                Action {
                    text: qsTr("Third")
                    checkable: true
                    checked: true
                }

                Menu {

                    title: qsTr("Help")
                    Action {
                        text: qsTr("About")
                    }
                }
            }
        }
    }
}
