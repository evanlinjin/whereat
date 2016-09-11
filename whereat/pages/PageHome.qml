import QtQuick 2.4
import Ubuntu.Components 1.3
import "../components"

Page { id: page;

    header: MainHeader { id: header;
        ln0: "Stops";
        iconName: "clock-app-symbolic";
        tabbar: [
            Action {text: "Starred";
                onTriggered: {
                    header.headerMode = 0;
                }
            },
            Action {text: "Nearby";
                onTriggered: {
                    header.headerMode = 0;
                    WhereAt.updateNearbyStops();
                }
            },
            Action {text: "Search";
                onTriggered: header.headerMode = 1;
            }
        ]

        searchPlaceholderText: "Search Stops...";
        onSearchAccepted: WhereAt.reloadTextSearch(query);
        //flickable: listView;
    }

    UbuntuListView { id: listView
        anchors.fill: parent;
        anchors.topMargin: header.height;
        currentIndex: -1;
        onCountChanged: currentIndex = -1
        delegate: MainListItem { id: listItem }
        model: switch (header.tabbar_currentIndex) {
               case 0: return FavouriteStopsModel;
               case 1: return NearbyStopsModel;
               case 2: return TextSearchStopsModel;
               default: return 0;
               }

        PullToRefresh {
            refreshing: switch (header.tabbar_currentIndex) {
                        case 0: return FavouriteStopsModel.loading;
                        case 1: return NearbyStopsModel.loading;
                        case 2: return TextSearchStopsModel.loading;
                        default: return 0;
                        }
            onRefresh: switch (header.tabbar_currentIndex) {
                       case 0: break;
                       case 1: WhereAt.reloadNearbyStops(); break;
                       case 2: WhereAt.reloadTextSearch(header.searchQuery); break;
                       }
        }
    }
}
