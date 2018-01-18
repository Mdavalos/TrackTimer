//
//  RelayTimerViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 3/30/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class RelayTimerViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopLapResetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var displayTime: UILabel!
    
    var moc: NSManagedObjectContext! = nil
    let coreDataStack = CoreDataStack.shared
    
    let stopwatch = Stopwatch()
    var time1: TimeInterval = 0.0
    var time2: TimeInterval = 0.0
    var time3: TimeInterval = 0.0
    var time4: TimeInterval = 0.0
    var totalTime: String = ""
    
    @IBOutlet weak var raceTextLabel: UILabel!
    
    var reset = false
    var splitCounter = 1
    
    var runner1: Athlete?
    var runner2: Athlete?
    var runner3: Athlete?
    var runner4: Athlete?
    
    @IBOutlet weak var runner1Label: UILabel!
    @IBOutlet weak var runner2Label: UILabel!
    @IBOutlet weak var runner3Label: UILabel!
    @IBOutlet weak var runner4Label: UILabel!
    
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
    @IBOutlet weak var time4Label: UILabel!
    
    
    var event: String?
    var location: String?
    
    
    var raceLeg1: RelayLeg?
    var raceLeg2: RelayLeg?
    var raceLeg3: RelayLeg?
    var raceLeg4: RelayLeg?
    
    var raceDate1: EventDate?
    var raceDate2: EventDate?
    var raceDate3: EventDate?
    var raceDate4: EventDate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopLapResetButton.isEnabled = false
        saveButton.isEnabled = false
        self.saveButton.layer.cornerRadius = 10
        self.startButton.layer.cornerRadius = 10
        self.stopLapResetButton.layer.cornerRadius = 10
        runner1Label.text = "\(runner1!.firstName!) \(runner1!.lastName!)"
        runner2Label.text = "\(runner2!.firstName!) \(runner2!.lastName!)"
        runner3Label.text = "\(runner3!.firstName!) \(runner3!.lastName!)"
        runner4Label.text = "\(runner4!.firstName!) \(runner4!.lastName!)"
        raceTextLabel.text = event
        
        moc = coreDataStack.viewContext

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        // Delete Event if the save button was not pushed
        if raceLeg1?.time == nil {
            let p = raceLeg1
            moc.performAndWait { [unowned self] in
                self.moc.delete(p!)
            }
            let x = raceLeg2
            moc.performAndWait { [unowned self] in
                self.moc.delete(x!)
            }
            let y = raceLeg3
            moc.performAndWait { [unowned self] in
                self.moc.delete(y!)
            }
            let z = raceLeg4
            moc.performAndWait { [unowned self] in
                self.moc.delete(z!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        Timer.scheduledTimer(timeInterval: 0.01, target: self,
                             selector: #selector(RelayTimerViewController.updateElapsedTimeLabel(_:)), userInfo: nil, repeats: true)
        stopwatch.start()
        stopLapResetButton.setTitle("Split", for: .normal)
        startButton.isEnabled = false
        stopLapResetButton.isEnabled = true
        
        // disable app from locking while timer is running
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @IBAction func stop(_ sender: Any) {
        // after start button is pushed the stop button will have 3 split buttons and then a spot button
        // after that the button will be a reset button
        if reset {
            reset = false
            displayTime.text = "00:00.00"
            time1Label.text = "00:00.00"
            time2Label.text = "00:00.00"
            time3Label.text = "00:00.00"
            time4Label.text = "00:00.00"
            startButton.isEnabled = true
            stopLapResetButton.isEnabled = false
        } else if splitCounter == 1 {
            time1 = stopwatch.elapsedTime
            splitCounter += 1
            time1Label.text = stopwatch.elapsedLegTimeAsString(time: time1)
        } else if splitCounter == 2 {
            time2 = stopwatch.elapsedTime - time1
            splitCounter += 1
            time2Label.text = stopwatch.elapsedLegTimeAsString(time: time2)
        } else if splitCounter == 3 {
            time3 = stopwatch.elapsedTime - time2 - time1
            stopLapResetButton.setTitle("Stop", for: .normal)
            splitCounter += 1
            time3Label.text = stopwatch.elapsedLegTimeAsString(time: time3)
        } else if splitCounter == 4 {
            time4 = stopwatch.elapsedTime - time3 - time2 - time1
            totalTime = stopwatch.elapsedTimeAsString
            time4Label.text = stopwatch.elapsedLegTimeAsString(time: time4)
            saveButton.isEnabled = true
            stopwatch.stop()
            stopLapResetButton.setTitle("Reset", for: .normal)
            reset = true
            splitCounter = 1
            
            // enable app to lock the screen again
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    @IBAction func save(_ sender: Any) {
        saveButton.isEnabled = false
        
        if let i = raceDate1 {
            let date = Date()
            let calendar = Calendar.current
            let m = calendar.component(.month, from: date)
            let y = calendar.component(.year, from: date)
            let d = calendar.component(.day, from: date)
            i.date = String(m) + "/" + String(d) + "/" + String(y)
            i.location = location
        }
        
        if let i = raceDate2 {
            let date = Date()
            let calendar = Calendar.current
            let m = calendar.component(.month, from: date)
            let y = calendar.component(.year, from: date)
            let d = calendar.component(.day, from: date)
            i.date = String(m) + "/" + String(d) + "/" + String(y)
            i.location = location
        }
        
        if let i = raceDate3 {
            let date = Date()
            let calendar = Calendar.current
            let m = calendar.component(.month, from: date)
            let y = calendar.component(.year, from: date)
            let d = calendar.component(.day, from: date)
            i.date = String(m) + "/" + String(d) + "/" + String(y)
            i.location = location
        }
        
        if let i = raceDate4 {
            let date = Date()
            let calendar = Calendar.current
            let m = calendar.component(.month, from: date)
            let y = calendar.component(.year, from: date)
            let d = calendar.component(.day, from: date)
            i.date = String(m) + "/" + String(d) + "/" + String(y)
            i.location = location
        }
        
        
        if let p = raceLeg1{
            p.distance = event
            p.time = stopwatch.elapsedLegTimeAsString(time: time1)
            p.leg = "1"
            p.totalTime = totalTime
            p.myRelayEventDate?.addToMyRelayEvents(raceLeg1!)
            
        }
        if let p = raceLeg2{
            p.distance = event
            p.time = stopwatch.elapsedLegTimeAsString(time: time2)
            p.leg = "2"
            p.totalTime = totalTime
            p.myRelayEventDate?.addToMyRelayEvents(raceLeg2!)
            
        }
        if let p = raceLeg3{
            p.distance = event
            p.time = stopwatch.elapsedLegTimeAsString(time: time3)
            p.leg = "3"
            p.totalTime = totalTime
            p.myRelayEventDate?.addToMyRelayEvents(raceLeg3!)
            
        }
        if let p = raceLeg4{
            p.distance = event
            p.time = stopwatch.elapsedLegTimeAsString(time: time4)
            p.leg = "4"
            p.totalTime = totalTime
            p.myRelayEventDate?.addToMyRelayEvents(raceLeg4!)
            
        }
        
        runner1?.addToMyAthleteRelayLegs(raceLeg1!)
        runner2?.addToMyAthleteRelayLegs(raceLeg2!)
        runner3?.addToMyAthleteRelayLegs(raceLeg3!)
        runner4?.addToMyAthleteRelayLegs(raceLeg4!)
        
        raceLeg1?.myRelayEventDate = raceDate1
        raceLeg2?.myRelayEventDate = raceDate2
        raceLeg3?.myRelayEventDate = raceDate3
        raceLeg4?.myRelayEventDate = raceDate4
        
        // go back to previous view controller
        navigationController?.popViewController(animated: true)

    }
    
    @objc func updateElapsedTimeLabel(_ timer: Timer) {
        if stopwatch.isRunning {
            displayTime.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }


}
