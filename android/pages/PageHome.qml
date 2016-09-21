import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import "../components"

Page { id: page;

    header: MainPageHeader { id: header;
        ln0: "Stops";
        actionNavMenu: function() {}
        actionReload: function() {TextSearchStopsModel.reload("test");}
    }

    footer: TabBar { id: tabBar;
        width: parent.width;
        currentIndex: swipeView.currentIndex;
        TabButton {text: qsTr("Starred");}
        TabButton {text: qsTr("Nearby");}
        TabButton {text: qsTr("Search");}
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
