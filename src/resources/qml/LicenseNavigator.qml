import QtQuick 2.15
import QtQuick.Controls 1.4 as Classic
import QtQuick.Controls.Styles 1.4 as ClassicStyles
import QtQuick.Layouts 1.15

import "icons.js" as Icons

// Review
ColumnLayout {
    id: root

    property int pointSize: 12
    property alias model: tree.model
    property string licenseText
    signal displayLicense

    function getAll() {
        return model.match(model.index(0, 0), Qt.DisplayRole, "*", -1, Qt.MatchWildcard | Qt.MatchRecursive)
    }

    function getMatching(text) {
        return model.match(model.index(0, 0), Qt.DisplayRole, text, -1, Qt.MatchContains | Qt.MatchRecursive)
    }

    function collapseAll() {
        var indexList = getAll()
        for (var i = 0; i < indexList.length; i++) {
            tree.collapse(indexList[i])
        }
    }

    function expandToRootIndex(index) {
        var ancestor = index
        do {
            tree.expand(ancestor)
            ancestor = model.parent(ancestor)
        } while (ancestor.valid)
    }

    function expandToRootIndexList(indexList) {
        for (var i = 0; i < indexList.length; i++) {
            expandToRootIndex(indexList[i])
        }
    }

    function search(text) {
        collapseAll()
        model.setFilterFixedString(text)
        if (text) {
            var indexList = getMatching(text)
            expandToRootIndexList(indexList)
        }
    }

    Classic.TreeView {
        id: tree

        Layout.fillHeight: true
        Layout.fillWidth: true

        headerVisible: false

        Classic.TableViewColumn {
            role: "display"
        }

        rowDelegate: Rectangle {
            height: root.pointSize * 2
            SystemPalette {
                id: sysPalette
            }
            color: {
                var baseColor = styleData.alternate ? sysPalette.alternateBase : sysPalette.base
                return styleData.selected ? sysPalette.highlight : baseColor
            }
        }

        itemDelegate: Item {
            Text {
                id: itemText
                anchors.verticalCenter: parent.verticalCenter
                color: styleData.textColor
                elide: styleData.elideMode
                text: styleData.value
                font.pointSize: root.pointSize
            }
        }

        style: ClassicStyles.TreeViewStyle {
            branchDelegate: Image {
                width: 15
                height: 15
                source: styleData.isExpanded ? Icons.minimizeIcon : Icons.newTabIcon
            }
        }

        function toggleExpanded(index) {
            if (tree.isExpanded(index))
                tree.collapse(index)
            else
                tree.expand(index)
        }

        onDoubleClicked: {
            tree.toggleExpanded(index)
            root.licenseText = model.readFile(index)
            root.displayLicense()
        }
    }
}
