import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.15

Menu {
    id: menu

    property int menuWidth: 200
    property int menuLineHeight: 30

    topPadding: 2
    bottomPadding: 2

    background: Rectangle {
        id: menuBackground
        implicitWidth: menu.menuWidth
        implicitHeight: menu.menuLineHeight
        color: root.highlightColor
        border.color: root.backgroundColor
        radius: root.cornerRadius

        layer.enabled: true
        layer.effect: DropShadow {
            width: menuBackground.width
            height: menuBackground.height
            x: menuBackground.x
            y: menuBackground.y
            visible: menuBackground.visible

            source: menuBackground

            horizontalOffset: 0
            verticalOffset: 0
            radius: root.cornerRadius * 2
            samples: 7
            color: root.backgroundColor
        }
    }

    delegate: MenuItem {
        id: menuItem
        implicitWidth: menu.menuWidth
        implicitHeight: menu.menuLineHeight

        arrow: Item {
            width: 40
            height: menu.menuLineHeight
            visible: menuItem.subMenu
            Label {
                anchors.centerIn: parent
                text: "<"
                color: root.textColor
            }
        }

        indicator: Item {
            implicitWidth: 40
            implicitHeight: menu.menuLineHeight
            Rectangle {
                width: 18
                height: 18
                anchors.centerIn: parent
                visible: menuItem.checkable
                border.color: root.backgroundColor
                radius: 3
                Rectangle {
                    width: 10
                    height: 10
                    anchors.centerIn: parent
                    visible: menuItem.checked
                    color: root.backgroundColor
                    radius: root.cornerRadius
                }
            }
        }

        contentItem: Text {
            leftPadding: menuItem.indicator.width
            rightPadding: menuItem.arrow.width
            text: menuItem.text
            font: menuItem.font
            opacity: enabled ? 1.0 : 0.3
            color: root.textColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: menu.menuWidth
            implicitHeight: menu.menuLineHeight
            opacity: enabled ? 1 : 0.3
            color: menuItem.highlighted ? root.backgroundColor : "transparent"
        }
    }
}
