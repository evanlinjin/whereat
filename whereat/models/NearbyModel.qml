import QtQuick 2.4
import "at_backend.js" as AT

// <<< *** ListModel 'nearby_model' : Used for Nearby Tab on Homepage.
ListModel { id: nearby_model;

    property bool is_loading: false;

    // *** FUNCTION 'nearby_model.reload()'
    // *** Description: Reloads ListModel 'nearby_model'.
    // *** Notes: Will only actually reload if coordinates have changed significantly.
    function reload() {
        is_loading = true; /////////////////////////////////////////////////////////////////////////////////////////////
        nearby_model.update_favourites();

        if (positionSource.has_changed) {
            nearby_model.clear();
            var req = new XMLHttpRequest;
            var url = "https://api.at.govt.nz/v1/gtfs/stops/geosearch?"
                    + "lat=" + pos_set.current_lat
                    + "&lng=" + pos_set.current_lon
                    + "&distance=" + pos_set.search_radius
                    + "&api_key=" + at_api_key;

            console.log("Request: " + url);
            req.open("GET", url);
            req.onreadystatechange = function() {
                if (req.readyState === XMLHttpRequest.DONE) {
                    var objectArray = JSON.parse(req.responseText);
                    for (var key in objectArray.response) {
                        var jsonObject = {
                            "ln1" : objectArray.response[key].stop_code,
                            "ln2" : objectArray.response[key].stop_name,
                            "ln3" : "",
                            "lt_text" : (objectArray.response[key].st_distance_sphere).toFixed(0) + "m",
                            "is_favourite" : u1db_favourites.is_f_stop(objectArray.response[key].stop_id),
                            "thumb_src" : "",
                            "stop_id" : objectArray.response[key].stop_id
                        };
                        nearby_model.append(jsonObject);
                        //nearby_model.set_routes(objectArray.response[key].stop_id, key);
                    }
                }
                is_loading = false; ////////////////////////////////////////////////////////////////////////////////////
            }
            req.send();
            positionSource.has_changed = false;
        }
    }

    // *** FUNCTION 'nearby_model.force_reload()'
    // *** Description: Forcefully Reloads ListModel 'nearby_model'.
    function force_reload() {
        positionSource.has_changed = true;
        nearby_model.reload();
    }

    // *** FUNCTION 'nearby_model.set_routes(stop_id, key_n)'
    // *** Description: Finds and sets Routes for ListModel 'nearby_model'.
    // *** Notes: Used by 'nearby_model.reload()'.
    // *** Inputs: 'stop_id' : integer/string representing the stop_id.
    // ***         'key_n'   : integer representing position in ListModel 'nearby_model'.
    function set_routes(stop_id, key_n) {
        var req = new XMLHttpRequest;
        var url = "https://api.at.govt.nz/v1/gtfs/routes/stopid/" + stop_id
                + "?api_key=" + at_api_key;
        req.open("GET", url);
        req.onreadystatechange = function() {
            var return_array = [];
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                for (var key in objectArray.response) {
                    return_array.push(" " + objectArray.response[key].route_short_name);
                }
                nearby_model.setProperty(key_n, "ln3", AT.uniq(return_array).toString());
            }
        }
        req.send();
    }

    function update_favourites() {
        for (var i = 0; i < nearby_model.count; i++) {
            nearby_model.setProperty(i, 'is_favourite', u1db_favourites.is_f_stop(nearby_model.get(i).stop_id));
        }
    }

    //Component.onCompleted: {reload();}

    // Sample ListElement.
//    ListElement {
//        ln2: "113 Oliver Road"; ln1: "1234"; ln3: "123, 234, 345"; lt_text: "30m";
//        is_favourite: false;
//        thumb_src: "http://www.davidluke.com/wp-content/themes/david-luke/media/ims/placeholder720.gif";
//        stop_id: "0000";
//    }
}
