import QtQuick 2.4
import Ubuntu.Components 1.3
import "../components"

PageAbstract { id: page;

    header: MainHeader { id: header;
        ln0: "Stops";
        iconName: "clock-app-symbolic";
        leftbutton: Action { id: navButton;
            text: "Menu"; iconName: "navigation-menu";
            onTriggered: mainMenu.toggle();
        }
        tabbar: [
            Action {text: "Starred";
                onTriggered: {
                    header.headerMode = 0;
                    WhereAt.reloadFavouriteStops();
                }
            },
            Action {text: "Nearby";
                onTriggered: {
                    header.headerMode = 0;
                    WhereAt.updateNearbyStops();
                }
            },
            Action {text: "Search";
                onTriggered: {
                    header.headerMode = 1;
                    WhereAt.reloadTextSearch_forceLoadingOff();
                }
            }
        ]

        searchPlaceholderText: "Search Stops...";
        onSearchAccepted: WhereAt.reloadTextSearch(query);
    }


    UbuntuListView { id: listView;
        anchors.fill: parent;
        anchors.topMargin: header.height;
        currentIndex: -1;
        onCountChanged: currentIndex = -1;
        delegate: MainListItem {id: listItem;
            updateFavourite: function(id,fav) {WhereAt.updateStopFavourite(id, fav);}
            open: function(id) {apl.addPageToNextColumn(apl.primaryPage, pageTimeboard, {id:id});}
            open0: function() {console.log("open0 triggered.");}
            showRemove: header.tabbar_currentIndex === 0;
        }

        model: switch (header.tabbar_currentIndex) {
               case 0: return FavouriteStopsModel;
               case 1: return NearbyStopsModel;
               case 2: return TextSearchStopsModel;
               default: return 0;
               }

        PullToRefresh { id: ptr;
            refreshing: switch (header.tabbar_currentIndex) {
                        case 0: return FavouriteStopsModel.loading;
                        case 1: return NearbyStopsModel.loading;
                        case 2: return TextSearchStopsModel.loading;
                        default: return 0;
                        }
            onRefresh: switch (header.tabbar_currentIndex) {
                       case 0: WhereAt.reloadFavouriteStops(); break;
                       case 1: WhereAt.reloadNearbyStops(); break;
                       case 2: WhereAt.reloadTextSearch(header.searchQuery); break;
                       }
        }
        Scrollbar {flickableItem: listView;}
    }
}
