# POSEtive: Posture Correction System

**Mobile Healthcare & Machine Learning 2017**

Sachin Leelasena, Prahnav Sharma, Adi Krpo, Waris Ameen and Adam Halliwell

Imperial College London

Professor Yiannis Demiris

----------


About
-------------------

POSEtive is a wearable posture sensor which is designed to be used with a smart device, such as phone or watch, and a downloadable app. The system pushes a reminder notification to the user whenever a slouching threshold is crossed for a certain amount of time. This system is implemented via a trained Support Vector Machine (SVM) which classifies user posture according to pitch (forwards/backwards slouching) and yaw (leaning left or right).

Another effective machine learning method is a neural network, which was trained to respond to raw data inputs straight from the TI Sensortag. While both methods had >80% accuracy, the SVM proved to be more reliable and is hence used as the primary posture detection system.

Overview
-------------------

The combined directory includes the final code for the POSEtive posture detection system and intervention model.

Currently data is streamed from the TI SensorTag 2 to a laptop via Bluetooth. This data is then processed in MATLAB using a SVM to classify posture. The output of the SVM is then written to `outData.txt`.

This output file is monitored by `csv2json.sh` for changes in classification. If a change is detected, `insert2json.sh` is called which reads the new classification and calls `inject.js` to write the new classification to the JSON database (`test.json`).  

If the classification is 'Bad', push notifications via the Apple Push Notification service (APNs) are triggered from `inject.js` if no notifications have been sent in the blocking period. The length of this blocking period is defined in milliseconds as the variable `notif_delay`.

Running POSEtive
-------------------

Note: The POSEtive back-end has only been tested on macOS systems but should work on Linux.

**Prerequisites**
 - Node.js
 - MATLAB (R2016b recommended) with [bash script](http://stackoverflow.com/questions/33187141/how-to-call-matlab-script-from-command-line) to launch MATLAB from the command line:
 - MATLAB machine learning library
 - iOS device (*does not work with the Xcode Simulator*) running the POSEtive app. The Xcode project files for the app can be found in the POSEtive directory
 - iOS device token ID

1. After cloning repo, `cd combined` from repo root
3. `./csv2json.sh` script updates JSON for the inverse intervention model
4. `./svm.sh` launches posture detection via SVM
2. **Optional:**`json-server --watch test.json` to start the web server on localhost:3000. This is currently not used but was designed to allow the intervention model to be extended with minimal modification (*requires the Node.js package `json-server`*)
5. **Optional:** `ngrok http 3000` provides a public URL for the web server (*requires `ngrok` to be installed*)

Related Works
-------------------

bluepy
https://github.com/IanHarvey/bluepy

Algorithms used in the SensorTag app to get the orientation vector
http://x-io.co.uk/open-source-imu-and-ahrs-algorithms/
http://x-io.co.uk/open-source-ahrs-with-x-imu/

TI SensorTag 2 forum post
https://e2e.ti.com/support/wireless_connectivity/bluetooth_low_energy/f/538/t/426000

Related SensorTag projects
https://github.com/hermitstars/SensortagExample
https://github.com/jpmens/SensorTag_iOS
https://github.com/viccarre/Sensor-Tag-iOS
https://github.com/tetujin/SensortagBleReceiver
