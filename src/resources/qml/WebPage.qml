import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.10

import "loading.js" as Loading
import "url.js" as URL

ColumnLayout {
    id: root

    property QtObject windowProfile
    property alias view: webView
    property alias address: webView.url
    property string title: webView.title
    property bool offTheRecord: false

    Layout.fillWidth: true
    Layout.fillHeight: true

    AddressBar {
        id: bar
        height: 40
        Layout.fillWidth: true

        url: webView.url
        offTheRecord: root.offTheRecord

        onReload: webView.reload()
        onBack: webView.goBack()
        onForward: webView.goForward()
        onGoToAddress: webView.typedText = address
    }

    WebEngineView {
        id: webView
        Layout.fillWidth: true
        Layout.fillHeight: true
        property alias address: webView.url

        property string typedText: ""

        profile: root.windowProfile
        onTypedTextChanged: webView.url = URL.construct(typedText)
        onLoadingChanged: function (loadRequest) {
            Loading.process(loadRequest)
        }
    }

    Action {
        shortcut: "Escape"
        onTriggered: {
            bar.unfocusAddressField()
        }
    }

    Action {
        shortcut: "F8"
        onTriggered: {
            bar.focusAddressField()
        }
    }
}
