import QtQuick 2.12
import QtQuick.Layouts 1.3

import "theme.js" as Theme

Rectangle {
    id: root

    property alias url: labelText.text
    property bool offTheRecord: false

    signal goToAddress(string address)
    signal back()
    signal forward()
    signal reload()

    property int barPadding: 4
    property int barRadius: 2


    property string highlightColor: offTheRecord ? Theme.offTheRecordHightlight : Theme.addressBarHighlight
    property string addressBarColor: offTheRecord ? Theme.offTheRecordColor : Theme.addressBarColor
    property string textColor: offTheRecord ? Theme.offTheRecordTextColor : Theme.textColor
    color: addressBarColor

    function focusAddressField() {
        console.log("Focus Address Field: Set label visible to false")
        label.visible = false;
    }

    function unfocusAddressField() {
        console.log("Unfocus Address Field: Set label visible to true")
        label.visible = true;
    }

    RowLayout {
        id: displaybox
        anchors.fill: parent
        spacing: root.barPadding

        property int itemHeight: root.height - (2*root.barPadding)
        property int buttonWidth: itemHeight
        property string iconColor: root.offTheRecord ? Theme.offTheRecordIconColor : Theme.addressBarIconColor

        NavigationButton {
            id: backButton
            Layout.leftMargin: root.barPadding
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth
            buttonIcon: Theme.backIcon
            buttonIconColor: displaybox.iconColor
            buttonColor: root.addressBarColor
            buttonHighlightColor: root.highlightColor
            buttonName: qsTr("Back")
            onClicked: root.back();
        }

        NavigationButton {
            id: forwardButton
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth
            buttonIcon: Theme.forwardIcon
            buttonIconColor: displaybox.iconColor
            buttonColor: root.addressBarColor
            buttonHighlightColor: root.highlightColor
            buttonName: qsTr("Forward")
            onClicked: root.forward();
        }

        NavigationButton {
            id: reloadButton
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth
            buttonIcon: Theme.reloadIcon
            buttonIconColor: displaybox.iconColor
            buttonColor: root.addressBarColor
            buttonHighlightColor: root.highlightColor
            buttonName: qsTr("Reload")
            onClicked: root.reload();
        }

        Item {
            Layout.rightMargin: 2
            Layout.fillWidth: true
            Layout.preferredHeight: displaybox.itemHeight

            AddressBackground {
                id: label
                anchors.fill: parent

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
                    onClicked: root.focusAddressField();
                }
            }

            AddressBackground {
                id: field
                anchors.fill: parent

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
                            inputField.text = labelText.text;
                            root.focusAddressField();
                            inputField.selectAll();
                        } else {
                            root.unfocusAddressField();
                        }
                    }

                    onAccepted: {
                        root.goToAddress(inputField.text);
                        root.unfocusAddressField();
                    }
                }
            }
        }
        BrowserMenu {
            Layout.preferredHeight: displaybox.itemHeight
            Layout.preferredWidth: displaybox.buttonWidth
            Layout.rightMargin: root.barPadding
            spacing: 0
            padding: 2

            highlightColor: root.highlightColor
            backgroundColor: root.addressBarColor
            textColor: root.textColor
        }
    }
}
