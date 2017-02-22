var fs = require('fs');
var fileName = './test.json';
var file = require(fileName);

file.people[0].posture = "Bad";

fs.writeFile(fileName, JSON.stringify(file, null, 2), function (err) {
  if (err) return console.log(err);
  console.log(JSON.stringify(file));
  console.log('writing to ' + fileName);
});
