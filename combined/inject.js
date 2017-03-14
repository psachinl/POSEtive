var fs = require('fs');
var fileName = './test.json';
var file = require(fileName);

// TODO: Pass id, date and classification as parameters
var id = 'b173a74c-2708-4e73-987d-5357371c5162'
var classif = process.argv[2]; // First arg is [2] in array

classif_dict = file.people;
// console.log(classif_dict);

// TODO: Move to function
var index = 0;
for (var i = 0; i < classif_dict.length; i++) {
    if (classif_dict[i].id == id) {
        index = i;
    }
}

// console.log(classif_dict[index].posture);

// Only writes if new classification is different to current classification
if (classif_dict[index].posture != classif) {
    classif_dict[index].posture = classif;
    file.people = classif_dict;

    fs.writeFile(fileName, JSON.stringify(file, null, 2), function (err) {
      if (err) return console.log(err);
      // console.log(JSON.stringify(file));
      // console.log('writing to ' + fileName);
    });

    // If bad posture, trigger a push notification via APNs
    if (classif == "Bad") {
        var moment = require('moment');

        notif_delay = 10000; // 10 seconds in ms

        if (moment().valueOf() - classif_dict[index].last_notif_time > notif_delay) {
            var apn = require('apn');

            classif_dict[index].last_notif_time = moment().valueOf();
            file.people = classif_dict;

            fs.writeFile(fileName, JSON.stringify(file, null, 2), function (err) {
              if (err) return console.log(err);
              // console.log(JSON.stringify(file));
              // console.log('writing to ' + fileName);
            });

            // console.log(classif_dict);

            // DO NOT CHANGE
            var options = {
              token: {
                // key: "APNsAuthKey_Z4NFFBB53R.p8",
                // keyId: "Z4NFFBB53R",
                key: "APNsAuthKey_D4MGUB267P.p8",
                keyId: "D4MGUB267P",
                teamId: "K2URTEF7W2"
              },
              production: false
            };

            var service = new apn.Provider(options);
            let deviceToken = "c9ee853bed12899b0bbe267eb44f1f5a27c3a7740a4c15386851ffba47d955bd" // Prahnav's iPhone

            let note = new apn.Notification();

            note.expiry = Math.floor(Date.now() / 1000) + 15; // Expires 15 seconds from now.
            note.sound = "ping.aiff";
            note.title = "POSEtive has detected slouching";
            note.body = "Please sit up";
            note.topic = "com.POSEtive.POSEtive"; // App bundle identifier

            service.send(note, deviceToken).then( result => {
                console.log(result); // For testing purposes only
                process.exit()
            });

            service.shutdown(); // Doesn't seem to do anything...
        }
    }
}
