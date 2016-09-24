import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0

import "../components"

Page { id: page;

    property string query: "";

    header: MainPageHeader { id: header;
        ln0: "Stops";
        titleIcon: "qrc:/icons/clock.svg";
        actionNavMenu: function() {mainMenu.toggle();}
        actionReload: function() {
            switch(swipeView.currentIndex) {
            case 0: FavouriteStopsModel.reload(); break;
            case 1: NearbyStopsModel.reload(); break;
            case 2: TextSearchStopsModel.reload(page.query);
            }
        }
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
                header: Rectangle {
                    color: page.background.color;
                    z: swipeView.z + 100;
                    width: parent.width;
                    height: 60;
                    Row {
                        anchors.fill: parent;
                        anchors.margins: 10;
                        //spacing: 5;
                        TextField { id: textField;
                            width: parent.width - spacing;
                            anchors.verticalCenter: parent.verticalCenter;
                            placeholderText: qsTr("Enter query");
                            onAccepted: TextSearchStopsModel.reload(text);
                            onTextChanged: page.query = text;
                            onVisibleChanged: if (swipeView.currentIndex === 2) {
                                                  text = "";
                                                  forceActiveFocus();
                                              }
                            visible: swipeView.currentIndex === 2;
                        }
                    }
                }
                headerPositioning: ListView.OverlayHeader;
                pull: -contentY - 120;
                model: TextSearchStopsModel;
                listItemType: "Stop";
                clip: true;
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
