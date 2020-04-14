//
//  Time.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

public struct Time {
    var hour: Int
    var minute: Int
    var seconds: Int
    
    init(hour: Int, minute: Int, seconds: Int) {
        self.hour = hour
        self.minute = minute
        self.seconds = seconds
    }
    
    init(string: String) {
        let timeArray = string.components(separatedBy: ":")
        self.hour = Int(timeArray[0]) ?? 0
        self.minute = Int(timeArray[1]) ?? 0
        self.seconds = 0
    }
    
    func toString() -> String {
        var displayMinute: String = ""
        if minute < 10 {
            displayMinute = "0\(minute)"
        } else {
            displayMinute = "\(minute)"
        }
        return "\(hour):\(displayMinute)"
    }
}
