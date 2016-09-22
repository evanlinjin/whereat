import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Drawer { id: mainMenu;

    background: Rectangle {id: rect; color: "white"; anchors.fill: parent;}

//    DropShadow {
//        anchors.fill: parent;
//        radius: 8.0
//        samples: 17
//        color: "#80000000"
//        source: rect;
//    }

    MainPageHeader { id: header;
        ln0: "Where AT?";
        actionNavMenu: function() {mainMenu.close();}
        searchMode: false;
        showReload: false;
        showTabBar: false;
        showShadow: false;
        currentIndex: 0;
        menuIcon: "qrc:/icons/back.svg";
        titleIcon: "qrc:/icons/AT.png";
        showTitleIconOverlay: false;
        showTitleIcon: false;

    }

    ListView { id: listView
        anchors.fill: parent;
        anchors.topMargin: header.height;
        clip: true;
        delegate: Row {
            width: listView.width;
            height: 55;
            spacing: 5;
            Item {width: 5; height: parent.height;}
            Item {
                height: parent.height;
                width: parent.height;
                Image {
                    source: model.icon;
                    anchors.fill: parent;
                    anchors.margins: 15;

                    ColorOverlay { id: overlay;
                        anchors.fill: parent;
                        source: parent;
                        color: "black";
                    }
                }
            }
            Item {
                height: parent.height;
                width: parent.height;
                Label { id: title;
                    text: model.text;
                    font.pixelSize: 14;
                    font.weight: Font.Normal;
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.margins: 5;
                    color: "black";
                }
            }
        }

        model: ListModel { id: listModel
            ListElement {i: 0; text: "Stops"; icon: "qrc:/icons/clock.svg";}
            ListElement {i: 1; text: "Journey Planner"; icon: "qrc:/icons/swap.svg";}
            ListElement {i: 2; text: "Settings"; icon: "qrc:/icons/settings.svg";}
            ListElement {i: 3; text: "About"; icon: "qrc:/icons/info.svg";}
            //                property var actions: {
            //                    0: function() {apl.primaryPageSource = pageHome;},
            //                    1: function() {apl.primaryPageSource = pageHome;},
            //                    2: function() {apl.primaryPageSource = pageSettings;},
            //                    3: function() {apl.addPageToNextColumn(apl.primaryPage, pageAbout);}
            //                }
        }
    }

    function toggle() {if (activeFocus === true) {close()} else {open()}}
}
