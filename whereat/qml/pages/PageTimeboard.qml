import QtQuick 2.4
import Ubuntu.Components 1.3
import "../components"

Page { id: page;

    property string id;
    property string ln0;
    property string ln1;
    property string ln2;
    property double lat;
    property double lon;
    property string color;
    property bool fav;
    property bool info: false;

    header: MainHeader {id: header;
        ln0:page.ln0; ln1:page.ln1;
        iconSource: page.ln2;
        dual_heading: false;

        leftbutton: Action {iconName: "back"; onTriggered: apl.removePages(page);}

        topbar: [
            Action {iconName: fav ? "starred" : "non-starred";
                onTriggered: {WhereAt.updateStopFavourite(page.id, !page.fav);}
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

        delegate: ListItem {
            divider.visible: false;

            property string main_color: model.modelData.color === "" ? theme.palette.normal.backgroundSecondaryText : model.modelData.color;
            Row { height: parent.height; spacing: units.gu(0.5); anchors {left: parent.left; right: parent.right;}
                Item { height: parent.height; width: units.gu(0.5);}
                TB_Label {text: model.modelData.ln0; fontSize: "small"; color: main_color;}
                TB_Label {text: model.modelData.ln1.toUpperCase(); width: parent.width - units.gu(17); fontSize: "small"; color: main_color;}
                TB_Label {text: model.modelData.ln2; width: units.gu(4.5); fontSize: "small"; color: main_color;}
                TB_Label { id: rt_label;
                    text: model.modelData.ln3; al_r: true; width: units.gu(3.5); fontSize: "small"; color: main_color;
                    NumberAnimation on opacity {id: an1; from: 0; to: 1; duration: 350;}
                    NumberAnimation on opacity {id: an2; from: 1; to: 0; duration: 350;}
                }
                Timer {
                    repeat: true; running: model.modelData.ln3 === "~"; interval: 700;
                    onTriggered: { if (!rt_label.opacity) {an1.start();} else {an2.start();}}

                }
            }
            height: model.modelData.due < 0 ? 0 : units.gu(6);

            NumberAnimation on opacity {from: 0; to: 1; duration: 200;}
            NumberAnimation on opacity {from: 1; to: 0; duration: 200;}
        }

    }

    Scrollbar {flickableItem: list;}


    // LOGIC >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    Component.onCompleted: {
        // CONNECTIONS >>
        // For updating header:
        WhereAt.updateStopTimeboardComplete_StopData.connect(updateStopData);
        WhereAt.updateStopTimeboardComplete_SavedStopData.connect(updateSavedStopData);
        // For updating 'fav':
        WhereAt.updateStopFavouriteComplete.connect(updateFavourite);

        // GET TIMEBOARD INFORMATION >>
        WhereAt.updateStopTimeboard(page.id);
    }

    function updateStopData(ln, coord) {
        page.ln0 = ln[0];
        page.ln1 = ln[1];
        page.ln2 = ln[2];
        page.lat = coord[0];
        page.lon = coord[1];
    }

    function updateSavedStopData(id, fav, fav_index, visits, color) {
        page.fav = fav ? true : false;
        page.color = color ? "" : color;
    }

    function updateFavourite(id, fav) {
        if (id === page.id) {
            page.fav = fav;
        }
    }

    // ACTION FUNCTIONS ********************************************************

}
