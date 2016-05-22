//
//  SBIRAvoidanceSensor.swift
//  SwiftyBones Component Library
//
//  Created by Jon Hoffman on 5/19/16.
//

/**
 This type represents an IR Obstacle Avoidance sensor connected to a Digital GPIO pin.  The SBIRAvoidanceSensor type is a value type
 Initialize:
 let irSensor = try SBIRAvoidanceSensor(header: .P9, pin: 11, componentName: "IR Sensor")
 or
 let irSensor = try SBIRAvoidanceSensor(gpio: SBDigitalGPIO(id: "gpio30", direction: .IN), componentName: "IR Sensor")
 Methods:
 isObstacleDetected() -> Bool?:  true if an obstacle is detected.
 */
struct SBIRAvoidanceSensor: SBComponentInProtocol {
    let componentName: String
    let gpio: SBDigitalGPIO
    
    /**
     Initlizes the SBIRAvoidanceSensor type using a SBDigitalGPIO type and a name.
     - Parameter gpio:  An instances of a SBDigitalGPIO type
     - Parameter componentName: A name for this instance that identifies it like "Left IR Sensor" or "Right IR Sensor"
     - Throws: ComponentErrors.InvalidGPIOType if the gpio parameter is not an instance of the SBDigitalGPIO type
     */
    init(gpio: GPIO?,componentName: String) throws {
        guard gpio != nil else {
            throw ComponentErrors.GPIOCanNotBeNil
        }
        if let testGpio = gpio as? SBDigitalGPIO {
            self.gpio = testGpio
            self.componentName = componentName
        } else {
            throw ComponentErrors.InvalidGPIOType("/(componentName): Expecting SBDigitalGPIO Type")
        }
    }
    
    /**
     Initlizes the SBIRAvoidanceSensor type using the pin defined by the header and pin parameters.  The component name defines a name for the sensor.
     - Parameter header:  The header of the pin that the sensor is connected too
     - Parameter pin:  The pin that the sensor is connected too
     - Parameter componentName: A name for this instance that identifies it like "Left IR Sensor" or "Right IR Sensor"
     - Throws: ComponentErrors.InvalidGPIOType if the gpio parameter is not an instance of the SBDigitalGPIO type
     */
    init(header: BBExpansionHeader, pin: Int, componentName: String) throws {
        if let gpio = SBDigitalGPIO(header: header, pin: pin, direction: .IN) {
            self.gpio = gpio
            self.componentName = componentName
        } else {
            throw ComponentErrors.GPIOCanNotBeNil
        }
    }
    
    /**
     The method retrieves the value of the GPIO pin that the sensor is connected to
     Returns: a 1 for HIGH or a 0 for LOW
     */
    func getRawValue() -> Int? {
        if let value = gpio.getValue() {
            return (value == DigitalGPIOValue.HIGH) ? 1 : 0
        } else {
            return nil
        }
    }
    
    /**
     Determines if the IR sensor detects an obstacle in front of it
     Returns: a true value if there is an obstacle in front or false if there isn't.  Will return nil if there was an error reading the sensor.
     */
    func isObstacleDetected() -> Bool? {
        if let value = getRawValue() {
            return (value == 0) ? true : false
        } else {
            return nil
        }
    }
}
