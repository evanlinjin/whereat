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
                onTriggered: {
                    header.headerMode = 1;
                    header.focus_search_bar();
                }
            }
        ]
        leftbutton: [
            Action {
                visible: header.headerMode == 1;
                iconName: "back"; text: "Back"
                onTriggered: header.tabbar_currentIndex--;
            }
        ]
        searchPlaceholderText: "Search Stops...";
        onSearchAccepted: WhereAt.reloadTextSearch(query);
    }

    ListView { id: side_scroller
        anchors.fill: parent
        anchors.topMargin: header.height
        clip: true;
        orientation: Qt.Horizontal;
        snapMode: ListView.SnapOneItem;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        highlightMoveDuration: UbuntuAnimation.FastDuration;
        currentIndex: header.tabbar_currentIndex;
        onCurrentIndexChanged: header.tabbar_currentIndex = currentIndex;

        model: VisualItemModel {

            UbuntuListView {
                width: page.width;
                height: parent.height
                currentIndex: -1
                delegate: ListItem {
                    divider.visible: false
                    height: units.gu(10)
                    ListItemLayout {
                        anchors.fill: parent
                        title.text: model.ln0;
                        subtitle.text: model.ln1;
                        summary.text: model.ln2;
                    }
                }
                model: FavouriteStopsModel;
                PullToRefresh {
                    refreshing: FavouriteStopsModel.loading;
                    //onRefresh: WhereAt.reloadNearbyStops();
                }
            }

            UbuntuListView {
                width: page.width;
                height: parent.height
                currentIndex: -1
                delegate: ListItem {
                    divider.visible: false
                    height: units.gu(10)
                    ListItemLayout {
                        anchors.fill: parent
                        title.text: model.ln0;
                        subtitle.text: model.ln1;
                        summary.text: model.ln2;
                    }
                }
                model: NearbyStopsModel;
                PullToRefresh {
                    refreshing: NearbyStopsModel.loading;
                    onRefresh: WhereAt.reloadNearbyStops();
                }
            }

            UbuntuListView {
                width: page.width;
                height: parent.height
                currentIndex: -1
                delegate: ListItem {
                    divider.visible: false
                    height: units.gu(8)
                    ListItemLayout {
                        anchors.fill: parent
                        title.text: model.ln0;
                        subtitle.text: model.ln1;
                        summary.text: model.ln2;
                    }
                }
                model: TextSearchStopsModel;
                PullToRefresh {
                    refreshing: TextSearchStopsModel.loading;
                    onRefresh: WhereAt.reloadNearbyStops(header.searchQuery);
                }
            }
        }
    }
}
