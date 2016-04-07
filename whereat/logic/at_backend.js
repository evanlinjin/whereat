.pragma library

var at_api_key = "7f8015e0-7f59-46a4-86ff-d4f6c6f4b297";
var day_array = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];

// FUNCTION: "uniq(a)" >>>
// Makes an array unique.
function uniq(a) {
    return a.sort().filter(function(item, pos, ary) {
        return !pos || item != ary[pos - 1];
    })
}

// FUNCTION: "has_expired(iso_date_str)" >>>
// Returns true if current date is past specified date.
// Also returns true if specified date is invalid.
function has_expired(iso_date_str) {
    //console.log("Checking Expiry...");
    return (new Date() > new Date(iso_date_str));
}

// FUNCTION: "get_day_str()" >>>
// Returns the current week day as a lowercase string.
function get_day_str() {
    return day_array[new Date().getDay()];
}

// FUNCTION: "now_in_s()" >>>
// Returns current time in seconds from midnight.
function now_in_s() {
    var d = new Date();
    return (d.getTime() - d.setHours(0,0,0,0)) / 1000 | 0;
}
