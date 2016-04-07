import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "at_backend.js" as AT

Item { id: u1db_item;

    property var db: null;
    property ListModel model: ListModel {}

    property string debug: "DB ROUTES: ";

    /*********************************************************************************************** PUBLIC FUNCTIONS */

    // FUNCTION 'rq_names(route_id) >>>
    // Finds 'route_short_name' & 'route_long_name' from specified 'route_id'.
    // Returns empty strings if failed.
    function rq_names(route_id) {
        db_open();
        var out_array = ["", ""];
        out_array[0] = db_get(route_id, "route_short_name");
        out_array[1] = db_get(route_id, "route_long_name");
        console.log(debug, "rq_names(route_id) returning: ", out_array[0], out_array[1]);
        return out_array;
    }

    // FUNCTION 'force_download_all()' >>
    // Forces a complete update on 'routes' db.
    function force_download_all() {
        db_open();
        console.log(debug, "Download Start.");
        var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/routes?api_key=" + at_api_key);
        req.onreadystatechange = function() {

            if (req.readyState === XMLHttpRequest.DONE) {
                console.log(debug, "Download Complete.");
                console.log(debug, "Finding latest version...");

                var objectArray = JSON.parse(req.responseText).response;

                // Get latest route_id version >>>
                // Loop through and split "50051017900-20160316100058_v39.6" to "20160316100058".
                // Find largest number.
                var _latest = 0;
                var ti_int = []; // From "route_id", grab dates in number form.

                for (var key in objectArray) {
                    var ti_str = objectArray[key].route_id;
                    ti_int.push( Number(ti_str.slice(ti_str.indexOf('-')+1, ti_str.indexOf('_'))) );
                    if (ti_int[key] > _latest) {_latest = ti_int[key];}
                }

                console.log(debug, "OK! Latest Version is ", _latest);
                console.log(debug, "Begin loading into db.");

                for (key in objectArray) {
                    console.log(debug, "Comparing", ti_int[key], "with", _latest);
                    if (ti_int[key] === _latest) {

                        db_add(
                                    objectArray[key].route_id,
                                    objectArray[key].agency_id,
                                    objectArray[key].route_short_name,
                                    objectArray[key].route_long_name,
                                    objectArray[key].route_desc,
                                    objectArray[key].route_type,
                                    objectArray[key].route_url,
                                    objectArray[key].route_color,
                                    objectArray[key].route_text_color
                                    );
                        console.log(debug, "(" + key + "/" + objectArray.length + ")LOAD: ", objectArray[key].route_id);
                    } else {
                        console.log(debug, "(" + key + "/" + objectArray.length + ")SKIP: ", "Routes Element Outdated.");
                    }
                }
            }
        }
        req.send();
    }

    // FUNCTION 'reload_model()' >>
    // Forces a complete reload on 'routes' lm.
    function reload_model() {
        db_open(); model.clear();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM routes');
            for (var i = 0; i < rs.rows.length; i++) {
                model.append(rs.rows.item(i));
            }
        });
    }

    /********************************************************************************************** PRIVATE FUNCTIONS */

    // FUNCTION 'db_open()' >>>
    // Opens 'routes' db from SQLite.
    function db_open() {
        if (db !== null) {return;}         // Return if db already loaded.

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("AT", "0.1", "Stores Data from AT Transport", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql(
                            'CREATE TABLE IF NOT EXISTS routes(' +
                            'route_id         TEXT PRIMARY KEY    NOT NULL,' +
                            'agency_id        TEXT                NOT NULL,' +
                            'route_short_name TEXT                NOT NULL,' +
                            'route_long_name  TEXT                NOT NULL,' +
                            'route_desc       TEXT                        ,' + /* CAN BE NULL */
                            'route_type       INT                 NOT NULL,' +
                            'route_url        TEXT                        ,' + /* CAN BE NULL */
                            'route_color      TEXT                        ,' + /* CAN BE NULL */
                            'route_text_color TEXT                         ' + /* CAN BE NULL */ ')'
                            );
                var table_len  = tx.executeSql("SELECT * FROM routes").rows.length;
                console.log("LOADED: DB 'routes' with ", table_len, " elements.");
            });
        } catch (err) { console.log("ERROR: creating table in database: " + err); };
    }

    // FUNCTION 'db_add(route_id, a_id, r_sn, r_ln, r_d, r_t, r_u, r_c, r_tc)' >>
    // Adds a 'routes' db element.
    // Inputs: TEXT, [ TEXT x4 ], INT, [ TEXT x3 ].
    function db_add(route_id, a_id, r_sn, r_ln, r_d, r_t, r_u, r_c, r_tc) {
        //db_open();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO routes VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                          [route_id, a_id, r_sn, r_ln, r_d, r_t, r_u, r_c, r_tc] );
        });

    }

    // FUNCTION 'db_get(route_id, key)' >>>
    // Returns value from selected 'route_id' and 'key'.
    function db_get(route_id, key) {
        //db_open();
        var res = "";
        db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT ' + key + ' FROM routes WHERE route_id=?', [route_id]);
            if (rs.rows.item(0) === undefined) {return 0;} // TODO: Inform user that their AT DB is outdated.
            res = rs.rows.item(0)[key];
            //console.log("I GOT: ", res, typeof res, " FROM: ", key, route_id);
        });
        return res;
    }

    // FUNCTION 'db_getList()' >>>
    // Returns a list of 'route_id's stored in 'routes' db.
    function db_getList() {
        //db_open();
        var res = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT route_id FROM routes');

            for (var i = 0; i < rs.rows.length; i++) {
                res.push(String(rs.rows.item(i).route_id));
            }
        });
        return res;
    }
}
