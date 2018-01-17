//
//  StopWatch.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 3/23/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

// Code taken from https://swifteducation.github.io/teaching_app_development_with_swift/stopwatch.html
// Changed to get a realy leg time and time to the hundredths

import Foundation

class Stopwatch {
    
    private var startTime: Date?

    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    
    var elapsedTimeAsString: String {
        return String(format: "%02d:%02d.%d%d",
            Int(elapsedTime / 60), Int(elapsedTime.truncatingRemainder(dividingBy: 60)),Int((elapsedTime * 10).truncatingRemainder(dividingBy: 10)), Int((elapsedTime * 100).truncatingRemainder(dividingBy: 10)) )
    }
    
    func elapsedLegTimeAsString(time legTime: TimeInterval) -> String {
        return String(format: "%02d:%02d.%d%d",
                      Int(legTime / 60), Int(legTime.truncatingRemainder(dividingBy: 60)),Int((legTime * 10).truncatingRemainder(dividingBy: 10)), Int((legTime * 100).truncatingRemainder(dividingBy: 10)) )
    
    }
    
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = Date()
    }
    
    func stop() {
        startTime = nil
    }
    
}
