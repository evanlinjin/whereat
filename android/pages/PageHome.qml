import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"

Page { id: page;

    property alias pageIndex: swipeView.currentIndex;

    header: MainPageHeader { id: header;
        ln0: "Stops";
        actionNavMenu: function() {}
        actionReload: function() {
            switch(pageIndex) {
            case 0: FavouriteStopsModel.reload(); break;
            case 1: NearbyStopsModel.reload(); break;
            }
        }
        actionSearch: function(query) {TextSearchStopsModel.reload(query);}
        searchMode: pageIndex === 2;
    }

    footer: TabBar { id: tabBar;
        width: parent.width;
        currentIndex: pageIndex;
        MainTabButton {
            text: qsTr("Starred");
            src: "qrc:/android/icons/starred.svg";
            onClicked: FavouriteStopsModel.reload();
        }
        MainTabButton {
            text: qsTr("Nearby");
            src: "qrc:/android/icons/location.svg";
            onClicked: NearbyStopsModel.update();
        }
        MainTabButton {
            text: qsTr("Search");
            src: "qrc:/android/icons/find.svg";
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page {
            MainListView {model: FavouriteStopsModel;}
        }

        Page {
            MainListView {model: NearbyStopsModel;}
        }

        Page {
            MainListView {model: TextSearchStopsModel;}
        }
    }
}
