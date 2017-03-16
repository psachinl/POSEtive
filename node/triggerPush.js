var apn = require('apn');

var options = {
  token: {
    key: "APNsAuthKey_Z4NFFBB53R.p8",
    keyId: "Z4NFFBB53R",
    teamId: "K2URTEF7W2"
  },
  production: false // false
};

var service = new apn.Provider(options);
let deviceToken = "4e1cfe287fcfef733fc40c6f4e8f7b4231d660de987f7318aab794329b611a94" //4

let note = new apn.Notification();

note.expiry = Math.floor(Date.now() / 1000) + 5; // Expires 1 minute from now.
// note.expiry = 0; // Expires now.
note.badge = 3;
note.sound = "ping.aiff";
note.alert = "POSEtive has detected slouching - Please sit up Prahnav";
note.payload = {'messageFrom': 'POSEtive'};
note.topic = "com.psl.push.test";
// note.id = "POSEtive.slouching"
// note.priority = 10;

service.send(note, deviceToken).then( result => {
    // console.log("sent:", result.sent.length);
    // console.log("failed:", result.failed.length);
    // console.log(result.failed);
    console.log(result);
    // service.shutdown();
});

service.shutdown();
