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
    
    private let runningLed: SBLed
    private let startButton: SBButton
    private let forwardRangeFinder: SBLV_MaxSonar_EZ2
    
    private let rightMotor: SBGenericMotor
    private let leftMotor: SBGenericMotor
    
    
    init?() {
        
        do {
            runningLed = try SBLed(header: .P9, pin: 11, componentName: "Running LED")
            startButton = try SBButton(header: .P9, pin: 12, componentName: "Start Button")
            rightMotor = try SBGenericMotor(headerSpeed: .P8, pinSpeed: 13, headerDirection: .P8, pinDirection: 14, componentName: "Right Track")
            leftMotor = try SBGenericMotor(headerSpeed: .P8, pinSpeed: 19, headerDirection: .P8, pinDirection: 16, componentName: "Left Track")
            forwardRangeFinder = try SBLV_MaxSonar_EZ2(header: .P9, pin: 40, componentName: "Forward Range Finder")
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
    
    func start() {
        initRover()

        var buttonPressed = false
        while !buttonPressed {
            if let buttonValue = startButton.isButtonPressed() {
                buttonPressed = buttonValue
            }
        }
        var movingForward = false
        var buttonStillPressed = true
		var running = true

		while(running) {    
			usleep(5000)
			let range = forwardRangeFinder.getRange()
            print("Range:  \(range)")
            if range < 9 {
				turnRight()
				movingForward = false
				usleep(500000)
				stopRover()			
			} else if !movingForward {
				goForward()
				movingForward = true
			}				
			
			if let buttonValue = startButton.isButtonPressed() {
				if !buttonValue {
					buttonStillPressed = false
				} else if !buttonStillPressed {
					running = false
				}
            }
       }
		runningLed.turnLedOff()        
 		stopRover()       
    }
}
