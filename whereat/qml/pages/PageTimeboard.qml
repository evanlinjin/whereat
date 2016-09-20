import QtQuick 2.4
import Ubuntu.Components 1.3
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

    header: MainHeader {id: header;
        ln0: page.ln0;
        ln1: page.ln1;
        iconSource: page.src;
        dual_heading: false;

        leftbutton: Action {iconName: "back"; onTriggered: apl.removePages(page);}

        topbar: [
            Action {iconName: fav ? "starred" : "non-starred";
                onTriggered: {DbManager.updateSavedStopFavourite(page.id, !page.fav);}
            },
            Action {iconName: "reload"; text: "Reload";
                onTriggered: {}
            }
        ]

        extension: Row { height: units.gu(4); spacing: units.gu(0.5); width: parent.width;
            Item { height: parent.height; width: units.gu(0.5); }
            TB_Label {text: "ROUTE"; bold: true; fontSize: "x-small";}
            TB_Label {text: "DESTINATION"; bold: true; fontSize: "x-small"; width: parent.width - units.gu(17);}
            TB_Label {text: "SCHED."; bold: true; fontSize: "x-small"; width: units.gu(4.5);}
            TB_Label {text: "DUE"; bold: true; fontSize: "x-small"; al_r: true; width: units.gu(3.5);}
        }
    }

    UbuntuListView { id: list;
        anchors.fill: parent;
        anchors.topMargin: header.height;
        clip: true;

        Component.onCompleted: currentIndex = -1;
        onCountChanged: currentIndex = -1;

        model: TimeboardModel;
        delegate: ListItem {
            divider.visible: false;

            property string main_color: model.color === "" ? theme.palette.normal.backgroundSecondaryText : model.modelData.color;
            Row { height: parent.height; spacing: units.gu(0.5); anchors {left: parent.left; right: parent.right;}
                Item { height: parent.height; width: units.gu(0.5);}
                TB_Label {text: model.ln0; fontSize: "small"; color: main_color;}
                TB_Label {text: model.ln1.toUpperCase(); width: parent.width - units.gu(17); fontSize: "small"; color: main_color;}
                TB_Label {text: model.ln2; width: units.gu(4.5); fontSize: "small"; color: main_color;}
                TB_Label { id: rt_label; text: model.ln3; al_r: true; width: units.gu(3.5); fontSize: "small"; color: main_color;}
            }
            height: model.due < 0 ? 0 : units.gu(6);
        }

        PullToRefresh { id: ptr;
            refreshing: TimeboardModel.loading;
            onRefresh: TimeboardModel.reload(page.id);
        }

        Scrollbar {flickableItem: list;}
    }

    // LOGIC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    Component.onCompleted: {TimeboardModel.reload(page.id);}

    // ACTION FUNCTIONS ********************************************************

}
