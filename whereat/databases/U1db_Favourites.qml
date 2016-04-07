import QtQuick 2.4
import Ubuntu.Components 1.3
import U1db 1.0 as U1db
import "at_backend.js" as AT

Item { id: u1db_item;
    U1db.Database {id: favourites_db; path: "favourites_database";}

    U1db.Index {id: f_stops_index;
        database: favourites_db;
        expression: ["stops.sort_i", "stops.stop_id", "stops.ln1", "stops.ln2", "stops.ln3", "stops.thumb_src"];
    }

    U1db.Query {id: f_stops_query;
        index: f_stops_index;
        query: ["*", "*", "*", "*", "*"];
    }

    // FUNCTION: add a bus stop via stop_id.
    // Input data : [ln1, ln2, ln3, thumb_src]
    function add_stop(in_stop_id, data) {
        console.log("ADDING FAVOURITE: ", in_stop_id, String(data));
        favourites_db.putDoc({stops:{
                                     sort_i: f_stops_query.results.length,
                                     stop_id: String(in_stop_id),
                                     ln1: data[0],
                                     ln2: data[1],
                                     ln3: data[2],
                                     thumb_src: data[3]
                                 }}, String(in_stop_id));
        //set_thumb_src(in_stop_id);
        //set_routes(in_stop_id);
    }

    function set_thumb_src(in_stop_id) {
        console.log("LOADING THUMB IN FAVOURITE: ", in_stop_id);
        var req = new XMLHttpRequest;
        var url = "https://api.at.govt.nz/v1/gtfs/stops/stopId/" + in_stop_id
                + "?api_key=" + at_api_key;
        console.log("THUMB SOURCE: ", url);
        req.open("GET", url);
        req.onreadystatechange = function() {
            var doc_obj = favourites_db.getDoc(String(in_stop_id));
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                var thumb_cood = String(objectArray.response[0].stop_lat) + "," + String(objectArray.response[0].stop_lon);
                var thumb_size = String(250) + "x" + String(170);
                doc_obj.stops.thumb_src = "https://maps.googleapis.com/maps/api/staticmap?"
                        + "center=" + thumb_cood
                        + "&zoom=" + 16 + "&scale=0.5"
                        + "&size=" + thumb_size
                        + "&markers=color:red%7C" + thumb_cood
                        + "&key=" + gsm_api_key;

                favourites_db.putDoc(doc_obj, String(in_stop_id));
            }
        }
        req.send();
    }


    function set_routes(in_stop_id) {
        console.log("LOADING ROUTES IN FAVOURITE: ", in_stop_id);
        var req = new XMLHttpRequest;
        var url = "https://api.at.govt.nz/v1/gtfs/routes/stopid/" + in_stop_id
                + "?api_key=" + at_api_key;
        console.log("ROUTES SOURCE: ", url);
        req.open("GET", url);
        req.onreadystatechange = function() {
            var doc_obj = favourites_db.getDoc(String(in_stop_id));
            var return_array = [];
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                for (var key in objectArray.response) {
                    return_array.push(" " + objectArray.response[key].route_short_name);
                }
                doc_obj.stops.ln3 = AT.uniq(return_array).toString();
                favourites_db.putDoc(doc_obj, String(in_stop_id));
            }
        }
        req.send();
    }

    // FUNCTION: remove a bus stop.
    function remove_stop(in_stop_id) {
        favourites_db.deleteDoc(String(in_stop_id));
    }

    // FUNCTION: get_stop_obj_at.
    function get_stop_obj_at(s_index) {return f_stops_query.results[s_index];}

    // FUNCTION: Get the number of saved stops.
    function get_n_stops() {return f_stops_query.documents.length;}

    // FUNCTION: Get stop index.
    function get_stop_index(in_stop_id) {
        return favourites_db.getDoc(String(in_stop_id)).sort_i;
    }

    // FUNCTION: Returns true if stop_id is favourite.
    function is_f_stop(in_stop_id) {
        //console.log("DOCUMENTS: ", f_stops_query.documents);
        for (var i = 0; i < f_stops_query.results.length; i++) {
            //console.log("COMPARING: ", f_stops_query.documents[i], "with", String(in_stop_id))
            if (f_stops_query.documents[i] === String(in_stop_id)) {return true;}
        }
        return false;
    }

    function force_reload() {
        for (var i = 0; i < f_stops_query.results.length; i++) {
            //set_thumb_src(f_stops_query.documents[i]);
            //set_routes(f_stops_query.documents[i]);
        }
    }
}


