import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "at_backend.js" as AT

Item { id: u1db_item;

    property var db: null;
    property ListModel model: ListModel {}

    property string debug: "DB STOPS:";

    /*********************************************************************************************** PUBLIC FUNCTIONS */

    // FUNCTION 'rq_stop(stop_id)' >>>
    // Finds 'stop_name', 'stop_lat', 'stop_lon' & 'stop_code' from specified 'stop_id'.
    // Returns empty strings/ints if failed.
    function rq_stop(stop_id) {
        db_open();
        var out_array = ["", 0, 0, ""];
        out_array[0] = db_get(stop_id, "stop_name"); //String
        out_array[1] = db_get(stop_id, "stop_lat");  //Int
        out_array[2] = db_get(stop_id, "stop_lon");  //Int
        out_array[3] = db_get(stop_id, "stop_code"); //String
        console.log(debug, "rq_stop(stop_id) returning: ", out_array);
        return out_array;
    }

    // FUNCTION 'force_download_all()' >>
    // Forces a complete update on 'stops' db.
    function force_download_all() {
        db_open();
        console.log(debug, "Download Start.");
        var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/stops?api_key=" + at_api_key);
        req.onreadystatechange = function() {

            if (req.readyState === XMLHttpRequest.DONE) {
                console.log(debug, "Download Complete.");

                var objectArray = JSON.parse(req.responseText).response;
                where_at.r_total = objectArray.length; // no. of elements.
                where_at.r_i = 0; // element in processing.

                console.log(debug, "Begin loading into db.");

                for (var key in objectArray) {
                    where_at.r_i = key + 1;
                    db_add(
                                objectArray[key].stop_id,
                                objectArray[key].stop_name,
                                objectArray[key].stop_lat,
                                objectArray[key].stop_lon,
                                objectArray[key].stop_code,
                                objectArray[key].location_type,
                                objectArray[key].the_geom
                                );
                    console.log(debug, "(" + key + "/" + objectArray.length + ")LOAD: ", objectArray[key].stop_id);
                }

                where_at.stops_working = false;
                console.log(debug, "STATUS UPDATE: DONE!");
            }
        }
        req.send();
    }

    // FUNCTION 'reload_model()' >>
    // Forces a complete reload on 'stops' lm.
    function reload_model() {
        db_open(); model.clear();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM stops');
            for (var i = 0; i < rs.rows.length; i++) {
                model.append(rs.rows.item(i));
            }
        });
    }

    /********************************************************************************************** PRIVATE FUNCTIONS */

    // FUNCTION 'db_open()' >>>
    // Opens 'stops' db from SQLite.
    function db_open() {
        if (db !== null) {return;}         // Return if db already loaded.

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("AT", "0.1", "Stores Data from AT Transport", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql(
                            'CREATE TABLE IF NOT EXISTS stops(' +
                            'stop_id        TEXT PRIMARY KEY    NOT NULL,' +
                            'stop_name      TEXT                NOT NULL,' +
                            'stop_lat       INT                 NOT NULL,' +
                            'stop_lon       INT                 NOT NULL,' +
                            'stop_code      INT                 NOT NULL,' +
                            'location_type  INT                 NOT NULL,' +
                            'the_geom       TEXT                NOT NULL ' + ')'
                            );
                var table_len  = tx.executeSql("SELECT * FROM stops").rows.length;
                console.log("LOADED: DB 'calendar' with ", table_len, " elements.");
            });
        } catch (err) { console.log("ERROR: creating table in database: " + err); };
    }

    // FUNCTION 'db_add(stop_id, s_name, s_lat, s_lon, s_code, lt, tg)' >>
    // Adds a 'stop' db element.
    // Inputs: [ TEXT x2 ], [ INT x4 ], TEXT.
    function db_add(stop_id, s_name, s_lat, s_lon, s_code, lt, tg) {
        //db_open();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO stops VALUES(?, ?, ?, ?, ?, ?, ?)',
                          [stop_id, s_name, s_lat, s_lon, s_code, lt, tg] );
        });
    }

    // FUNCTION 'db_get(stop_id, key)' >>>
    // Returns value from selected 'stop_id' and 'key'.
    function db_get(stop_id, key) {
        //db_open();
        var res;
        db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT ' + key + ' FROM stops WHERE stop_id=?', [stop_id]);
            if (rs.rows.item(0) === undefined) {return 0;} // TODO: Inform user that their AT DB is outdated.
            res = rs.rows.item(0)[key];
            //console.log("I GOT: ", res, typeof res, " FROM: ", key, route_id);
        });
        return res;
    }

    // FUNCTION 'db_getList()' >>>
    // Returns a list of 'stop_id's stored in 'stops' db.
    function db_getList() {
        //db_open();
        var res = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT stop_id FROM stops');

            for (var i = 0; i < rs.rows.length; i++) {
                res.push(String(rs.rows.item(i).route_id));
            }
        });
        return res;
    }
}

