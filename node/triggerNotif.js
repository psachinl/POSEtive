// var dateTime = require('node-datetime');
var moment = require('moment');

var fs = require('fs');
var fileName = './test.json';
var file = require(fileName);

const five_min = 300000 // 5 mins in ms
var last_notif_time = 0;

// TODO: Integrate notification triggering in inject.js so
// the process does not require another listening script

var id = 'b173a74c-2708-4e73-987d-5357371c5162'

// Infinite loop checking whether notifications need to be
// triggered

// while (true) {
    var classif_dict = file.people;

    // TODO: Move to function
    var index = 0;
    for (var i = 0; i < classif_dict.length; i++) {
        if (classif_dict[i].id == id) {
            index = i;
        }
    }

    classif = classif_dict[index].posture
    console.log(classif);
    // If posture is bad, trigger intervention
    if (classif == "Bad") {
        timestamp = moment().valueOf();
        // If more than 5 mins have passed since the last
        // notification, trigger intervention
        if (timestamp - last_notif_time > five_min) {
            // TODO: Trigger intervention via APNs
            console.log("Triggering notification");
            last_notif_time = timestamp;
        }
    }
// } // End while (true) loop
