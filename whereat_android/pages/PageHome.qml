import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"

Page { id: page;

    header: MainPageHeader { id: header;
        ln0: "Stops";
        titleIcon: "qrc:/icons/clock.svg";
        actionNavMenu: function() {mainMenu.toggle();}
        actionReload: function() {
            switch(swipeView.currentIndex) {
            case 0: FavouriteStopsModel.reload(); break;
            case 1: NearbyStopsModel.reload(); break;
            case 2: TextSearchStopsModel.reload(query);
            }
        }
        actionSearch: function(q) {TextSearchStopsModel.reload(q);}
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
                listItemType: "Stop";
            }
        }
        Item {
            MainListView {
                model: NearbyStopsModel;
                listItemType: "Stop";
            }
        }
        Item {
            MainListView {
                model: TextSearchStopsModel;
                listItemType: "Stop";
            }
        }

        onCurrentIndexChanged: switch (currentIndex) {
                               case 0: FavouriteStopsModel.reload(); break;
                               case 1: NearbyStopsModel.update(); break;
                               case 2: break;
                               }
        Component.onCompleted: FavouriteStopsModel.reload();
    }
}
