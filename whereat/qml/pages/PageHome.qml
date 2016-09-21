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
                    FavouriteStopsModel.reload();
                }
            },
            Action {text: "Nearby";
                onTriggered: {
                    header.headerMode = 0;
                    NearbyStopsModel.update();
                }
            },
            Action {text: "Search";
                onTriggered: {
                    header.headerMode = 1;
                    //WhereAt.reloadTextSearch_forceLoadingOff();
                }
            }
        ]
        topbar: Action {text: "Reload"; iconName: "reload";
            visible: ptr.refreshing === false;
            onTriggered: ptr.refresh();
        }

        searchPlaceholderText: "Search Stops...";
        onSearchAccepted: TextSearchStopsModel.reload(query);
    }


    ListView { id: listView;
        anchors.fill: parent;
        anchors.topMargin: header.height;
        currentIndex: -1;
        onCountChanged: currentIndex = -1;
        delegate: MainListItem {id: listItem;
            updateFavourite: function(id,fav) {DbManager.updateSavedStopFavourite(id, fav);}
            open: function(id) {apl.addPageToNextColumn(apl.primaryPage, pageTimeboard, {id:id});}
            open0: function() {console.log("open0 triggered.");}
            showRemove: header.tabbar_currentIndex === 0;

            onPressAndHold:/* if (header.tabbar_currentIndex === 0)*/
                           ListView.view.ViewItems.dragMode = !ListView.view.ViewItems.dragMode;

//            ViewItems.onDragUpdated: if (event.status === ListItemDrag.Moving)
//                                         model.move(event.from, event.to, 1);
            ViewItems.onDragUpdated: {
                if (event.status == ListItemDrag.Moving) {
                    // inform dragging that move is not performed
                    event.accept = false;
                } else if (event.status == ListItemDrag.Dropped) {
                    model.move(event.from, event.to, 1);
                }
            }
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
                       case 0: FavouriteStopsModel.reload(); break;
                       case 1: NearbyStopsModel.reload(); break;
                       case 2: TextSearchStopsModel.reload(header.searchQuery); break;
                       }
        }
        Scrollbar {flickableItem: listView;}
    }
}
