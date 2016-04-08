import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader { id: header;

    property string ln1: "Where AT?";
    property string ln2: "Timeboards";
    property string icon: "clock-app-symbolic";

    property alias tabbar: home_sections; // .actions: []
    property alias topbar: header.trailingActionBar; // .actions: []

    contents: CustomHeader {id: ch_home; mainTitle: ln1; subTitle: ln2; iconName: icon;}
    extension: Sections { id: home_sections; height: visible ? units.gu(4) : 0;
        anchors {left: parent.left; top: parent.top;}
    }
    leadingActionBar.actions: [
        Action {iconName: "clock-app-symbolic"; text: "Timeboards";
            onTriggered: {whereat_apl.primaryPageSource = Qt.resolvedUrl("PageHome.qml");}
        },
        Action {iconName: "swap"; text: "Journey Planner";
            onTriggered: {whereat_apl.primaryPageSource = Qt.resolvedUrl("PageJourneyPlanner.qml");}
        },
        Action {iconName: "external-link"; text: "AT Hop Card";
            onTriggered: {whereat_apl.primaryPageSource = Qt.resolvedUrl("PageATHop.qml");}
        }/*,
        Action {iconName: "settings"; text: "Settings";
            onTriggered: {whereat_apl.primaryPageSource = Qt.resolvedUrl("PageSettings.qml");}
        }*/
    ]
    leadingActionBar.numberOfSlots: 1;
}

// onClicked: page.pageStack.addPageToNextColumn(page, pageTimeBoard)
// onClicked: page.pageStack.addPageToCurrentColumn(page, page3)
