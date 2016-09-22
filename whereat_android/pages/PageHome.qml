import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"

Page { id: page;

    property alias pageIndex: swipeView.currentIndex;

    header: MainPageHeader { id: header;
        ln0: "Stops";
        titleIcon: "qrc:/icons/clock.svg";
        actionNavMenu: function() {mainMenu.toggle();}
        actionReload: function() {
            switch(pageIndex) {
            case 0: FavouriteStopsModel.reload(); break;
            case 1: NearbyStopsModel.reload(); break;
            }
        }
        actionSearch: function(query) {TextSearchStopsModel.reload(query);}
        searchMode: swipeView.currentIndex === 2;
        currentIndex: swipeView.currentIndex;
    }

    SwipeView {
        id: swipeView;
        anchors.fill: parent;
        currentIndex: header.currentIndex;
        Item {
            MainListView {
                model: FavouriteStopsModel;
                esText: "Starred";
            }
        }
        Item {
            MainListView {
                model: NearbyStopsModel;
                esText: "Nearby";
            }
        }
        Item {
            MainListView {
                model: TextSearchStopsModel;
                esText: "Search";
            }
        }
    }
}
