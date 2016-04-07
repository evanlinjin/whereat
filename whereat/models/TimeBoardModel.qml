import QtQuick 2.4
import "at_backend.js" as AT

// <<< *** ListModel 'timeboard_model' : Used for the Timeboard page.
Item { id: timeboard_model_item;

    property alias model: timeboard_model;
    property alias info: tbm_stop_model;
    //property bool is_loading: false;

    property int n_results: 10;

    signal loadStopComplete();
    signal loadRoutesCompleted();
    signal loadTimesCompleted();

    onLoadStopComplete: {
        where_at.ptb_header_title = get_stop_model().stop_code;
        where_at.ptb_header_subtitle = get_stop_model().stop_name;
        where_at.ptb_is_favourite = u1db_favourites.is_f_stop(get_stop_model().stop_id);
    }

    onLoadRoutesCompleted: {}

    onLoadTimesCompleted: {
        console.log("tbm_times_model.count: ", tbm_times_model.count);

        // Get latest trip_id version.
        // Loop through and split "50051017900-20160316100058_v39.6" to "20160316100058".
        // Find largest number.
        var _latest = 0;
        var ti_int = []
        for (var i = 0; i < tbm_times_model.count; i++) {
            var ti_str = tbm_times_model.get(i).trip_id;
            ti_int.push( Number(ti_str.slice(ti_str.indexOf('-')+1, ti_str.indexOf('_'))) );
            if (ti_int[i] > _latest) {_latest = ti_int[i];}
        }

        // SORT & CLEAN: Loop through "tbm_times_model". >>

        // REMOVE SERVICES THAT WON"T HAPPEN TODAY or SERVICES THAT HAS ALREADY HAPPENED BY 5 MINUTES.
        // Looping Backwards so remove operations will not cause element skip.
        for (i = tbm_times_model.count - 1; i >= 0; i--) {
            //console.log("RUN: u1db_calendar.rq_day(?,?)", tbm_times_model.get(i).trip_id, AT.get_day_str());
            if (_latest !== ti_int[i]) {
                console.log("REMOVING Times Element: ", i, "as this service is outdated.");
                tbm_times_model.remove(i, 1);
            }
            else if (u1db_calendar.rq_day(tbm_times_model.get(i).trip_id, AT.get_day_str()) === 0) {
                console.log("REMOVING Times Element: ", i, "as this service doesn't happen today.");
                tbm_times_model.remove(i, 1);
            }
            else if (tbm_times_model.get(i).arrival_time_seconds + 300 /*5min*/ < AT.now_in_s()) {
                console.log("REMOVING Times Element: ", i, "as now is ", AT.now_in_s(), " and service was at ", tbm_times_model.get(i).arrival_time_seconds);
                tbm_times_model.remove(i, 1);
            }

        }

        // SORT SERVICES FROM EARLIEST TO LATEST.
        console.log("BEGIN SORT: ", tbm_times_model.count, "elements.");
        for (i = 0; i < tbm_times_model.count - 1; i++) {
            // Find earliest service.
            var earliest = i;
            for (var j = i; j < tbm_times_model.count; j++) {
                if (tbm_times_model.get(j).arrival_time_seconds
                        < tbm_times_model.get(earliest).arrival_time_seconds) {
                    earliest = j;
                }
            }
            // Swap earliest.
            tbm_times_model.move(earliest, i, 1);
        }
        console.log("SORT FINISHED.");

        // TIMEBOARD SHOULD ONLY SHOW AT MOST 'n_results' NUMBER OF RESULTS.
        if (tbm_times_model.count - 1 > n_results) {
            tbm_times_model.remove(n_results, tbm_times_model.count - n_results);
        }

        // APPEND TO TIMEBOARD >>>
        for (i = 0; i  < tbm_times_model.count; i++) {
            var obj = tbm_times_model.get(i);

            obj.route_id = "";
            obj.service_id = "";
            obj.trip_headsign = "";
            obj.agency_id = "";
            obj.route_short_name = "";
            obj.route_long_name = "";

            // APPEND TO TIMEBOARD (timeboard_model) >>>
            timeboard_model.append(obj);
            load_more(i);
        }

        // SEND SIGNAL >>>
        where_at.tbm_is_loading = false; //////////////////////////////////////////////////////////////////////////////////////////////////////
    }


    function load_more(index) {
        if (timeboard_model.get(index) === undefined) {return;}
        else {
            // LOAD ADDITIONAL INFORMATION FROM "Get Trips From trip_id" & 'tbm_routes_model' >>>
            var req = new XMLHttpRequest;
            req.open("GET", "https://api.at.govt.nz/v1/gtfs/trips/tripId/" + timeboard_model.get(index).trip_id + "?api_key=" + at_api_key);
            req.onreadystatechange = function() {
                if (JSON.parse(req.responseText) === undefined) {load_more(index); return;}
                else {
                    var obj = JSON.parse(req.responseText).response[0];
                    timeboard_model.get(index).route_id = obj.route_id;
                    timeboard_model.get(index).service_id = obj.service_id;
                    timeboard_model.get(index).trip_headsign = obj.trip_headsign;

                    for (var j = 0; j < tbm_routes_model.count; j++) {
                        var obj2 = tbm_routes_model.get(j);
                        if (obj2.route_id === obj.route_id) {
                            timeboard_model.get(index).agency_id = obj2.agency_id;
                            timeboard_model.get(index).route_short_name = obj2.route_short_name;
                            timeboard_model.get(index).route_long_name = obj2.route_long_name;
                            break;
                        }
                    }
                }
            }
            req.send();
        }
    }


    // *** FUNCTION 'timeboard_model.reload()'
    // *** Description: Reloads ListModel 'timeboard_model'.
    function reload(in_stop_id) {
        console.log("timeboard_model: reload(in_stop_id)", in_stop_id);
        timeboard_model.clear();
        where_at.tbm_is_loading = true; //////////////////////////////////////////////////////////////////////////////////////////////////////

        // Load additional list models.
        load_stop(in_stop_id);
        load_routes(in_stop_id);
        load_times(in_stop_id);
    }

    function reload_mr(in_stop_id) {
        console.log("timeboard_model: reload_mr(in_stop_id)", in_stop_id);
        where_at.tbm_is_loading = true; //////////////////////////////////////////////////////////////////////////////////////////////////////
        timeboard_model.clear();

        // Load additional list models.
        load_times(in_stop_id);
    }

    // <<< LISTMODELS >>> //
    ListModel { id: timeboard_model; }  // Main ListModel.
    ListModel { id: tbm_stop_model; }   // Basic info about the stop.
    ListModel { id: tbm_routes_model; } // Routes which pass the stop..
    ListModel { id: tbm_times_model; }  // Stop Times about the stop.

    // <<< FUNCTIONS OF "tbm_stop_model" >>> //
    function get_stop_model() {return tbm_stop_model.get(0);}
    function load_stop(in_stop_id) {
        tbm_stop_model.clear(); var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/stops/stopId/" + in_stop_id + "?api_key=" + at_api_key);
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {tbm_stop_model.append(JSON.parse(req.responseText).response[0]); timeboard_model_item.loadStopComplete();}
        }
        req.send();
    }

    // <<< FUNCTIONS OF "tbm_routes_model" >>> //
    function get_routes_model(in_index) {return tbm_routes_model.get(in_index);}
    function load_routes(in_stop_id) {
        tbm_routes_model.clear(); var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/routes/stopid/" + in_stop_id + "?api_key=" + at_api_key);
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                for (var key in objectArray.response) {tbm_routes_model.append(objectArray.response[key]);}
                timeboard_model_item.loadRoutesCompleted();
            }
        }
        req.send();
    }

    // <<< FUNCTIONS OF "tbm_times_model" >>> //
    function get_times_model(in_index) {return tbm_times_model.get(in_index);}
    function load_times(in_stop_id) {
        tbm_times_model.clear(); var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/stopTimes/stopId/" + in_stop_id + "?api_key=" + at_api_key);
        req.onreadystatechange = function() {
            if (req.readyState === XMLHttpRequest.DONE) {
                var objectArray = JSON.parse(req.responseText);
                for (var key in objectArray.response) {
                    tbm_times_model.append(objectArray.response[key]);
                    //console.log("ADDING TO tbm_times_model: ", JSON.stringify(objectArray.response[key]));
                }
                timeboard_model_item.loadTimesCompleted();
            }
        }
        req.send();
    }
}
