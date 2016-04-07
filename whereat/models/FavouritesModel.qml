import QtQuick 2.4
import "at_backend.js" as AT

// <<< *** ListModel 'favourites_model' : Used for Saved Tab on Homepage.
ListModel { id: favourites_model;

    property bool is_loading: false;

    function reload() {
        is_loading = true;
        favourites_model.clear();
        var f_len = u1db_favourites.get_n_stops();
        console.log("LENGTH: ", f_len);
        for (var i =0; i < f_len; i++) {
            var obj = u1db_favourites.get_stop_obj_at(i);
            var rn_obj = {
                "ln1" : obj.ln1,
                "ln2" : obj.ln2,
                "ln3" : obj.ln3,
                "is_favourite" : true,
                "thumb_src" : obj.thumb_src,
                "stop_id" : obj.stop_id,
                "lt_text" : ""
            };
            favourites_model.append(rn_obj);
            //favourites_model.set_thumb_src(obj.stop_id, i);
        }
        is_loading = false;
    }

    function force_reload() {
        u1db_favourites.force_reload();
        reload();
    }

    function update_favourites() {reload();}

    function set_thumb_src(in_stop_id, key_n) {

        var req = new XMLHttpRequest;
        var url = "https://api.at.govt.nz/v1/gtfs/stops/stopId/" + in_stop_id
                + "?api_key=" + at_api_key;
        console.log("THUMB SOURCE: ", url);
        req.open("GET", url);
        req.onreadystatechange = function() {
            favourites_model.setProperty(key_n, "thumb_src", "http://icdn.pro/images/en/p/i/picture-thumbnail-icone-8425-128.png")
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                var thumb_cood = String(objectArray.response[0].stop_lat) + "," + String(objectArray.response[0].stop_lon);
                var thumb_size = String(250) + "x" + String(170);
                var thumb_src = "https://maps.googleapis.com/maps/api/staticmap?"
                        + "center=" + thumb_cood
                        + "&zoom=" + 16 + "&scale=0.5"
                        + "&size=" + thumb_size
                        + "&markers=color:red%7C" + thumb_cood
                        + "&key=" + gsm_api_key;
                favourites_model.setProperty(key_n, "thumb_src", thumb_src);
            }
        }
        req.send();
    }

    Component.onCompleted: {reload();}

//    ListElement {
//        ln1: "1234"; ln2: "113 Oliver Road"; ln3: "Routes: 123, 234, 345"; lt_text: "";
//        is_favourite: true;
//        thumb_src: "http://www.davidluke.com/wp-content/themes/david-luke/media/ims/placeholder720.gif";
//        stop_id: "0000";
//    }
}
