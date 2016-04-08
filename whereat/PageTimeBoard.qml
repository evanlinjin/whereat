import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems

Page { id: page_timeboard;

    property string header_title : ""
    property string header_subtitle : ""
    property string stop_id: ""
    property bool is_favourite: u1db_favourites.is_f_stop(stop_id);

    TimeBoardModel {id: timeboard_model;} /*** MODEL ***/

    // Reload page when different stop_id.
    Component.objectName: stop_id;
    Component.onObjectNameChanged: {
        console.log("page_timeboard: ", stop_id);
        is_favourite = u1db_favourites.is_f_stop(stop_id);
        timeboard_model.n_results = 50; // Reset number of results to show.
        timeboard_model.reload(stop_id);
    }

    header: PageHeader { id: header;
        contents: CustomHeader {mainTitle: where_at.ptb_header_title; subTitle: where_at.ptb_header_subtitle; iconName: "location";}
        trailingActionBar.actions: [
            Action {iconName: "info"; text: "Information"; onTriggered: timeboard_bottom_edge.commit();},
            Action {iconName: "reload"; text: "Force Reload"; onTriggered: timeboard_model.reload(stop_id);},
            Action {iconName: where_at.ptb_is_favourite ? "starred" : "non-starred"; text: "Star"; onTriggered: favourites_toggle();}
        ]
        extension: Row { height: units.gu(4); spacing: units.gu(0.5); anchors {left: parent.left; right: parent.right;}
            Item { height: parent.height; width: units.gu(0.5); }
            TBM_Label {text: "ROUTE"; bold: true;}
            TBM_Label {text: "DESTINATION"; bold: true; width: parent.width - units.gu(17);}
            TBM_Label {text: "SCHED."; bold: true; width: units.gu(4.5);}
            TBM_Label {text: "DUE"; bold: true; al_r: true; width: units.gu(3.5);}
        }
    }

    UbuntuListView { id: timeboard_listview;
        anchors {top: header.bottom; bottom: parent.bottom; left: parent.left; right: parent.right;}
        clip: true;
        model: timeboard_model.model;
        delegate: ListItems.Standard {
            Row { height: parent.height; spacing: units.gu(0.5); anchors {left: parent.left; right: parent.right;}
                Item { height: parent.height; width: units.gu(0.5); }
                TBM_Label {text: model.route_short_name; fontSize: "small";}
                TBM_Label {text: model.trip_headsign.toUpperCase(); width: parent.width - units.gu(17); fontSize: "small";}
                TBM_Label {text: model.arrival_time.slice(0, 5); width: units.gu(4.5); fontSize: "small";}
                TBM_Label {text: "~"; al_r: true; width: units.gu(3.5); fontSize: "small";}
            }
            height: units.gu(5);
        }
        footer: Item {
            width: parent.width; height: button_lm.height + units.gu(4);
            ListItem { id: button_lm;
                visible: where_at.tbm_is_loading === false;
                width: parent.width; height: units.gu(5);
                anchors.top: parent.top; divider.visible: false;
                Label {anchors.centerIn: parent; text: "Load more...";}
                onClicked: {
                    timeboard_model.n_results += 10;
                    timeboard_model.reload_mr(stop_id);
                }
            }
        }

        PullToRefresh { id: tb_ptr;
            //refreshing: where_at.tbm_is_loading === true;
            onRefresh: timeboard_model.reload(stop_id);
            onRefreshingChanged: {console.log("REFRESHING IS NOW: ", refreshing);}
        }

        EmptyState { id: tb_es;
            visible: timeboard_model.model.count === 0 && where_at.tbm_is_loading === false;
            iconName: "weather-showers-symbolic";
            title: i18n.tr("Nothing to show")
            subTitle: "I apologise if you need to get somewhere"
        }
        Scrollbar {flickableItem: timeboard_listview;}
    }

    Timer {
        running: true; interval: 1000; repeat: true;
        onTriggered: {tb_ptr.refreshing = where_at.tbm_is_loading;}
    }

    BottomEdge { id: timeboard_bottom_edge;
        width: page_timeboard.width; height: page_timeboard.height/2;
        hint.text: "Stop Information."; hint.iconName: "info"; hint.status: "Active";

        contentComponent: Loader {
            source: "StopInfoView.qml";
            width: timeboard_bottom_edge.width;
            height: timeboard_bottom_edge.height;
            asynchronous: true;
        }
    }

    function favourites_toggle() {
        if (where_at.ptb_is_favourite) {
            console.log("PageTimeBoard: remove_stop(), INPUT: ", stop_id);
            u1db_favourites.remove_stop(stop_id);
        } else {
            console.log("PageTimeBoard: add_stop(), INPUT:", stop_id, "[array here]");
            u1db_favourites.add_stop(stop_id, [where_at.ptb_header_title, where_at.ptb_header_subtitle, "", ""]);
        }
        where_at.ptb_is_favourite = u1db_favourites.is_f_stop(stop_id);
    }
}

