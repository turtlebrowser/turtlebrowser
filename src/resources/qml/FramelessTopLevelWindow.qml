import QtQuick 2.15
import QtQuick.Window 2.15

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
                let e = 0
                if (p.x / window.width < 0.10) {
                    e |= Qt.LeftEdge
                }
                if (p.x / window.width > 0.90) {
                    e |= Qt.RightEdge
                }
                if (p.y / window.height < 0.10) {
                    e |= Qt.TopEdge
                }
                if (p.y / window.height > 0.90) {
                    e |= Qt.BottomEdge
                }
                root.startSystemResize(e)
            }
        }
    }
}
