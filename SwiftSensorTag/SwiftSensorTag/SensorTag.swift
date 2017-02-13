//
//  SensorTag.swift
//  SwiftSensorTag
//
//  Created by Anas Imtiaz on 13/11/2015.
//  Copyright © 2015 Anas Imtiaz. All rights reserved.
//

import Foundation
import CoreBluetooth


let deviceName = "CC2650 SensorTag"

//// Service UUIDs
//let IRTemperatureServiceUUID = CBUUID(string: "F000AA00-0451-4000-B000-000000000000")
//let AccelerometerServiceUUID = CBUUID(string: "F000AA80-0451-4000-B000-000000000000")
//let HumidityServiceUUID      = CBUUID(string: "F000AA20-0451-4000-B000-000000000000")
//let MagnetometerServiceUUID  = CBUUID(string: "F000AA30-0451-4000-B000-000000000000")
//let BarometerServiceUUID     = CBUUID(string: "F000AA40-0451-4000-B000-000000000000")
//let GyroscopeServiceUUID     = CBUUID(string: "F000AA50-0451-4000-B000-000000000000")
//
//// Characteristic UUIDs
//let IRTemperatureDataUUID   = CBUUID(string: "F000AA01-0451-4000-B000-000000000000")
//let IRTemperatureConfigUUID = CBUUID(string: "F000AA02-0451-4000-B000-000000000000")
//let AccelerometerDataUUID   = CBUUID(string: "F000AA81-0451-4000-B000-000000000000")
//let AccelerometerConfigUUID = CBUUID(string: "F000AA82-0451-4000-B000-000000000000")
//let HumidityDataUUID        = CBUUID(string: "F000AA21-0451-4000-B000-000000000000")
//let HumidityConfigUUID      = CBUUID(string: "F000AA22-0451-4000-B000-000000000000")
//let MagnetometerDataUUID    = CBUUID(string: "F000AA31-0451-4000-B000-000000000000")
//let MagnetometerConfigUUID  = CBUUID(string: "F000AA32-0451-4000-B000-000000000000")
//let BarometerDataUUID       = CBUUID(string: "F000AA41-0451-4000-B000-000000000000")
//let BarometerConfigUUID     = CBUUID(string: "F000AA42-0451-4000-B000-000000000000")
//let GyroscopeDataUUID       = CBUUID(string: "F000AA51-0451-4000-B000-000000000000")
//let GyroscopeConfigUUID     = CBUUID(string: "F000AA52-0451-4000-B000-000000000000")

// Service UUIDs

let IRTemperatureServiceUUID = CBUUID(string: "F000AA00-0451-4000-B000-000000000000")
let MovementServiceUUID      = CBUUID(string: "F000AA80-0451-4000-B000-000000000000")
let HumidityServiceUUID      = CBUUID(string: "F000AA20-0451-4000-B000-000000000000")
let BarometerServiceUUID     = CBUUID(string: "F000AA40-0451-4000-B000-000000000000")

// Characteristic UUIDs

let IRTemperatureDataUUID   = CBUUID(string: "F000AA01-0451-4000-B000-000000000000")
let IRTemperatureConfigUUID = CBUUID(string: "F000AA02-0451-4000-B000-000000000000")
let MovementDataUUID        = CBUUID(string: "F000AA81-0451-4000-B000-000000000000")
let MovementConfigUUID      = CBUUID(string: "F000AA82-0451-4000-B000-000000000000")
let HumidityDataUUID        = CBUUID(string: "F000AA21-0451-4000-B000-000000000000")
let HumidityConfigUUID      = CBUUID(string: "F000AA22-0451-4000-B000-000000000000")
let BarometerDataUUID       = CBUUID(string: "F000AA41-0451-4000-B000-000000000000")
let BarometerConfigUUID     = CBUUID(string: "F000AA42-0451-4000-B000-000000000000")



class SensorTag {
    
