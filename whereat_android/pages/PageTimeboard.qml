import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"

Page { id: page;

    // 0:id, 1:code, 2:name, 3:lat, 4:lon, 5:type, 6:fav, 7:color
    property string id;
    property string ln0 : TimeboardModel.ln[1];
    property string ln1 : TimeboardModel.ln[2];
    property double lat : TimeboardModel.ln[3];
    property double lon : TimeboardModel.ln[4];
    property string src : TimeboardModel.ln[5];
    property bool fav : TimeboardModel.ln[6];
    property string color : TimeboardModel.ln[7];
    property bool info: false;

    header: TimeboardPageHeader { id: header;
        ln0: page.ln0;
        ln1: page.ln1;
        titleIcon: page.src;
        menuIcon: "qrc:/icons/back.svg";
        favIcon: fav ? "qrc:/icons/starred.svg" : "qrc:/icons/non-starred.svg";
        actionNavMenu: function() {stack.pop();}
        actionReload: function() {TimeboardModel.reload(page.id);}
        actionFav: function() {DbManager.updateSavedStopFavourite(page.id, !page.fav);}
    }

    ListView { id: list;
        anchors.fill: parent;

        PullToRefresh { id: ptr }
        onDragEnded: if (ptr.refresh) {page.header.actionReload();}

        model: TimeboardModel;

        delegate: RowLayout { id: tabBar;
            height: 55; spacing: 5; width: parent.width;
            Item { height: parent.height; width: 10; }
            TB_Label {text: model.ln0; fontSize: 12; width: 50; id: tbl0;}
            TB_Label {text: model.ln1.toUpperCase(); fontSize: 12; Layout.fillWidth: true;}
            TB_Label {text: model.ln2; fontSize: 12; width: 50; id: tbl2;}
            TB_Label {text: model.ln3; fontSize: 12; al_r: true; width: 25; id: tbl3;}
            Item { height: parent.height; width: 10; }
        }

        ScrollBar.vertical: ScrollBar {}

        BusyIndicator { id: busyIndicator;
            running: TimeboardModel.loading && TimeboardModel.count === 0;
            anchors.centerIn: parent;
        }

        Image { id: emptyState;
            height: 90;
            width: 90;
            visible: !busyIndicator.running && !TimeboardModel.count;
            opacity: 0.1;
            anchors.centerIn: parent;
            source: page.src;
            smooth: true;
        }
    }

    Component.onCompleted: {TimeboardModel.reload(page.id);}
}
