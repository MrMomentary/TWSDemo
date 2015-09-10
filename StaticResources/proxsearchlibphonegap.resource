$ = function(id){ return document.getElementById(id); };
 
var Device = { 
available: false,
    /* Invoked by PhoneGap */
init: function() {
    if(Device.onGapInit) {
        try {
            Device.onGapInit(); 
        } catch (e) {
            alert("onGapInit err: " + e);
        }
    }
},
   
exec: function(command) {
    if (Device.available) {
        try {
            document.location = "phonegap://" + command;
        } catch(e) {
            console.log("Command '" + command + "' has not been executed, because of exception: " + e);
            alert("Error executing command '" + command + "'.")
        }
    }
},
   
Location: {
lon: null,
lat: null,
callback: null,
   
init: function() {
    Device.exec("/getloc");
},
   
set: function(lat, lon) {
    Device.Location.lat = lat;
    Device.Location.lon = lon;
    if(Device.Location.callback != null) {
        Device.Location.callback(lat, lon)
        Device.Location.callback = null;
    }
},
   
wait: function(func) {
    Device.Location.callback = func
    Device.exec("/getloc");
}  
}
}
 
/*********************************************
 * The methods below are invoked by PhoneGap *
 *********************************************/
 
/* Location callback */
function gotLocation(lat, lon) {
    return Device.Location.set(lat, lon)
} 