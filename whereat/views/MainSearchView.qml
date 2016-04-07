import QtQuick 2.4
//import QtQml 2.2
//import QtQuick.Layouts 1.1
//import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
//import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Rectangle { id: search_container;

    //property alias bec;

    // width: parent.width; height: parent.height;
    color: Theme.palette.normal.background;

    MainSearchResultsModel {id: main_search_results_model;} /*** MODEL ****/

    PageHeader { id: main_search_header;
        contents: TextField { id: main_search_textfield;
            anchors.verticalCenter: parent.verticalCenter;
            width: parent.width;
            placeholderText: "Search for a stop, station or peir...";
            highlighted: true;
            inputMethodHints: Qt.ImhNoPredictiveText;
            text: main_search_results_model.search_query;
            onAccepted: reload_list(main_search_textfield.text);
        }
        leadingActionBar.actions: [
            Action {iconName: "close"; text: "Close"; onTriggered: home_bottom_edge.collapse();}
        ]
    }

    MainListView { id: main_search_view;

        anchors.top: main_search_header.bottom;
        anchors.bottom: search_container.bottom;
        anchors.left: search_container.left;
        anchors.right: search_container.right;

        grid_model: main_search_results_model;
        thumb_str: "location";
        //hide_thumb: true;

        ptr.refreshing: main_search_results_model.is_loading;
        ptr.onRefresh: reload_list(main_search_textfield.text);

        Scrollbar {flickableItem: main_search_view;}
    }

    function reload_list(search_str) {
        main_search_results_model.search_query = main_search_textfield.text;
        main_search_results_model.reload();
    }

    function clear_query() {
        main_search_results_model.search_query = main_search_textfield.text = "";
    }

    Component.onCompleted: {main_search_results_model.update_favourites(); ms_tf_timer.start();}

    Timer { id: ms_tf_timer;
        interval: 200; running: false; repeat: false;
        onTriggered: {main_search_textfield.focus = true;}
    }

    //home_bottom_edge.onCommitCompleted: main_search_textfield.focus = true;
}

