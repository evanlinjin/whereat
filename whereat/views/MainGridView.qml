import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Item { id: grid_container;
    /*** Public Attributes ***/

    // Captions
    property bool show_bold_title: true
    property bool show_bold_subtitle: true
    property bool show_bold_text: false

    // Config
    property int caption_height: 8

    // Model
    property ListModel grid_model: ListModel {ListElement {ln1: "Nothing to show."}}

    width: parent.parent.width
    height: parent.parent.height

    /*****************************/

    GridView { id: grid;
        anchors.centerIn: parent;
        height: parent.height //- units.gu(1);
        width: parent.width //- units.gu(1);
        cellWidth: height > width ? width/2 : width/3;
        cellHeight: cellWidth * (4/5);
        clip: true;
        model: grid_model;

        delegate: Item {
            width: grid.cellWidth;
            height: grid.cellHeight;

            Rectangle {
                anchors.centerIn: parent;
                width: parent.width - units.gu(1);
                height: parent.height - units.gu(1);
                color: Theme.palette.normal.foreground;

                Image { id: stop_thumbnail;
                    anchors.fill: parent;
                    anchors.bottomMargin: units.gu(caption_height - 1);
                    fillMode: Image.PreserveAspectCrop;
                    cache: true;
                    source: model.thumb_src;
                }

                LinearGradient { id: star_gradient;
                    anchors.fill: parent;
                    start: Qt.point(300, 0); end: Qt.point(0,300);
                    gradient: Gradient {
                        GradientStop {position: 0.0; color: Theme.palette.normal.background;}
                        GradientStop {position: 0.6; color: "#00000000";}
                    }
                }

                Icon {id: favourite_icon;
                    anchors.right: parent.right;
                    anchors.top: parent.top;
                    anchors.rightMargin: units.gu(1);
                    anchors.topMargin: units.gu(1);
                    height: units.gu(3); width: units.gu(3); z: star_gradient.z + 1;
                    name: model.is_favourite ? "starred" : "non-starred";
                    color: Theme.palette.normal.overlayText;
                }

                Captions { id: stop_caption;
                    anchors.leftMargin: units.gu(1);
                    anchors.topMargin: units.gu(1);
                    anchors.bottomMargin: units.gu(1);
                    anchors.rightMargin: units.gu(1); //5??
                    anchors.bottom: parent.bottom;
                    anchors.left: parent.left;
                    anchors.right: parent.right;

                    spacing: units.gu(0.3);
                    title.text: model.ln1; title.font.bold: show_bold_title;
                    Label {text: model.ln2; font.bold: show_bold_subtitle; textSize: Label.XSmall;}
                    Label {text: model.ln3; font.bold: show_bold_text; textSize: Label.XxSmall;}
                }
            }

            MouseArea { id: timeboard_mousearea;
                anchors.fill: parent;
                onClicked: {
                    Haptics.play({duration: 25, attackIntensity: 0.7});
                    page.pageStack.addPageToNextColumn(page, Qt.resolvedUrl("PageTimeBoard.qml"), {
                                                           header_title: model.ln1,
                                                           header_subtitle: model.ln2,
                                                           stop_id: model.stop_id
                                                       });
                }
            }

            MouseArea { id: favourite_mousearea;
                anchors.right: parent.right;
                anchors.top: parent.top;
                height: units.gu(5);
                width: units.gu(5); z: timeboard_mousearea.z + 1;
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
        footer: Item {width: parent.width; height: units.gu(4);}
    }
    Scrollbar {flickableItem: grid;}
}
