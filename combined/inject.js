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
        var apn = require('apn');

        // DO NOT CHANGE
        var options = {
          token: {
            key: "APNsAuthKey_Z4NFFBB53R.p8",
            keyId: "Z4NFFBB53R",
            teamId: "K2URTEF7W2"
          },
          production: false
        };

        var service = new apn.Provider(options);
        let deviceToken = "4e1cfe287fcfef733fc40c6f4e8f7b4231d660de987f7318aab794329b611a94" // Prahnav's iPhone

        let note = new apn.Notification();

        note.expiry = Math.floor(Date.now() / 1000) + 15; // Expires 15 seconds from now.
        // note.expiry = 0; // Expires now.
        note.badge = 3;
        note.sound = "ping.aiff";
        note.alert = "POSEtive has detected slouching - Please sit up";
        note.payload = {'messageFrom': 'POSEtive'}; // TODO: Set notification text
        note.topic = "com.psl.push.test";
        // note.id = "POSEtive.slouching"
        // note.priority = 10;

        service.send(note, deviceToken).then( result => {
            console.log(result); // For testing purposes only
        });

        service.shutdown(); // Doesn't seem to do anything...
}

// var data_point = {"01 Mar 2017, 11:31:52": "Good"};
//
// classif_dict.push(data_point);
// file[id] = classif_dict;
//

// // If bad posture, trigger a push notification via APNs
// if (classif == "Bad") {
//     var apn = require('apn');
//
//     // DO NOT CHANGE
//     var options = {
//       token: {
//         key: "APNsAuthKey_Z4NFFBB53R.p8",
//         keyId: "Z4NFFBB53R",
//         teamId: "K2URTEF7W2"
//       },
//       production: false
//     };
//
//     var service = new apn.Provider(options);
//     let deviceToken = "4e1cfe287fcfef733fc40c6f4e8f7b4231d660de987f7318aab794329b611a94" // Prahnav's iPhone
//
//     let note = new apn.Notification();
//
//     note.expiry = Math.floor(Date.now() / 1000) + 15; // Expires 15 seconds from now.
//     // note.expiry = 0; // Expires now.
//     note.badge = 3;
//     note.sound = "ping.aiff";
//     note.alert = "POSEtive has detected slouching - Please sit up";
//     note.payload = {'messageFrom': 'POSEtive'}; // TODO: Set notification text
//     note.topic = "com.psl.push.test";
//     // note.id = "POSEtive.slouching"
//     // note.priority = 10;
//
//     service.send(note, deviceToken).then( result => {
//         console.log(result); // For testing purposes only
//     });
//
//     service.shutdown(); // Doesn't seem to do anything...
}
