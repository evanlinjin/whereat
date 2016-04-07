import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems

Item { id: list_container;
    property ListModel grid_model: ListModel {ListElement {ln1: "Nothing to show."}}

    property string thumb_str: "timer";
    property bool hide_thumb: false;

    property alias list: list;
    property alias ptr: ptr;

    //width: parent.width; height: parent.height;

    UbuntuListView { id: list;
        anchors.fill: parent;
        clip: true;
        model: grid_model;

        delegate: ListItem { id: main_listitem;
            //height: units.gu(10);
            divider.visible: true; selectMode: false;

            MouseArea { id: element_mousearea;
                //z: favourite_mousearea.z - 1;
                anchors.fill: parent;
                onPressed: {}
                onClicked: {
                    Haptics.play({duration: 25, attackIntensity: 0.7});
                    page.pageStack.addPageToNextColumn(page, Qt.resolvedUrl("PageTimeBoard.qml"), {
                                                           header_title: model.ln1,
                                                           header_subtitle: model.ln2,
                                                           stop_id: model.stop_id
                                                       });
                }
            }

            ListItemLayout { id: layout;
                height: main_listitem.height;
                padding.top: units.gu(0.75); padding.bottom: units.gu(0.75);

                title.text: model.ln1; /*title.font.bold: true;*/ title.maximumLineCount: 1;
                subtitle.text: model.ln2; /*subtitle.font.bold: true; subtitle.textSize: Label.XSmall;*/ subtitle.maximumLineCount: 1;
                summary.text: model.ln3; summary.textSize: Label.XxSmall; summary.maximumLineCount: 1;

                Item { id: lt_shape;
                    visible: !hide_thumb;
                    SlotsLayout.position: SlotsLayout.Leading;
                    width: units.gu(4); height: units.gu(5);

                    Label { id: lt_shape_label;
                        anchors.centerIn: parent;
                        text: model.lt_text; /*font.bold: true;*/ textSize: Label.Small;
                    }

                    Icon { id: lt_shape_icon;
                        visible: lt_shape_label.text === ""; anchors.centerIn: parent;
                        height: parent.height - units.gu(1); width: height;
                        name: thumb_str;
                    }
                }

                Item { id: icon_container;
                    SlotsLayout.position: SlotsLayout.Trailing;
                    width: units.gu(3); height: units.gu(5);

                    Icon {id: favourite_icon;
                        anchors.centerIn: parent;
                        width: units.gu(3);
                        name: model.is_favourite ? "starred" : "non-starred";
                        color: Theme.palette.normal.overlayText;
                    }
                    MouseArea { id: favourite_mousearea;
                        z: element_mousearea.z + 5;
                        anchors.fill: parent;
                        onClicked: {
                            Haptics.play({duration: 25, attackIntensity: 0.7});
                            if (model.is_favourite) {
                                console.log("MainGridView: remove_stop(), INPUT: ", model.stop_id);
                                u1db_favourites.remove_stop(model.stop_id);
                            } else {
                                console.log("MainGridView: add_stop(), INPUT:", model.stop_id, "[arry here]");
                                u1db_favourites.add_stop(model.stop_id, [model.ln1, model.ln2, model.ln3, model.thumb_src]);
                            }
                            grid_model.update_favourites();
                        }
                    }
                }
            }
        }
        footer: Item {width: parent.width; height: units.gu(4);}
        PullToRefresh { id: ptr;
            refreshing: false;
            onRefresh: {}
        }

    }
    Scrollbar {flickableItem: list;}
}

