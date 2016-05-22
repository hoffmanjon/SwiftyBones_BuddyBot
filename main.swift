//
//  main.swift
//  BuddyBot
//
//  Created by Jon Hoffman on 5/7/16.
//

#if arch(arm) && os(Linux)
    import Glibc
#else
    import Darwin
#endif

print("Starting BuddyBot")

enum BuddyState {
    case STOPPED
    case FORWARD
    case REVERSE
    case TURNINGLEFT
    case TURNINGRIGHT
}


func setLeds(state: BuddyState, buddy: BuddyBot) {
    switch state {
    case .STOPPED:
        buddy.setStopLeds()
    case .FORWARD:
        buddy.setForwardLeds()
    case .REVERSE:
        buddy.setReverseLeds()
    case .TURNINGLEFT:
        buddy.setLeftLeds()
    case .TURNINGRIGHT:
        buddy.setRightLeds()
    }
}


private let RANGECHECK = 18.0

var buttonPressed = false
var buddyState = BuddyState.STOPPED


if let buddy = BuddyBot() {
	buddy.initBuddy()
    while (true) {
        setLeds(buddyState, buddy: buddy)
        while !buttonPressed {
            buttonPressed = buddy.checkStartButtonPressed()
        }
        
        var buttonStillPressed = true
        var running = true
        while(running) {
            let leftRangeToCheck = (buddyState == .TURNINGLEFT) ? RANGECHECK * 1.7 : RANGECHECK
            let rightRangeToCheck = (buddyState == .TURNINGRIGHT) ? RANGECHECK * 1.7 : RANGECHECK
            
            if buddy.checkLeftRangeFinder(leftRangeToCheck) || buddy.checkRightRangeFinder(rightRangeToCheck) || buddy.checkLeftIRSensor() || buddy.checkRightIRSensor() {
                let rightRange = buddy.getRightRange()
                let leftRange = buddy.getLeftRange()
                if (leftRange < rightRange || buddy.checkLeftIRSensor()) && buddyState != .TURNINGLEFT {
                    buddy.turnRight()
                    buddyState = .TURNINGRIGHT
                } else if (leftRange > rightRange || buddy.checkRightIRSensor()) && buddyState != .TURNINGRIGHT {
                    buddy.turnLeft()
                    buddyState = .TURNINGLEFT
                } else if leftRange == rightRange {
                    buddy.turnRight()
                    buddyState = .TURNINGRIGHT
                }
            } else if buddyState != .FORWARD {
                buddy.goForward()
                buddyState = .FORWARD
            }

            
            setLeds(buddyState, buddy: buddy)
            
            if buddyState == .FORWARD {
                usleep(25000)
            } else {
                usleep(50000)
            }
            
            if (!buddy.checkStartButtonPressed()) {
                buttonStillPressed = false
            } else if !buttonStillPressed {
                running = false
            }
            
            if buddy.checkTiltSensor() {
                running = false
            }
            
        }
        buddy.stopBuddy()
        while(buddy.checkStartButtonPressed()) {}
    }
    
    
    
} else {
	print("could not start BuddyBot")
}




