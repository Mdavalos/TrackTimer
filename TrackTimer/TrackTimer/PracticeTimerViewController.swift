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
    
    //variables for 1 or 2 runners
    var runnerOne = false
    var runnerTwo = false
    var firstSplit = true
    var twoSplits = false
    var timeHoldArray = [TimeInterval]()
    
    // variable array to hold the times
    var timeArray = [String]()
    var saveTime = true
    
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
        
        splitStopButton.isEnabled = false
        viewTimesButton.isEnabled = false
        
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
        viewTimesButton.isEnabled = false
        saveTime = true
        
        if(numRunner! == 1){
            runnerOne = true
            if (splitCount == 1) {
                splitStopButton.setTitle("Stop", for: .normal)
            }
        }
        if(numRunner! == 2) {
            runnerTwo = true
            if ( splitCount == 1) {
                twoSplits = true
            }
        }
        
        // disable app from locking while timer is running
        UIApplication.shared.isIdleTimerDisabled = true
    }
    @IBAction func stop(_ sender: Any) {
        if( runnerOne) {
            // One Runner WORKS
            if reset {
                // reset the times
                reset = false
                timerLabel.text = "00:00.00"
                splitDistanceLabel.text = split!
                totalDistanceLabel.text = "0"
                splitTimeLabel.text = "00:00.00"
                totalTimeLabel.text = "00:00.00"
                startButton.isEnabled = true
                splitStopButton.isEnabled = false
                viewTimesButton.isEnabled = false
                splitCount = resetSplit
                runnerCount = numRunner!
                distanceCount = 0
                splitDistance = 0
                oldTime = 0.0
                firstSplit = true
                runnersLeftLabel.text = String(runnerCount)
                saveTime = false
            } else if (splitCount == 1){
                runnerCount = runnerCount - 1
                runnersLeftLabel.text = String(runnerCount)
                oldTime = totalTime
                totalTime = stopwatch.elapsedTime
                splitTime = stopwatch.elapsedTime - oldTime
                splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                timerLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                totalDistanceLabel.text = distance!
                splitDistanceLabel.text = String(Int(distance!)! - distanceCount)
                stopwatch.stop()
                viewTimesButton.isEnabled = true
                splitStopButton.setTitle("Reset", for: .normal)
                reset = true
                splitCounter = resetSplit
            } else {
                if (firstSplit) {
                    distanceCount += Int(split!)!
                    totalDistanceLabel.text = String(distanceCount)
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    firstSplit = false
                    splitCount = splitCount - 1
                    
                } else {
                    oldTime = totalTime
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime - oldTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    distanceCount += Int(split!)!
                    totalDistanceLabel.text = String(distanceCount)
                    splitCount = splitCount - 1
                }
                if (splitCount == 1){
                    splitStopButton.setTitle("Stop", for: .normal)
                }
            }
            
        //Two runners
        } else if (runnerTwo) {
            if reset {
                // reset the times
                reset = false
                timerLabel.text = "00:00.00"
                splitDistanceLabel.text = split!
                totalDistanceLabel.text = "0"
                splitTimeLabel.text = "00:00.00"
                totalTimeLabel.text = "00:00.00"
                startButton.isEnabled = true
                splitStopButton.isEnabled = false
                viewTimesButton.isEnabled = false
                firstSplit = true
                splitCount = resetSplit
                runnerCount = numRunner!
                distanceCount = 0
                splitDistance = 0
                splitDistance = 0
                timeHoldArray  = []
                if ( splitCount == 1) {
                    twoSplits = true
                }
                saveTime = false
                runnersLeftLabel.text = String(runnerCount)
            } else if ( twoSplits) { // one split time
                totalDistanceLabel.text = distance!
                if (runnerCount == numRunner!) { //first runner
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    timeHoldArray[1] = totalTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    splitStopButton.setTitle("Stop", for: .normal)
                    runnerCount = 1
                    splitCount = splitCount - 1
                    runnersLeftLabel.text = String(runnerCount)
                } else { //second runner
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    timeHoldArray[1] = totalTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    runnerCount = 0
                    splitCount = splitCount - 1
                    runnersLeftLabel.text = String(runnerCount)
                    stopwatch.stop()
                    viewTimesButton.isEnabled = true
                    splitStopButton.setTitle("Reset", for: .normal)
                    reset = true
                    splitCounter = resetSplit
                    twoSplits = false
                }
            } else {
                //More than one split
                if (splitCount == 1){
                    //last split lap
                    if (runnerCount == numRunner!) { //first runner
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime - timeHoldArray[0]
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                        splitDistanceLabel.text = String(Int(distance!)! - distanceCount)
                        distanceCount += Int(split!)!
                        totalDistanceLabel.text = distance!
                        splitStopButton.setTitle("Stop", for: .normal)
                        runnerCount = 1
                        runnersLeftLabel.text = String(runnerCount)
                    } else { //second runner
                        runnerCount = 0
                        runnersLeftLabel.text = String(runnerCount)
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime - timeHoldArray[1]
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                        timerLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                        totalDistanceLabel.text = distance!
                        stopwatch.stop()
                        viewTimesButton.isEnabled = true
                        splitStopButton.setTitle("Reset", for: .normal)
                        reset = true
                        splitCounter = resetSplit
                    }
                    
                } else {
                    //start the split for first time
                    if (firstSplit) {
                        if (runnerCount == numRunner!) { //first runner
                            totalTime = stopwatch.elapsedTime
                            splitTime = stopwatch.elapsedTime
//                            timeHoldArray[0] = totalTime
                            timeHoldArray.append(totalTime)
                            splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                            totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                            runnerCount = 1
                            runnersLeftLabel.text = String(runnerCount)
                            distanceCount += Int(split!)!
                        } else { //second runner
                            totalTime = stopwatch.elapsedTime
                            splitTime = stopwatch.elapsedTime
//                            timeHoldArray[1] = totalTime
                            timeHoldArray.append(totalTime)
                            splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                            totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                            runnerCount = 2
                            runnersLeftLabel.text = String(runnerCount)
                            firstSplit = false
                            splitCount = splitCount - 1
                        }
                        
                        totalDistanceLabel.text = String(distanceCount)
                        
                    } else { //continue the split time
                        if (runnerCount == numRunner!) { //first runner
                            totalTime = stopwatch.elapsedTime
                            splitTime = stopwatch.elapsedTime - timeHoldArray[0]
                            timeHoldArray[0] = totalTime
                            splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                            totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                            runnerCount = 1
                            runnersLeftLabel.text = String(runnerCount)
                            distanceCount += Int(split!)!
                            
                        } else { //second runner
                            totalTime = stopwatch.elapsedTime
                            splitTime = stopwatch.elapsedTime - timeHoldArray[1]
                            timeHoldArray[1] = totalTime
                            splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                            totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                            runnerCount = 2
                            runnersLeftLabel.text = String(runnerCount)
                            splitCount = splitCount - 1
                            
                        }
                        totalDistanceLabel.text = String(distanceCount)
                    }
                }
            }
            
        } else {
            //More than 2 runners DOES NOT WORK
            if reset {
                // reset the times
                reset = false
                timerLabel.text = "00:00.00"
                splitDistanceLabel.text = split!
                totalDistanceLabel.text = "0"
                splitTimeLabel.text = "00:00.00"
                totalTimeLabel.text = "00:00.00"
                startButton.isEnabled = true
                splitStopButton.isEnabled = false
                viewTimesButton.isEnabled = false
                splitCount = resetSplit
                runnerCount = numRunner!
                distanceCount = 0
                splitDistance = 0
                runnersLeftLabel.text = String(runnerCount)
                saveTime = false
            } else if (splitCount == 1){
                if numRunner == 2 {
                    //first runner
                    if (runnerCount  == 0) {
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
                    stopwatch.stop()
                    viewTimesButton.isEnabled = true
                    splitStopButton.setTitle("Reset", for: .normal)
                    reset = true
                    splitCounter = resetSplit
                } else {
                    // last split
                    if(runnerCount == numRunner) {
                        //start a split lap
                        //First Runner
                        totalDistanceLabel.text = distance!
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    } else if (runnerCount == 2) {
                        //Last Runner
                        oldTime = totalTime
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime - oldTime
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                        splitStopButton.setTitle("Stop", for: .normal)
                        splitCount = splitCount - 1
                    } else if (runnerCount  == 1) {
                        // First New Runner
                        totalDistanceLabel.text = distance!
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                        runnerCount = numRunner!
                    } else if (runnerCount  == 0) {
                        // First New Runner
                        totalDistanceLabel.text = distance!
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                        runnerCount = numRunner!
                    } else {
                        // Runner in middle
                        oldTime = totalTime
                        totalTime = stopwatch.elapsedTime
                        splitTime = stopwatch.elapsedTime - oldTime
                        splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                        totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    }
                    
                    runnerCount = runnerCount - 1
                    runnersLeftLabel.text = String(runnerCount)
                    splitDistanceLabel.text = String(Int(distance!)! - distanceCount)
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
                stopwatch.stop()
                viewTimesButton.isEnabled = true
                splitStopButton.setTitle("Reset", for: .normal)
                reset = true
                splitCounter = resetSplit
            } else {
                if(runnerCount == numRunner) {
                    //start a split lap
                    distanceCount += Int(split!)!
                    totalDistanceLabel.text = String(distanceCount)
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    runnerCount = runnerCount - 1
                    runnersLeftLabel.text = String(runnerCount)
                    
                } else if (runnerCount == 1) {
                    oldTime = totalTime
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime - oldTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    runnersLeftLabel.text = String(numRunner!)
                    splitCount = splitCount - 1
                    runnerCount = runnerCount - 1
                } else if (runnerCount == 0) {
                    distanceCount += Int(split!)!
                    totalDistanceLabel.text = String(distanceCount)
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    
                    runnerCount = numRunner!
                    runnerCount = runnerCount - 1
                    runnersLeftLabel.text = String(runnerCount)
                } else {
                    oldTime = totalTime
                    totalTime = stopwatch.elapsedTime
                    splitTime = stopwatch.elapsedTime - oldTime
                    splitTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: splitTime)
                    totalTimeLabel.text = stopwatch.elapsedLegTimeAsString(time: totalTime)
                    runnerCount = runnerCount - 1
                    runnersLeftLabel.text = String(runnerCount)
                }
            }
        }
        // split dis , split time, total dis total time
        if (saveTime){
            timeArray.append("Split " + splitDistanceLabel.text! + ": " + stopwatch.elapsedLegTimeAsString(time: splitTime) + "    Total " + totalDistanceLabel.text! + ": " + stopwatch.elapsedLegTimeAsString(time: totalTime))
        }
        
        // enable app to lock the screen again
        UIApplication.shared.isIdleTimerDisabled = false
    }
    @IBAction func viewTimes(_ sender: UIButton) {
        print(timeArray)
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send the event, the gender, and location
        if let dvc = segue.destination as? ViewPracticeTimesTableViewController {
            dvc.viewTimesArray = timeArray
        }
        
    }
    
    @objc func updateElapsedTimeLabel(_ timer: Timer) {
        if stopwatch.isRunning {
            timerLabel.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }
    
}
