import QtQml 2.0
import QtQml.Models 2.11
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.12
import QtQuick.Window 2.3
import QtWebEngine 1.7

import Qt.labs.platform 1.1

Window {
    id: root

    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    property int windowMargin: 5

    function toggleMaximized() {
        if (root.visibility === Window.Maximized) {
            root.showNormal()
        } else {
            root.showMaximized()
        }
    }

    // The mouse area is just for setting the right cursor shape
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY)
            const b = root.windowMargin + 10
            // Increase the corner size slightly
            if (p.x < b && p.y < b)
                return Qt.SizeFDiagCursor
            if (p.x >= width - b && p.y >= height - b)
                return Qt.SizeFDiagCursor
            if (p.x >= width - b && p.y < b)
                return Qt.SizeBDiagCursor
            if (p.x < b && p.y >= height - b)
                return Qt.SizeBDiagCursor
            if (p.x < b || p.x >= width - b)
                return Qt.SizeHorCursor
            if (p.y < b || p.x >= height - b)
                return Qt.SizeVerCursor
        }
        acceptedButtons: Qt.NoButton // don't handle actual events
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: {
            if (active) {
                const p = resizeHandler.centroid.position
                const b = root.windowMargin + 10
                // Increase the corner size slightly
                let e = 0
                if (p.x < b) {
                    e |= Qt.LeftEdge
                }
                if (p.x >= width - b) {
                    e |= Qt.RightEdge
                }
                if (p.y < b) {
                    e |= Qt.TopEdge
                }
                if (p.y >= height - b) {
                    e |= Qt.BottomEdge
                }
                root.startSystemResize(e)
            }
        }
    }
}
