//
//  PracticeTimerViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/11/18.
//  Copyright © 2018 Miguel Davalos. All rights reserved.
//

import UIKit

class PracticeTimerViewController: UIViewController {
    
    var reset = false
    var splitCounter = 1
    let stopwatch = Stopwatch()
    var splitTime: TimeInterval = 0.0
    var totalTime: TimeInterval = 0.0
    var oldTime: TimeInterval = 0.0
    
    var distance: String?
    var split: String?
    var numRunner: Int?
    
    // variables to calculate
    var runnerCount = 0
    var splitCount = 0
    var distanceCount = 0
    var splitDistance = 0
    var resetSplit = 0
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var splitStopButton: UIButton!
    @IBOutlet weak var splitDistanceLabel: UILabel!
    @IBOutlet weak var splitTimeLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var viewTimesButton: UIButton!
    @IBOutlet weak var runnersLeftLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceLabel.text = distance!
        
        runnerCount = numRunner!
        if( (Int(distance!)! % Int(split!)!) == 0) {
            //uneven split so the count needs to be incremented by one
            splitCount = (Int(distance!)! / Int(split!)!)
        } else {
            splitCount = (Int(distance!)! / Int(split!)!) + 1
        }
        resetSplit = splitCount
        runnersLeftLabel.text = String(numRunner!)
        splitDistanceLabel.text = split
        
        //if divides evenly set split count
        //if not set split count + 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        Timer.scheduledTimer(timeInterval: 0.01, target: self,
                             selector: #selector(PracticeTimerViewController.updateElapsedTimeLabel(_:)), userInfo: nil, repeats: true)
        stopwatch.start()
        splitStopButton.setTitle("Split", for: .normal)
        startButton.isEnabled = false
        splitStopButton.isEnabled = true

        print(splitCount)
        
        // disable app from locking while timer is running
        UIApplication.shared.isIdleTimerDisabled = true
    }
    @IBAction func stop(_ sender: Any) {
        //Not working with less than 3 runners on last split
        
        
        // button will be a split button,then stop button then a reset button
        if reset {
            // reset the times
            reset = false
            timerLabel.text = "00:00.00"
            splitDistanceLabel.text = "0"
            totalDistanceLabel.text = "0"
            splitTimeLabel.text = "00:00.00"
            totalTimeLabel.text = "00:00.00"
            startButton.isEnabled = true
            splitStopButton.isEnabled = false
            splitCount = resetSplit
            runnerCount = numRunner!
            distanceCount = 0
            splitDistance = 0
            runnersLeftLabel.text = String(runnerCount)
        } else if (splitCount == 1){
            if numRunner == 2 {
                //first runner
                if (runnerCount  == 0) {
                    print("Last Runner")
                    oldTime = totalTime
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime - oldTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    splitStopButton.setTitle("Stop", for: .normal)
                    splitCount = splitCount - 1
                    runnerCount = 1
                    runnersLeftLabel.text = String(runnerCount)
                }
            } else if numRunner == 1 {
                runnerCount = runnerCount - 1
                runnersLeftLabel.text = String(runnerCount)
                oldTime = totalTime
                totalTime = stopwatch.elapsedTime
                splitTime = stopwatch.elapsedTime - oldTime
                splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                timerLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                totalDistanceLabel.text = distance!
                print("Reset Button")
                stopwatch.stop()
                splitStopButton.setTitle("Reset", for: .normal)
                reset = true
                splitCounter = resetSplit
            } else {
                print("last split")
                if(runnerCount == numRunner) {
                    //start a split lap
                    print("First Runner")
                    distanceCount += Int(distance!)! / Int(resetSplit)
                    totalDistanceLabel.text = String(distanceCount)
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                } else if (runnerCount == 2) {
                    print("Last Runner")
                    oldTime = totalTime
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime - oldTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    splitStopButton.setTitle("Stop", for: .normal)
                    splitCount = splitCount - 1
                } else if (runnerCount  == 1) {
                    print("First New Runner")
                    distanceCount += Int(distance!)! / Int(resetSplit)
                    totalDistanceLabel.text = String(distanceCount)
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    runnerCount = numRunner!
                } else if (runnerCount  == 0) {
                    print("First New Runner")
                    distanceCount += Int(distance!)! / Int(resetSplit)
                    totalDistanceLabel.text = String(distanceCount)
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    runnerCount = numRunner!
                } else {
                    print("Runner " + String(runnerCount))
                    oldTime = totalTime
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime - oldTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                }
                
                runnerCount = runnerCount - 1
                runnersLeftLabel.text = String(runnerCount)
            }
            
        } else if (splitCount == 0) {
            runnerCount = runnerCount - 1
            runnersLeftLabel.text = String(runnerCount)
            oldTime = totalTime
            totalTime = stopwatch.elapsedTime
            splitTime = stopwatch.elapsedTime - oldTime
            splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
            totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
            timerLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
            totalDistanceLabel.text = distance!
            print("Reset Button")
            stopwatch.stop()
            splitStopButton.setTitle("Reset", for: .normal)
            reset = true
            splitCounter = resetSplit
        } else {
            if(runnerCount == numRunner) {
                //start a split lap
                print("First Runner")
                distanceCount += Int(distance!)! / Int(resetSplit)
                totalDistanceLabel.text = String(distanceCount)
                totalTime = stopwatch.elapsedTime
                splitTime = stopwatch.elapsedTime
                splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                runnerCount = runnerCount - 1
                runnersLeftLabel.text = String(runnerCount)
                
            } else if (runnerCount == 1) {
                print("Last Runner")
                oldTime = totalTime
                totalTime = stopwatch.elapsedTime
                splitTime = stopwatch.elapsedTime - oldTime
                splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                runnersLeftLabel.text = String(numRunner!)
                splitCount = splitCount - 1
                runnerCount = runnerCount - 1
            } else if (runnerCount == 0) {
                print("First New Runner")
                distanceCount += Int(distance!)! / Int(resetSplit)
                totalDistanceLabel.text = String(distanceCount)
                totalTime = stopwatch.elapsedTime
                splitTime = stopwatch.elapsedTime
                splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                
                runnerCount = numRunner!
                runnerCount = runnerCount - 1
                runnersLeftLabel.text = String(runnerCount)
            } else {
                print("Runner " + String(runnerCount))
                oldTime = totalTime
                totalTime = stopwatch.elapsedTime
                splitTime = stopwatch.elapsedTime - oldTime
                splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                runnerCount = runnerCount - 1
                runnersLeftLabel.text = String(runnerCount)
            }
        }
        
        // enable app to lock the screen again
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func updateElapsedTimeLabel(_ timer: Timer) {
        if stopwatch.isRunning {
            timerLabel.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }
    
}
