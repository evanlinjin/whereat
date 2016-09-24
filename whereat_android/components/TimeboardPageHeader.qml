import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

ToolBar { id: toolbar;
    property string ln0;
    property string ln1;
    property var actionNavMenu;
    property var actionReload;
    property var actionFav;
    property bool showTabBar: true;
    property alias menuIcon: menuButton.src;
    property alias titleIcon: titleIconImg.source;
    property alias favIcon: favButton.src;

    width: parent.width;
    height: row0.height + tabBar.height;

    Column {
        anchors.fill: parent;
        RowLayout { id: row0;
            width: parent.width;
            height: showTabBar ? 50 : 55;
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 0;
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
            Column {
                Layout.fillWidth: true;
                spacing: 2.5;
                Label { id: title;
                    text: ln0;
                    font.pixelSize: 14;
                    font.weight: Font.Normal;
                    color: primaryaccent;
                }
                Label { id: title2;
                    text: ln1;
                    font.pixelSize: 12;
                    font.weight: Font.Light;
                    color: primaryaccent;
                }
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
            TB_Label {text: "ROUTE"; bold: true; fontSize: 12; width: 50; id: tbl0; color: primaryaccent;}
            TB_Label {text: "DESTINATION"; bold: true; fontSize: 12; Layout.fillWidth: true; color: primaryaccent;}
            TB_Label {text: "SCHED."; bold: true; fontSize: 12; width: 50; id: tbl2; color: primaryaccent;}
            TB_Label {text: "DUE"; bold: true; fontSize: 12; al_r: true; width: 25; id: tbl3; color: primaryaccent;}
            Item { height: parent.height; width: 10; }
        }
    }
}
