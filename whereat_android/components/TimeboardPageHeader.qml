import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

ToolBar { id: toolbar;
    property string ln0;
    property var actionNavMenu;
    property var actionReload;
    property var actionFav;
    property bool showTabBar: true;
    property alias menuIcon: menuButton.src;
    property alias titleIcon: titleIconImg.source;
    property alias favIcon: favButton.src;

    width: parent.width;
    height: row0.height + tabBar.height;
    background: Rectangle {id: rect; color: "white"; anchors.fill: parent;}

    DropShadow {
        anchors.fill: parent;
        samples: 14
        color: "#50000000"
        source: rect;
    }

    Column {
        anchors.fill: parent;
        RowLayout { id: row0;
            width: parent.width;
            height: showTabBar ? 50 : 55;
            anchors.left: parent.left;
            anchors.right: parent.right;
            Item {width: 5;}
            ToolbarButton { id: menuButton;
                src: "qrc:/icons/navigation-menu.svg";
                onClicked: actionNavMenu();
            }
            Item { id: iconItem;
                height: 50;
                width: 50;
                Image { id: titleIconImg;
                    height: 30;
                    width: 30;
                    anchors.centerIn: parent;
                    anchors.horizontalCenterOffset: -5;
                    mipmap: true;
                    smooth: true;
                }
            }
            Label { id: title;
                height: parent.height - 10;
                Layout.fillWidth: true;
                text: ln0;
                font.pixelSize: 18;
                color: "black";
            }
            Item {width: 5;}
            ToolbarButton {
                src: "qrc:/icons/reload.svg";
                onClicked: actionReload();
            }
            ToolbarButton { id: favButton;
                src: "qrc:/icons/starred.svg";
                onClicked: actionFav();
            }
            Item {width: 5;}
        }
        RowLayout { id: tabBar;
            height: 40; spacing: 5; width: parent.width;
            Item { height: parent.height; width: 10; }
            TB_Label {text: "ROUTE"; bold: true; fontSize: 12; width: 50; id: tbl0;}
            TB_Label {text: "DESTINATION"; bold: true; fontSize: 12; Layout.fillWidth: true;}
            TB_Label {text: "SCHED."; bold: true; fontSize: 12; width: 50; id: tbl2;}
            TB_Label {text: "DUE"; bold: true; fontSize: 12; al_r: true; width: 25; id: tbl3;}
            Item { height: parent.height; width: 10; }
        }
    }
}
