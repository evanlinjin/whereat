import QtQuick 2.4
import Ubuntu.Components 1.3
import QtLocation 5.3
import QtPositioning 5.2
import Qt.labs.settings 1.0
import "at_backend.js" as AT

MainView { id: where_at;

    objectName: "mainView";
    applicationName: "whereat.evanlinjin";

    property string app_version: "0.4.44"
    property string app_description: i18n.tr("An app for quick public transport information. Currently, only Auckland Transport is supported. This is the Alpha version and is in heavy development.")

    property string at_api_key: "4928a9ac-16b9-4879-a2f3-73c460023d21";
    property string gsm_api_key: "AIzaSyAajNuWYbFbLoOLl7fPOBS3oxt1gLa6ZHk";

    theme.name: "Ubuntu.Components.Themes.Ambiance"; // "Ubuntu.Components.Themes.SuruDark";
    width: units.gu(100); height: units.gu(75);

    AdaptivePageLayout { id: whereat_apl;
        anchors.fill: parent;
        primaryPageSource: Qt.resolvedUrl("PageHome.qml");

        layouts: PageColumnsLayout {
            PageColumn {minimumWidth: units.gu(40); maximumWidth: units.gu(70); preferredWidth: units.gu(40);}
            PageColumn {fillWidth: true;}
        }
    }


    // PageTimeBoard Variables.
    property string ptb_header_title: "";
    property string ptb_header_subtitle: "";
    property bool ptb_is_favourite: false;
    // TimeBoardModel Variables.
    property bool tbm_is_loading: false;

    // Database Variables.
    property bool calendar_working: false;
    property bool routes_working: false;
    property bool trips_working: false;

    property var db_set: Settings {
        property bool updated: true;
    }

    // <<< *** DATABASES *** >>> //

    U1db_Favourites {id: u1db_favourites;}
    property var favourites_index: Settings {property int i: 0;}

    // <<< *** POSITIONING *** >>> //

    PositionSource {id: positionSource;
        property bool has_changed: true;
        updateInterval: 10000; active: true;
        onPositionChanged: {
            var lat = (positionSource.position.coordinate.latitude).toFixed(6);
            var lon = (positionSource.position.coordinate.longitude).toFixed(5);

            // Check if 'lon' and 'lat' values have changed.
            if (pos_set.current_lat !== lat && pos_set.current_lon !== lon) {

                // Only mark as changes if changes are big.
                if (Math.abs(pos_set.current_lat - lat) > 0.00005 ||
                        Math.abs(pos_set.current_lon - lon) > 0.00005
                        ) {
                    positionSource.has_changed = true;
                    console.log("COORDINATES CHANGED:", lon, lat);
                    pos_set.current_lat = lat;
                    pos_set.current_lon = lon;
                }
            }
        }
    }

    property var pos_set: Settings {
        property string current_lat: "-36.879091";
        property string current_lon: "174.91127";
        property int search_radius: 300;
    }
}

