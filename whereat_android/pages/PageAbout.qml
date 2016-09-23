import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"
import "../listitems"
import "../js/appInfo.js" as INFO

Page { id: page;

    header: MainPageHeader { id: header;
        ln0: "About";
        titleIcon: "qrc:/icons/info.svg";
        menuIcon: "qrc:/icons/back.svg";
        actionNavMenu: function() {stack.pop();}
        currentIndex: 0;
        searchMode: false;
        showReload: false;
        showTabBar: false;
    }

    ListView { id: list;
        anchors.fill: parent;
    }
}
