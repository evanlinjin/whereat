import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "at_backend.js" as AT

Item { id: u1db_item;

    property var db: null;
    property ListModel model: ListModel {}

    /*********************************************************************************************** PUBLIC FUNCTIONS */

    // FUNCTION 'rq_day(service_id, day)' >>
    // See if specified service operates on specified day.
    // Returns true if operates. False if not operating.
    function rq_day(service_id, day) {
        db_open();
        if ( AT.has_expired(db_get(service_id, "end_date")) ) {
            //console.log("WARNING: 'calendar' has expired at ", db_get(service_id, "end_date"));
            return false;
        }
        return db_get(service_id, String(day));
    }

    // FUNCTION 'force_download_all()' >>
    // Forces a complete update on 'calendar' db.
    function force_download_all() {
        db_open();
        console.log("STATUS UPDATE: [DOWNLOAD BEGIN]");
        var req = new XMLHttpRequest;
        req.open("GET", "https://api.at.govt.nz/v1/gtfs/calendar?api_key=" + at_api_key);
        req.onreadystatechange = function() {

            if (req.readyState === XMLHttpRequest.DONE) {
                console.log("STATUS UPDATE: [DOWNLOAD COMPLETE]");
                console.log("STATUS UPDATE: Finding latest version...");

                var objectArray = JSON.parse(req.responseText).response;

                // Get latest service_id version >>>
                // Loop through and split "50051017900-20160316100058_v39.6" to "20160316100058".
                // Find largest number.
                var _latest = 0;
                var ti_int = []; // From "service_id", grab dates in number form.

                for (var key in objectArray) {
                    var ti_str = objectArray[key].service_id;
                    ti_int.push( Number(ti_str.slice(ti_str.indexOf('-')+1, ti_str.indexOf('_'))) );
                    if (ti_int[key] > _latest) {_latest = ti_int[key];}
                }

                console.log("STATUS UPDATE: OK! Latest version: ", _latest);
                console.log("STATUS UPDATE: Begin Loading into database...");

                for (key in objectArray) {
                    console.log("COMPARING: ", ti_int[key], " WITH ", _latest);
                    if (ti_int[key] === _latest) {

                        db_add(
                                    objectArray[key].service_id,
                                    objectArray[key].monday,
                                    objectArray[key].tuesday,
                                    objectArray[key].wednesday,
                                    objectArray[key].thursday,
                                    objectArray[key].friday,
                                    objectArray[key].saturday,
                                    objectArray[key].sunday,
                                    objectArray[key].start_date,
                                    objectArray[key].end_date
                                    );
                        console.log("(" + key + "/" + objectArray.length + ")LOAD: ", objectArray[key].service_id);
                    } else {
                        console.log("(" + key + "/" + objectArray.length + ")SKIP: ", "Calendar Element Outdated.");
                    }
                }
                console.log("STATUS UPDATE: DONE!");
            }
        }
        req.send();
    }

    // FUNCTION 'reload_model()' >>
    // Forces a complete reload on 'calendar' lm.
    function reload_model() {
        db_open(); model.clear();
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM calendar');
            for (var i = 0; i < rs.rows.length; i++) {
                model.append(rs.rows.item(i));
            }
        });
    }

    /********************************************************************************************** PRIVATE FUNCTIONS */

    // FUNCTION 'db_open()' >>>
    // Opens 'calendar' db from SQLite.
    function db_open() {
        if (db !== null) {return;}         // Return if db already loaded.

        // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
        db = LocalStorage.openDatabaseSync("AT", "0.1", "Stores Data from AT Transport", 100000);

        try {
            db.transaction(function(tx){
                tx.executeSql(
                            'CREATE TABLE IF NOT EXISTS calendar(' +
                            'service_id  TEXT PRIMARY KEY    NOT NULL,' +
                            'monday      INT                 NOT NULL,' +
                            'tuesday     INT                 NOT NULL,' +
                            'wednesday   INT                 NOT NULL,' +
                            'thursday    INT                 NOT NULL,' +
                            'friday      INT                 NOT NULL,' +
                            'saturday    INT                 NOT NULL,' +
                            'sunday      INT                 NOT NULL,' +
                            'start_date  TEXT                NOT NULL,' +
                            'end_date    TEXT                NOT_NULL'  + ')'
                            );
                var table_len  = tx.executeSql("SELECT * FROM calendar").rows.length;
                console.log("LOADED: DB 'calendar' with ", table_len, " elements.");
            });
        } catch (err) { console.log("ERROR: creating table in database: " + err); };
    }

    // FUNCTION 'db_add(service_id, d1, d2, d3, d4, d5, d6, d7, start_date, end_date)' >>
    // Adds a 'calendar' db element.
    // Inputs: TEXT, [ INT x7 ], TEXT, TEXT.
    function db_add(service_id, d1, d2, d3, d4, d5, d6, d7, start_date, end_date) {
        //db_open();
        db.transaction( function(tx){
            tx.executeSql('INSERT OR REPLACE INTO calendar VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                          [service_id, d1, d2, d3, d4, d5, d6, d7, start_date, end_date] );
        });

    }

    // FUNCTION 'db_get(service_id, key)' >>>
    // Returns value from selected 'service_id' and 'key'.
    function db_get(service_id, key) {
        //db_open();
        var res = "";
        db.transaction( function(tx) {
            var rs = tx.executeSql('SELECT ' + key + ' FROM calendar WHERE service_id=?', [service_id]);
            if (rs.rows.item(0) === undefined) {return 0;} // TODO: Inform user that their AT DB is outdated.
            res = rs.rows.item(0)[key];
            //console.log("I GOT: ", res, typeof res, " FROM: ", key, service_id);
        });
        return res;
    }

    // FUNCTION 'db_getList()' >>>
    // Returns a list of 'service_id's stored in 'calendar' db.
    function db_getList() {
        //db_open();
        var res = [];
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT service_id FROM calendar');

            for (var i = 0; i < rs.rows.length; i++) {
                res.push(String(rs.rows.item(i).service_id));
            }
        });
        return res;
    }
}


//                if (table.rows.length == 0) {
//                    tx.executeSql('INSERT INTO calendar VALUES(?, ?)', ["distro", "Ubuntu"]);
//                    tx.executeSql('INSERT INTO calendar VALUES(?, ?)', ["foo", "Bar"]);
//                    console.log('Calendar table added');
//                };
