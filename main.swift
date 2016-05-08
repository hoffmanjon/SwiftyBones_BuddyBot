//
//  main.swift
//  BuddyBot
//
//  Created by Jon Hoffman on 5/7/16.
//


print("Hello, World!")

if let buddy = BuddyBot() {
	buddy.start()
} else {
	print("could not start BuddyBot")
}
