import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.15

ToolButton {
    id: root

    property string highlightColor
    property string backgroundColor
    property string textColor
    property int cornerRadius: 2

    text: "\u2630"
    onClicked: menu.popup(root.width - (menu.menuWidth), root.height)
    background: Rectangle {
        color: root.hovered ? root.highlightColor : "transparent"
        radius: root.cornerRadius
    }

    StyledMenu {
        id: menu

        menuWidth: 200
        menuLineHeight: 30

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

        MenuSeparator {
            contentItem: Rectangle {
                implicitWidth: menu.menuWidth
                implicitHeight: 1
                color: root.backgroundColor
            }
        }

        StyledMenu {
            title: qsTr("Help")
            Action {
                text: qsTr("About")
            }
        }
    }
}
