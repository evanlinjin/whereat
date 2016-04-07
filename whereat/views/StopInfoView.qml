import QtQuick 2.4
//import QtQml 2.2
//import QtQuick.Layouts 1.1
//import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
//import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Rectangle { id: timeboard_details;
    //visible: true; width: timeboard_bottom_edge.width; height: timeboard_bottom_edge.height;
    MouseArea {width: parent.width; height: page_timeboard.height - parent.height; anchors.bottom: parent.top; anchors.left: parent.left; onClicked: timeboard_bottom_edge.collapse();}
    ListView { id: side_scroller;

        model: VisualItemModel {
            Image { id: map;
                height: timeboard_details.height; width: timeboard_details.width;
                fillMode: Image.PreserveAspectCrop; cache: true;
                Component.onCompleted: {
                    var thumb_cood = String(timeboard_model.info.get(0).stop_lat) + "," + String(timeboard_model.info.get(0).stop_lon);
                    var thumb_size = Math.round(width/2) + "x" + Math.round(height/2 + 30);
                    map.source = "https://maps.googleapis.com/maps/api/staticmap?"
                            + "center=" + thumb_cood
                            + "&zoom=" + 16 + "&scale=2"
                            + "&size=" + thumb_size
                            + "&markers=color:red%7C" + thumb_cood
                            + "&key=" + gsm_api_key;
                }
            }
            Rectangle { id: map2;
                height: timeboard_details.height; width: timeboard_details.width;
                color: "blue";
            }
            Rectangle { id: map3;
                height: timeboard_details.height; width: timeboard_details.width;
                color: "green";
            }
            Rectangle { id: map4;
                height: timeboard_details.height; width: timeboard_details.width;
                color: "red";
            }
        }

        clip: true;
        anchors.fill: parent;
        orientation: Qt.Horizontal;
        snapMode: ListView.SnapOneItem;
        highlightMoveDuration: UbuntuAnimation.FastDuration
    }

    Scrollbar {flickableItem: side_scroller;}
}
