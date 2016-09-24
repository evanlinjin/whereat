import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Drawer { id: mainMenu;

    dragMargin: stack.depth === 1 ? Qt.styleHints.startDragDistance : 0;

    RowLayout { id: header;
        width: parent.width;
        height: 55;
        anchors.left: parent.left;
        anchors.right: parent.right;
        Item {width: 5;}
        ToolbarButton { id: menuButton;
            src: "qrc:/icons/back.svg";
            onClicked: mainMenu.close();
            color: main.accent;
        }
        Label {
            height: parent.height - 10;
            Layout.fillWidth: true;
            text: "Where AT?";
            font.pixelSize: 18;
            color: main.accent;
        }
    }

    ListView { id: listView
        anchors.fill: parent;
        anchors.topMargin: header.height;
        clip: true;
        delegate: Rectangle {
            width: listView.width;
            height: 55;
            color: mouseArea.pressed ? main.select : "transparent";
            Row {
                anchors.fill: parent;
                spacing: 5;
                Item {width: 5; height: parent.height;}
                Item {
                    height: parent.height;
                    width: parent.height;
                    Image { id: itemImg;
                        source: model.icon;
                        anchors.fill: parent;
                        anchors.margins: 15;
                        mipmap: true;
                        smooth: true;
                    }

                    ColorOverlay { id: overlay;
                        anchors.fill: itemImg;
                        source: itemImg;
                        color: main.accent;

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
                        color: main.accent;
                    }
                }
            }
            MouseArea { id: mouseArea;
                anchors.fill: parent;
                onClicked: {
                    mainMenu.close();
                    listModel.actions[model.i]();
                }
            }
        }

        model: ListModel { id: listModel;
            ListElement {i: 0; text: "Stops"; icon: "qrc:/icons/clock.svg";}
            //            ListElement {i: 1; text: "Journey Planner"; icon: "qrc:/icons/swap.svg";}
            ListElement {i: 2; text: "Settings"; icon: "qrc:/icons/settings.svg";}
            ListElement {i: 3; text: "About"; icon: "qrc:/icons/info.svg";}
            property var actions: {
                0: function() {stack.clear(); stack.push(pageHome);},
                //                1: function() {stack.clear(); stack.push(pageHome);},
                2: function() {stack.clear(); stack.push(pageSettings);},
                3: function() {stack.push(pageAbout);}
            }
        }
    }

    function toggle() {if (activeFocus === true) {close()} else {open()}}
}
