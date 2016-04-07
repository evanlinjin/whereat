import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem { id: item;
    z: nearby_view.z + 200;
    color: Theme.palette.normal.raised;
    contentItem.anchors {leftMargin: units.gu(2); rightMargin: units.gu(2);}
    Row { id: rad_row;
        spacing: units.gu(2);
        Label { id: r_label_1;
            height: parent.height; verticalAlignment: Text.AlignVCenter;
            text: "Radius"; fontSize: "small";
        }
        Slider { id: radius_slider;
            width: page.width - units.gu(17); height: item.height;
            function formatValue(v) { return v.toFixed(2); }
            minimumValue: 10; maximumValue: 999; live: false;
            value: pos_set.search_radius;
            onValueChanged: {pos_set.search_radius = value; nearby_model.force_reload();}
        }
        Label { id: r_label_2;
            height: parent.height; verticalAlignment: Text.AlignVCenter;
            text: pos_set.search_radius + "m"; fontSize: "small";
        }
    }
    height: units.gu(4);
}
