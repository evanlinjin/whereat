import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2

Page {id: page;

    header: MainHeader { id: header;
        ln2: "AT Hop Card";
        icon: "external-link";
        tabbar.visible: false;
        topbar.actions: [
            Action {iconName: "reload"; text: "Refresh"; onTriggered: webview.reload();}
        ]
    }

    WebView { id: webview;
        anchors.top: header.bottom;
        anchors.bottom: page.bottom;
        anchors.left: page.left;
        anchors.right: page.right;
        url: "https://at.govt.nz/bus-train-ferry/at-hop-card/";
    }

    ActivityIndicator {
        z: header.z + 100;
        running: webview.loading;
        anchors.top: page.top;
        anchors.right: page.right;
        anchors.topMargin: units.gu(1.5);
        anchors.rightMargin: units.gu(1.5);
    }
}
