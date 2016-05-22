//
//  BuddyBot.swift
//  BuddyBot
//
//  Created by Jon Hoffman on 5/7/16.
//

#if arch(arm) && os(Linux)
    import Glibc
#else
    import Darwin
#endif



struct BuddyBot {
    private let FORWARD = 0
    private let REVERSE = 1
    
    private let redLed: SBLed
    private let greenLed: SBLed
    private let yellowLed: SBLed
    private let startButton: SBButton
    private let rightRangeFinder: SBLV_MaxSonar_EZ2
    private let leftRangeFinder: SBLV_MaxSonar_EZ2
    
    private let rightMotor: SBGenericMotor
    private let leftMotor: SBGenericMotor

	private let rightIRSensor: SBIRAvoidanceSensor
	private let leftIRSensor: SBIRAvoidanceSensor

	private let tiltSensor: SBTiltSensor
    
    
    init?() {
        
        do {
            redLed = try SBLed(header: .P9, pin: 11, componentName: "Red LED")
            yellowLed = try SBLed(header: .P9, pin: 13, componentName: "Green LED")
            greenLed = try SBLed(header: .P9, pin: 15, componentName: "Yellow LED")

            startButton = try SBButton(header: .P9, pin: 12, componentName: "Start Button")
            rightMotor = try SBGenericMotor(headerSpeed: .P8, pinSpeed: 13, headerDirection: .P8, pinDirection: 14, componentName: "Right Track")
            leftMotor = try SBGenericMotor(headerSpeed: .P8, pinSpeed: 19, headerDirection: .P8, pinDirection: 16, componentName: "Left Track")
            leftRangeFinder = try SBLV_MaxSonar_EZ2(header: .P9, pin: 40, componentName: "right Range Finder")
            rightRangeFinder = try SBLV_MaxSonar_EZ2(header: .P9, pin: 39, componentName: "left Range Finder")
            rightIRSensor = try SBIRAvoidanceSensor(header: .P9, pin: 23, componentName: "Start Button")
            leftIRSensor = try SBIRAvoidanceSensor(header: .P9, pin: 25, componentName: "Start Button")
            tiltSensor = try SBTiltSensor(header: .P9, pin: 27, componentName: "Start Button")

        } catch {
            return nil
        }
        
    }
    
    func initBuddy()  {
        rightMotor.setSpeed(0)
        leftMotor.setSpeed(0)
        rightMotor.setDirection(FORWARD)
        leftMotor.setDirection(FORWARD)
        rightMotor.enableMotor(false)
        leftMotor.enableMotor(false)
    }
    
    func stopBuddy()  {
        rightMotor.setSpeed(0)
        leftMotor.setSpeed(0)
        rightMotor.setDirection(FORWARD)
        leftMotor.setDirection(FORWARD)
        rightMotor.enableMotor(false)
        leftMotor.enableMotor(false)
    }
    
    func goForward()  {
        rightMotor.setDirection(FORWARD)
        leftMotor.setDirection(FORWARD)
        rightMotor.setSpeed(75)
        leftMotor.setSpeed(75)
    }
    
    func turnRight()  {
        rightMotor.setDirection(REVERSE)
        leftMotor.setDirection(FORWARD)
        
        rightMotor.setSpeed(25)
        leftMotor.setSpeed(25)
    }
    
    func turnLeft()  {
        rightMotor.setDirection(FORWARD)
        leftMotor.setDirection(REVERSE)
        
        rightMotor.setSpeed(25)
        leftMotor.setSpeed(25)
    }
    
    func checkLeftRangeFinder(checkRange: Double) -> Bool {
        if let currentRange = leftRangeFinder.getRange() {
            return (currentRange < checkRange) ? true : false
        }
        return false
    }
    func getLeftRange() -> Double {
        return leftRangeFinder.getRange() ?? 0.0
    }
    
    func checkRightRangeFinder(checkRange: Double) -> Bool {
        if let currentRange = rightRangeFinder.getRange() {
            return (currentRange < checkRange) ? true : false
        }
        return false
    }
    func getRightRange() -> Double {
        return rightRangeFinder.getRange() ?? 0.0
    }
    
    func checkLeftIRSensor() -> Bool {
        return leftIRSensor.isObstacleDetected() ?? false
    }
    
    func checkRightIRSensor() -> Bool {
        return rightIRSensor.isObstacleDetected() ?? false
    }

    func checkTiltSensor() -> Bool {
        return tiltSensor.isTiltDetected() ?? false
    }
    
    func checkStartButtonPressed() -> Bool {
        return startButton.isButtonPressed() ?? false
    }
    
    func setStopLeds() {
		redLed.turnLedOn()
		greenLed.turnLedOn()
		yellowLed.turnLedOn()
    }
    func setForwardLeds() {
        redLed.turnLedOn()
        greenLed.turnLedOff()
        yellowLed.turnLedOff()
    }
    func setReverseLeds() {
        redLed.turnLedOff()
        greenLed.turnLedOff()
        yellowLed.turnLedOff()
    }
    func setLeftLeds() {
        redLed.turnLedOff()
        greenLed.turnLedOn()
        yellowLed.turnLedOff()
    }
    func setRightLeds() {
        redLed.turnLedOff()
        greenLed.turnLedOff()
        yellowLed.turnLedOn()
    }
    
}


