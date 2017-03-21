# POSEtive: Posture Correction System

Mobile Healthcare & Machine Learning 2017

Coursework

Sachin, Prahnav, Adi, Waris and Adam

Imperial College London

Professor Yiannis Demiris

----------


About
-------------------

POSEtive is a wearable posture sensor which is designed to be used with a smart device, such as phone or watch, and a downloadable app. The system pushes a reminder notification to the user whenever a slouching threshold is crossed for a certain amount of time. This system is implemented via a trained Support Vector Machine (SVM) which classifies user posture according to pitch (forwards/backwards slouching) and yaw (leaning left or right).

Another effective machine learning method is a neural network, which was trained to respond to raw data inputs straight from the TI Sensortag. While both methods had >80% accuracy, the SVM proved to be more reliable and is hence used in "classification.sh".

Instructions
-------------------
1. `cd combined`
2. `json-server --watch test.json` to start the web server on localhost:3000
3. `./csv2json.sh` script to update JSON when required
4. `./classification.sh` launches MATLAB processing
5. **Optional** `ngrok http 3000` provides a public URL for the web server

Useful Links
-------------------

Researcher in EEE Circuits & Systems group
http://anasimtiaz.com/?p=201

github link code sent by Caterina (GTA)
https://github.com/IanHarvey/bluepy

Algorithms used in the SensorTag app to get the orientation vector
http://x-io.co.uk/open-source-imu-and-ahrs-algorithms/
http://x-io.co.uk/open-source-ahrs-with-x-imu/

TI SensorTag 2 forum post
https://e2e.ti.com/support/wireless_connectivity/bluetooth_low_energy/f/538/t/426000

Might be worth checking out
https://github.com/hermitstars/SensortagExample
https://github.com/jpmens/SensorTag_iOS
https://github.com/viccarre/Sensor-Tag-iOS < Looks promising
https://github.com/tetujin/SensortagBleReceiver < Objective C
