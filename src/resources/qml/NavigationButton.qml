import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0

import "theme.js" as Theme

// Possibly use text?
// ToolButton { text: "←" }
// ToolButton { text: "→" }
// ToolButton { text: "↻" }
Button {
    id: root

    property string buttonHighlightColor
    property string buttonColor
    property string buttonName
    property string buttonIcon
    property string buttonIconColor

    display: AbstractButton.IconOnly
    spacing: 0
    padding: 2

    icon.source: buttonIcon
    icon.color: buttonIconColor
    icon.height: 30
    icon.width: 30
    icon.name: buttonName

    background: Rectangle {
        id: style
        color: root.hovered ? buttonHighlightColor : buttonColor
        radius: 2
    }
}
