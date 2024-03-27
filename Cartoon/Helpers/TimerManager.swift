//
//  TimerManager.swift
//  Cartoon
//
//  Created by BCL Device-18 on 18/3/24.
//

import Foundation

class TimerManager {
    var timer: Timer?
    var secondsRemaining: Double = 0
    var timerCallback: ((Double) -> Void)?
    
    func startTimer(duration: Double, callback: @escaping (Double) -> Void) {
        self.secondsRemaining = duration
        self.timerCallback = callback
        
        // Invalidate previous timer if running
        timer?.invalidate()
        
        // Start a new timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func endTimer() {
        // Invalidate previous timer if running
        timer?.invalidate()
    }
    
    @objc func updateTimer() {
        secondsRemaining -= 1
        
        // Call the callback function with the updated time
        timerCallback?(secondsRemaining)
        
        if secondsRemaining <= 0 {
            timer?.invalidate()
            print("Timer ended.")
        }
    }
}
