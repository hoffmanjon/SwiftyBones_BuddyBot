//
//  SBTiltSensor.swift
//  SwiftyBones Component Library
//
//  Created by Jon Hoffman on 5/19/16.
//

/**
 This type represents a tilt sensor connected to a Digital GPIO pin.  The SBTiltSensor type is a value type
 Initialize:
 let tiltSensor = try SBTiltSensor(header: .P9, pin: 11, componentName: "Tilt Sensor")
 or
 let tileSensor = try SBTiltSensor(gpio: SBDigitalGPIO(id: "gpio30", direction: .IN), componentName: "Tilt Sensor")
 Methods:
 isTiltDetected() -> Bool?:  true if the sensor is tilted.
 */
struct SBTiltSensor: SBComponentInProtocol {
    let componentName: String
    let gpio: SBDigitalGPIO
    
    /**
     Initlizes the SBTiltSensor type using a SBDigitalGPIO type and a name.
     - Parameter gpio:  An instances of a SBDigitalGPIO type
     - Parameter componentName: A name for this instance that identifies it like "Tilt Sensor"
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
     Initlizes the SBTiltSensor type using the pin defined by the header and pin parameters.  The component name defines a name for the sensor.
     - Parameter header:  The header of the pin that the sensor is connected too
     - Parameter pin:  The pin that the sensor is connected too
     - Parameter componentName: A name for this instance that identifies it like "Tilt Sensor"
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
     Determines if the tilt sensor is tilted
     Returns: a true value if the sensor is tilted or false if there isn't.  Will return nil if there was an error reading the sensor.
     */
    func isTiltDetected() -> Bool? {
        if let value = getRawValue() {
            return (value == 0) ? true : false
        } else {
            return nil
        }
    }
}
