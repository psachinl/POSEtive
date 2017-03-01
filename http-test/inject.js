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

// TODO: Maybe add if statement to only update JSON if new
// classification is different - might save some IO time
classif_dict[index].posture = classif;
file.people = classif_dict;

// var data_point = {"01 Mar 2017, 11:31:52": "Good"};
//
// classif_dict.push(data_point);
// file[id] = classif_dict;
//
fs.writeFile(fileName, JSON.stringify(file, null, 2), function (err) {
  if (err) return console.log(err);
  // console.log(JSON.stringify(file));
  // console.log('writing to ' + fileName);
});
