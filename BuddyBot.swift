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

enum RobotState {
    case STOPPED
    case FORWARD
    case REVERSE
    case TURNINGLEFT
    case TURNINGRIGHT
}

struct BuddyBot {
    private let FORWARD = 0
    private let REVERSE = 1
    private let RANGECHECK = 18.0
    
    private let redLed: SBLed
    private let greenLed: SBLed
    private let yellowLed: SBLed
    private let startButton: SBButton
    private let rightRangeFinder: SBLV_MaxSonar_EZ2
    private let leftRangeFinder: SBLV_MaxSonar_EZ2
    
    private let rightMotor: SBGenericMotor
    private let leftMotor: SBGenericMotor
    
    
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
        } catch {
            return nil
        }
        
    }
    
    func initRover()  {
        rightMotor.setSpeed(0)
        leftMotor.setSpeed(0)
        rightMotor.setDirection(FORWARD)
        leftMotor.setDirection(FORWARD)
        rightMotor.enableMotor(false)
        leftMotor.enableMotor(false)
    }
    
    func stopRover()  {
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
    
    func start() {
        initRover()
        while(true) {
            var buttonPressed = false
            var robotState = RobotState.STOPPED
            setLeds(robotState)
            while !buttonPressed {
                if let buttonValue = startButton.isButtonPressed() {
                    buttonPressed = buttonValue
                }
            }
            
            var buttonStillPressed = true
            var running = true
            
            while(running) {
                let leftRange = leftRangeFinder.getRange()
                let rightRange = rightRangeFinder.getRange()
                let checkLeftRange = (robotState == .TURNINGLEFT) ? RANGECHECK * 1.7 : RANGECHECK
                let checkRightRange = (robotState == .TURNINGRIGHT) ? RANGECHECK * 1.7 : RANGECHECK
                if leftRange < checkLeftRange || rightRange < checkRightRange {
                    if leftRange < rightRange && robotState != .TURNINGLEFT {
                        turnRight()
                        robotState = .TURNINGRIGHT
                    } else if leftRange > rightRange && robotState != .TURNINGRIGHT {
                        turnLeft()
                        robotState = .TURNINGLEFT
                    } else if leftRange == rightRange {
                        turnRight()
                        robotState = .TURNINGRIGHT
                    }
                } else if robotState != .FORWARD {
                    goForward()
                    robotState = .FORWARD
                }
                setLeds(robotState)
                if robotState == .FORWARD {
                    usleep(25000)
                } else {
                    usleep(50000)
                }
                
                if let buttonValue = startButton.isButtonPressed() {
                    if !buttonValue {
                        buttonStillPressed = false
                    } else if !buttonStillPressed {
                        running = false
                    }
                }
            }
            stopRover()
            while(startButton.isButtonPressed()!) {}
        }
    }
    
    func setLeds(state: RobotState) {
        switch state {
        case .STOPPED:
            redLed.turnLedOn()
            greenLed.turnLedOn()
            yellowLed.turnLedOn()
        case .FORWARD:
            redLed.turnLedOn()
            greenLed.turnLedOff()
            yellowLed.turnLedOff()
        case .REVERSE:
            redLed.turnLedOff()
            greenLed.turnLedOff()
            yellowLed.turnLedOff()
        case .TURNINGLEFT:
            redLed.turnLedOff()
            greenLed.turnLedOn()
            yellowLed.turnLedOff()
        case .TURNINGRIGHT:
            redLed.turnLedOff()
            greenLed.turnLedOff()
            yellowLed.turnLedOn()			
        }
    }
}