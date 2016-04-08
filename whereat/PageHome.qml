import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Page { id: page;

    property int whichTab: 0;

    header: MainHeader {id: header;
        ln2: "Timeboards"; icon: "clock-app-symbolic";
        tabbar.visible: true;
        topbar.actions: [
            Action {iconName: "search"; text: "Search";
                onTriggered: home_bottom_edge.commit();
            },
            Action {iconName: "reload"; text: "Reload";
                onTriggered: {var temp = tab_loader.source; tab_loader.source = ""; tab_loader.source = temp;}
            },
            Action {iconName: "settings"; text: "Settings";
                onTriggered: page.pageStack.addPageToNextColumn(page, Qt.resolvedUrl("PageSettings.qml"));
            }
        ]
        tabbar.actions: [
            Action{text: "Starred"; onTriggered: tab_loader.source = "Ph_FavouritesTab.qml";},
            Action{text: "Nearby"; onTriggered: tab_loader.source = "Ph_NearbyTab.qml";}/*,
            Action{text: "Recent"; onTriggered: tab_loader.source = "Ph_HistoryTab.qml";}*/
        ]
    }

    Loader { id: tab_loader;
        focus: true; source: "Ph_FavouritesTab.qml";
        anchors.top: header.bottom;
        anchors.bottom: page.bottom;
        width: page.width;

        NearbyModel {id: nearby_model;} /*** NEARBY MODEL ***/
        FavouritesModel { id: favourites_model;} /*** FAVOURITES MODEL ***/
        HistoryModel {id: history_model;} /*** HISTORY MODEL ***/

    }

    BottomEdge { id: home_bottom_edge;
        width: page.width; height: page.height/* - header.height*/;
        hint.text: "Search for a stop, station or pier.";
        hint.iconName: "find";
        hint.status: "Active";

        contentComponent: Loader {
            source: "MainSearchView.qml";
            width: home_bottom_edge.width;
            height: home_bottom_edge.height;
            asynchronous: true;
        }
    }

    // onClicked: page.pageStack.addPageToNextColumn(page, pageTimeBoard)
    // onClicked: page.pageStack.addPageToCurrentColumn(page, page3)
}

