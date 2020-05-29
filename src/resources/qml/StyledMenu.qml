import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.15

import "theme.js" as Theme

Menu {
    id: root

    property int menuWidth: 200
    property int menuLineHeight: 30
    property string highlightColor
    property string backgroundColor
    property string textColor
    property int cornerRadius

    topPadding: 2
    bottomPadding: 2

    background: Rectangle {
        id: menuBackground
        implicitWidth: root.menuWidth
        implicitHeight: root.menuLineHeight
        color: root.backgroundColor
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
        implicitWidth: root.menuWidth
        implicitHeight: root.menuLineHeight

        arrow: Button {
            implicitWidth: 40
            implicitHeight: root.menuLineHeight
            visible: menuItem.subMenu
            enabled: false
            icon.source: Theme.backIcon
            icon.color: root.textColor

            background: Rectangle {
                color: "transparent"
            }
        }

        indicator: Button {
            implicitWidth: 40
            implicitHeight: root.menuLineHeight
            visible: menuItem.checkable
            enabled: false
            icon.source: menuItem.checked ? Theme.checkIcon : Theme.maximizeIcon
            icon.color: root.textColor

            background: Rectangle {
                color: "transparent"
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
            implicitWidth: root.menuWidth
            implicitHeight: root.menuLineHeight
            opacity: enabled ? 1 : 0.3
            color: menuItem.highlighted ? root.highlightColor : root.backgroundColor
        }
    }
}