    // Check name of device from advertisement data
    class func sensorTagFound (_ advertisementData: [AnyHashable: Any]!) -> Bool {
        let nameOfDeviceFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? String
        return (nameOfDeviceFound == deviceName)
    }
    
    
    // Check if the service has a valid UUID
    class func validService (_ service : CBService) -> Bool {
        if service.uuid == IRTemperatureServiceUUID || service.uuid == MovementServiceUUID ||
            service.uuid == HumidityServiceUUID || service.uuid == MovementServiceUUID ||
            service.uuid == BarometerServiceUUID || service.uuid == MovementServiceUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Check if the characteristic has a valid data UUID
    class func validDataCharacteristic (_ characteristic : CBCharacteristic) -> Bool {
        if characteristic.uuid == IRTemperatureDataUUID || characteristic.uuid == MovementDataUUID ||
            characteristic.uuid == HumidityDataUUID || characteristic.uuid == MovementDataUUID ||
            characteristic.uuid == BarometerDataUUID || characteristic.uuid == MovementDataUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Check if the characteristic has a valid config UUID
    class func validConfigCharacteristic (_ characteristic : CBCharacteristic) -> Bool {
        if characteristic.uuid == IRTemperatureConfigUUID || characteristic.uuid == MovementConfigUUID ||
            characteristic.uuid == HumidityConfigUUID || characteristic.uuid == MovementConfigUUID ||
            characteristic.uuid == BarometerConfigUUID || characteristic.uuid == MovementConfigUUID {
                return true
        }
        else {
            return false
        }
    }
    
    
    // Get labels of all sensors
    class func getSensorLabels () -> [String] {
        let sensorLabels : [String] = [
            "Ambient temperature",
            "Object Temperature",
            "Accelerometer X",
            "Accelerometer Y",
            "Accelerometer Z",
            "Relative Humidity",
            "Magnetometer X",
            "Magnetometer Y",
            "Magnetometer Z",
            "Gyroscope X",
            "Gyroscope Y",
            "Gyroscope Z"
        ]
        return sensorLabels
    }
    
    
    
    // Process the values from sensor
    
    
    // Convert NSData to array of bytes
    class func dataToSignedBytes16(_ value : Data) -> [Int16] {
        let count = value.count
        var array = [Int16](repeating: 0, count: count)
        (value as NSData).getBytes(&array, length:count * MemoryLayout<Int16>.size)
        return array
    }
    
    class func dataToUnsignedBytes16(_ value : Data) -> [UInt16] {
        let count = value.count
        var array = [UInt16](repeating: 0, count: count)
        (value as NSData).getBytes(&array, length:count * MemoryLayout<UInt16>.size)
        return array
    }
    
    class func dataToSignedBytes8(_ value : Data) -> [Int8] {
        let count = value.count
        var array = [Int8](repeating: 0, count: count)
        (value as NSData).getBytes(&array, length:count * MemoryLayout<Int8>.size)
        return array
    }
    
    // Get ambient temperature value
    class func getAmbientTemperature(_ value : Data) -> Double {
        let dataFromSensor = dataToSignedBytes16(value)
        let ambientTemperature = Double(dataFromSensor[1])/128
        return ambientTemperature
    }
    
    // Get object temperature value
    class func getObjectTemperature(_ value : Data, ambientTemperature : Double) -> Double {
        let dataFromSensor = dataToSignedBytes16(value)
        let Vobj2 = Double(dataFromSensor[0]) * 0.00000015625
        
        let Tdie2 = ambientTemperature + 273.15
        let Tref  = 298.15
        
        let S0 = 6.4e-14
        let a1 = 1.75E-3
        let a2 = -1.678E-5
        let b0 = -2.94E-5
        let b1 = -5.7E-7
        let b2 = 4.63E-9
        let c2 = 13.4
        
        let S = S0*(1+a1*(Tdie2 - Tref)+a2*pow((Tdie2 - Tref),2))
        let Vos = b0 + b1*(Tdie2 - Tref) + b2*pow((Tdie2 - Tref),2)
        let fObj = (Vobj2 - Vos) + c2*pow((Vobj2 - Vos),2)
        let tObj = pow(pow(Tdie2,4) + (fObj/S),0.25)
        
        let objectTemperature = (tObj - 273.15)
        
        return objectTemperature
    }
    
    // Get Accelerometer values
    class func getAccelerometerData(_ value: Data) -> [Double] {
        let dataFromSensor = dataToSignedBytes8(value)
        let xVal = Double(dataFromSensor[0]) / 64
        let yVal = Double(dataFromSensor[1]) / 64
        let zVal = Double(dataFromSensor[2]) / 64 * -1
        return [xVal, yVal, zVal]
    }
    
    // Get Relative Humidity
    class func getRelativeHumidity(_ value: Data) -> Double {
        let dataFromSensor = dataToUnsignedBytes16(value)
        let humidity = -6 + 125/65536 * Double(dataFromSensor[1])
        return humidity
    }
    
    // Get magnetometer values
    class func getMagnetometerData(_ value: Data) -> [Double] {
        let dataFromSensor = dataToSignedBytes16(value)
        let xVal = Double(dataFromSensor[0]) * 2000 / 65536 * -1
        let yVal = Double(dataFromSensor[1]) * 2000 / 65536 * -1
        let zVal = Double(dataFromSensor[2]) * 2000 / 65536
        return [xVal, yVal, zVal]
    }
    
    // Get gyroscope values
    class func getGyroscopeData(_ value: Data) -> [Double] {
        let dataFromSensor = dataToSignedBytes16(value)
        let yVal = Double(dataFromSensor[0]) * 500 / 65536 * -1
        let xVal = Double(dataFromSensor[1]) * 500 / 65536
        let zVal = Double(dataFromSensor[2]) * 500 / 65536
        return [xVal, yVal, zVal]
    }
}