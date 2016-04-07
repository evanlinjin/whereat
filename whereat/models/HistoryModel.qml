import QtQuick 2.4
import "at_backend.js" as AT

ListModel { id: history_model;

    property bool is_loading: false;

//    ListElement {
//        ln3: "Last visited: 6:15pm,  Today"; ln1: "1234"; ln2: "113 Oliver Road"; lt_text: "";
//        is_favourite: false;
//        thumb_src: "http://www.davidluke.com/wp-content/themes/david-luke/media/ims/placeholder720.gif";
//        stop_id: "0000";
//    }

    function force_reload() {
        is_loading = false;
    }
}
