var fs = require('fs'); // file system module

var inputFile = process.argv[2]

fs.readFile(inputFile, 'utf-8', function(err, data) {
    if (err) throw err;

    var lines = data.trim().split('\n');
    var lastLine = lines.slice(-1)[0]; // Read last row
    var fields = lastLine.split(',');
    var classif = fields.slice(-1)[0]; // Read last column
    // var classif = fields[2]; // Read third column
    // Last column is the posture classification

    console.log(classif); // DO NOT REMOVE
});
