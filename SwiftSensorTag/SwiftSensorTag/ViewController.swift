//
//  ViewController.swift
//  SwiftSensorTag
//
//  Created by Anas Imtiaz on 13/11/2015.
//  Copyright © 2015 Anas Imtiaz. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Title labels
    var titleLabel : UILabel!
    var statusLabel : UILabel!
    
    // BLE
    var centralManager : CBCentralManager!
    var sensorTagPeripheral : CBPeripheral!
    
    // Table View
    var sensorTagTableView : UITableView!
    
    // Sensor Values
    var allSensorLabels : [String] = []
    var allSensorValues : [Double] = []
    var accelerometerX : Double!
    var accelerometerY : Double!
    var accelerometerZ : Double!
    var magnetometerX : Double!
    var magnetometerY : Double!
    var magnetometerZ : Double!
    var gyroscopeX : Double!
    var gyroscopeY : Double!
    var gyroscopeZ : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize central manager on load
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Set up title label
        titleLabel = UILabel()
        titleLabel.text = "SensorTag 2 data"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.view.frame.midX, y: self.titleLabel.bounds.midY+28)
        self.view.addSubview(titleLabel)
        
        // Set up status label
        statusLabel = UILabel()
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.text = "Loading..."
        statusLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        statusLabel.sizeToFit()
        //statusLabel.center = CGPoint(x: self.view.frame.midX, y: (titleLabel.frame.maxY + statusLabel.bounds.height/2) )
        statusLabel.frame = CGRect(x: self.view.frame.origin.x, y: self.titleLabel.frame.maxY, width: self.view.frame.width, height: self.statusLabel.bounds.height)
        self.view.addSubview(statusLabel)
        
        // Set up table view
        setupSensorTagTableView()
        
        // Initialize all sensor values and labels
        allSensorLabels = SensorTag.getSensorLabels()
        for i in 0...allSensorLabels.count-1 {
            allSensorValues.append(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /******* CBCentralManagerDelegate *******/
     
     // Check status of BLE hardware
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if central.state == .poweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripherals(withServices: nil, options: nil)
            self.statusLabel.text = "Searching for BLE Devices"
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            showAlertWithText("Error", message: "Bluetooth switched off or not initialized")
        }
    }
    
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if SensorTag.sensorTagFound(advertisementData) == true {
        
            // Update Status Label
            self.statusLabel.text = "SensorTag 2 Found"
            
            // Stop scanning, set as the peripheral to use and establish connection
            self.centralManager.stopScan()
            self.sensorTagPeripheral = peripheral
            self.sensorTagPeripheral.delegate = self
            self.centralManager.connect(peripheral, options: nil)
        }
        else {
            self.statusLabel.text = "SensorTag 2 NOT Found"
            //showAlertWithText(header: "Warning", message: "SensorTag Not Found")
        }
    }
    
    // Discover services of the peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.statusLabel.text = "Discovering peripheral services"
        peripheral.delegate=self
        peripheral.discoverServices(nil)
    }
    
    
    // If disconnected, start searching again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.statusLabel.text = "Disconnected"
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    /******* CBCentralPeripheralDelegate *******/
     
     // Check if the service discovered is valid i.e. one of the following:
     // Movement service
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.statusLabel.text = "Looking at peripheral services"
        for service in peripheral.services! {
            let thisService = service as CBService
            if SensorTag.validService(thisService) {
                // Discover characteristics of all valid services
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    
    
    // Enable notification and sensor for each characteristic of valid service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        self.statusLabel.text = "Enabling sensors"
        
        let input = 127
        var enableValue = input
        
        let enablyBytes = withUnsafePointer(to: &enableValue){
            return Data(bytes: $0, count: MemoryLayout<UInt16>.size)
        }
        
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            if SensorTag.validDataCharacteristic(thisCharacteristic) {
                // Enable Sensor Notification
                self.sensorTagPeripheral.setNotifyValue(true, for: thisCharacteristic)
            }
            if SensorTag.validConfigCharacteristic(thisCharacteristic) {
                // Enable Sensor
                self.sensorTagPeripheral.writeValue(enablyBytes, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
        
    }
    
    
    
    // Get data values when they are updated
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        self.statusLabel.text = "Connected"
        
        if characteristic.uuid == MovementDataUUID {
            let allValues = SensorTag.getMovementData(characteristic.value!)
            
            self.gyroscopeX = allValues[0]
            self.gyroscopeY = allValues[1]
            self.gyroscopeZ = allValues[2]
            
            self.accelerometerX = allValues[3]
            self.accelerometerY = allValues[4]
            self.accelerometerZ = allValues[5]
            
            self.magnetometerX = allValues[6]
            self.magnetometerY = allValues[7]
            self.magnetometerZ = allValues[8]
            
            self.allSensorValues[0] = self.accelerometerX
            self.allSensorValues[1] = self.accelerometerY
            self.allSensorValues[2] = self.accelerometerZ
            self.allSensorValues[3] = self.magnetometerX
            self.allSensorValues[4] = self.magnetometerY
            self.allSensorValues[5] = self.magnetometerZ
            self.allSensorValues[6] = self.gyroscopeX
            self.allSensorValues[7] = self.gyroscopeY
            self.allSensorValues[8] = self.gyroscopeZ
        }
        
        self.sensorTagTableView.reloadData()
    }
    
    
    
    /******* UITableViewDataSource *******/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSensorLabels.count
    }
    
    
    /******* UITableViewDelegate *******/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let thisCell = tableView.dequeueReusableCell(withIdentifier: "sensorTagCell") as! SensorTagTableViewCell
        thisCell.sensorNameLabel.text  = allSensorLabels[indexPath.row]
        
        let valueString = NSString(format: "%.2f", allSensorValues[indexPath.row])
        thisCell.sensorValueLabel.text = valueString as String
        
        return thisCell
    }
    
    
    
    
    /******* Helper *******/
     
     // Show alert
    func showAlertWithText (_ header : String = "Warning", message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.view.tintColor = UIColor.red
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Set up Table View
    func setupSensorTagTableView () {
        
        self.sensorTagTableView = UITableView()
        self.sensorTagTableView.delegate = self
        self.sensorTagTableView.dataSource = self
        
        
        self.sensorTagTableView.frame = CGRect(x: self.view.bounds.origin.x, y: self.statusLabel.frame.maxY+20, width: self.view.bounds.width, height: self.view.bounds.height)
        
        self.sensorTagTableView.register(SensorTagTableViewCell.self, forCellReuseIdentifier: "sensorTagCell")
        
        self.sensorTagTableView.tableFooterView = UIView() // to hide empty lines after cells
        self.view.addSubview(self.sensorTagTableView)
    }
}

