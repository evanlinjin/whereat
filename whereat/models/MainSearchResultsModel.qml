import QtQuick 2.4
import "at_backend.js" as AT

// <<< *** ListModel 'main_search_results_model' : Used for Timeboard Searchpage on the Bottom Edge of Homepage.
ListModel { id: main_search_results_model;

    property bool is_loading: false;
    property string search_query: "";
    //property int n_results: 20;

    // *** FUNCTION 'main_search_results_model.reload()'
    // *** Description: Change query and reloads ListModel 'main_search_results_model'.
    // *** Notes: Used every search request.
    function reload() {
        main_search_results_model.clear(); is_loading = true;
        if (search_query === "") {is_loading = false; return;}

        var req = new XMLHttpRequest;
        var url = "https://api.at.govt.nz/v1/gtfs/stops/search/" + search_query + "?api_key=" + at_api_key;
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
                        "lt_text" : "",
                        "is_favourite" : u1db_favourites.is_f_stop(objectArray.response[key].stop_id),
                        "thumb_src" : "",
                        "stop_id" : objectArray.response[key].stop_id
                    };
                    main_search_results_model.append(jsonObject);
                    //main_search_results_model.set_routes(objectArray.response[key].stop_id, key);
                    //if (key > n_results) {break;}
                }
            }
            is_loading = false;
        }
        req.send(); return true;
    }

    function update_favourites() {reload();}

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
                main_search_results_model.setProperty(key_n, "ln3", AT.uniq(return_array).toString());
            }
        }
        req.send();
    }
}
