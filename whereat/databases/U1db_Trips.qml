import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "at_backend.js" as AT

Item { id: u1db_item;

    property var db: null;
    property ListModel model: ListModel {}

    property string debug: "DB TRIPS:";

    /*********************************************************************************************** PUBLIC FUNCTIONS */

    // FUNCTION 'rq_rid_hs(trip_id) >>>
    // Finds 'route_id' & 'trip_headsign' from specified 'trip_id'.
    // Returns empty strings if failed.
    function rq_rid_hs(trip_id) {
        db_open();
        var out_array = ["", ""];
        out_array[0] = db_get(trip_id, "route_id");
        out_array[1] = db_get(trip_id, "trip_headsign");
        console.log(debug, "rq_rid_hs(trip_id) returning: ", out_array[0], out_array[1]);
        return out_array;
    }

    // FUNCTION 'force_download_all()' >>
    // Forces a complete update on 'trips' db.
    function force_download_all() {
        db_open();
        console.log(debug, "STATUS UPDATE: [DOWNLOAD BEGIN]");
        var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/trips?api_key=" + at_api_key);
        req.onreadystatechange = function() {

            if (req.readyState === XMLHttpRequest.DONE) {
                console.log(debug, "STATUS UPDATE: [DOWNLOAD COMPLETE]");
                console.log(debug, "STATUS UPDATE: Finding latest version...");

                var objectArray = JSON.parse(req.responseText).response;

                // Get latest trip_id version >>>
                // Loop through and split "50051017900-20160316100058_v39.6" to "20160316100058".
                // Find largest number.
                var _latest = 0;
                var ti_int = []; // From "trip_id", grab dates in number form.

                for (var key in objectArray) {
                    var ti_str = objectArray[key].trip_id;
                    ti_int.push( Number(ti_str.slice(ti_str.indexOf('-')+1, ti_str.indexOf('_'))) );
                    if (ti_int[key] > _latest) {_latest = ti_int[key];}
                }

                console.log(debug, "STATUS UPDATE: OK! Latest version: ", _latest);
                console.log(debug, "STATUS UPDATE: Begin Loading into database...");

                for (key in objectArray) {
                    console.log(debug, "COMPARING: ", ti_int[key], " WITH ", _latest);
                    if (ti_int[key] === _latest) {

                        db_add(
                                    objectArray[key].trip_id,
                                    objectArray[key].route_id,
                                    objectArray[key].service_id,
                                    objectArray[key].trip_headsign,
                                    objectArray[key].direction_id,
                                    objectArray[key].block_id,
                                    objectArray[key].shape_id,
                                    objectArray[key].trip_short_name,
                                    objectArray[key].trip_type
                                    );
                        console.log(debug, "(" + key + "/" + objectArray.length + ")LOAD: ", objectArray[key].trip_id);
                    } else {
                        console.log(debug, "(" + key + "/" + objectArray.length + ")SKIP: ", "trips Element Outdated.");
                    }
                }
                trips_working = false;
                console.log(debug, "STATUS UPDATE: DONE!");
            }
        }
        req.send();
    }

    // FUNCTION 'reload_model()' >>
    // Forces a complete reload on 'trips' lm.
    function reload_model() {
        db_open(); model.clear();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM trips');
            for (var i = 0; i < rs.rows.length; i++) {
                model.append(rs.rows.item(i));
            }
        });
    }

    /********************************************************************************************** PRIVATE FUNCTIONS */

    // FUNCTION 'db_open()' >>>
    // Opens 'list' db from SQLite.
    function db_open() {
        if (db !== null) {return;}         // Return if db already loaded.

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("AT", "0.1", "Stores Data from AT Transport", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql(
                            'CREATE TABLE IF NOT EXISTS trips(' +
                            'trip_id            TEXT PRIMARY KEY    NOT NULL,' +
                            'route_id           TEXT                NOT NULL,' +
                            'service_id         TEXT                NOT NULL,' +
                            'trip_headsign      TEXT                NOT NULL,' +
                            'direction_id       INT                 NOT NULL,' +
                            'block_id           TEXT                        ,' +
                            'shape_id           TEXT                NOT NULL,' +
                            'trip_short_name    TEXT                        ,' +
                            'trip_type          TEXT                         ' + ')'
                            );
                var table_len  = tx.executeSql("SELECT * FROM trips").rows.length;
                console.log("LOADED: DB 'trips' with ", table_len, " elements.");
            });
        } catch (err) { console.log("ERROR: creating table in database: " + err); };
    }

    // FUNCTION 'db_add()' >>>
    // Adds a 'trips' db element.
    // Inputs: [ TEXT x4], INT, [ TEXT x4].
    function db_add(trip_id, route_id, service_id, t_hs, d_id, b_id, s_id, t_sn, t_t) {
        db.transaction( function(tx) {
            tx.executeSql('INSERT OR REPLACE INTO trips VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                          [trip_id, route_id, service_id, t_hs, d_id, b_id, s_id, t_sn, t_t] );
        });
    }

    // FUNCTION 'db_get(trip_id, key)' >>>
    // Returns value from selected 'trip_id' and 'key'.
    function db_get(trip_id, key) {
        //db_open();
        var res = "";
        db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT ' + key + ' FROM trips WHERE trip_id=?', [trip_id]);
            if (rs.rows.item(0) === undefined) {return 0;} // TODO: Inform user that their AT DB is outdated.
            res = rs.rows.item(0)[key];
            //console.log("I GOT: ", res, typeof res, " FROM: ", key, trip_id);
        });
        return res;
    }

    // FUNCTION 'db_getList()' >>>
    // Returns a list of 'trip_id's stored in 'trips' db.
    function db_getList() {
        //db_open();
        var res = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT trip_id FROM trips');

            for (var i = 0; i < rs.rows.length; i++) {
                res.push(String(rs.rows.item(i).trip_id));
            }
        });
        return res;
    }
}

