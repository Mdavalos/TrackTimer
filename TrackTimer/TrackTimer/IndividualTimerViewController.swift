//
//  IndividualTimerViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 3/23/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class IndividualTimerViewController: UIViewController {

    @IBOutlet weak var displayTimeLabel: UILabel!
    
    let stopwatch = Stopwatch()
    var time: String = ""
    
    var moc: NSManagedObjectContext! = nil
    let coreDataStack = CoreDataStack.shared
    
    var item: Athlete?
    var event: String?
    var location: String?
    
    var raceTime: Event?
    var raceDate: EventDate?
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopResetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var raceInfoLabel: UILabel!
    
    var reset = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        stopResetButton.isEnabled = false
        saveButton.isEnabled = false
        self.saveButton.layer.cornerRadius = 10
        self.startButton.layer.cornerRadius = 10
        self.stopResetButton.layer.cornerRadius = 10
        raceInfoLabel.text = event
        moc = coreDataStack.viewContext
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Delete Event if the save button was not pushed
        if raceTime?.time == nil{
                            let p = raceTime
                            moc.performAndWait { [unowned self] in
                                self.moc.delete(p!)
                            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        Timer.scheduledTimer(timeInterval: 0.01, target: self,
                             selector: #selector(IndividualTimerViewController.updateElapsedTimeLabel(_:)), userInfo: nil, repeats: true)
        stopwatch.start()
        stopResetButton.setTitle("Stop", for: .normal)
        startButton.isEnabled = false
        stopResetButton.isEnabled = true
        
        // disable app from locking while timer is running
        UIApplication.shared.isIdleTimerDisabled = true
    }

    @IBAction func stop(_ sender: Any) {
        // button will be a stop button until pushed then become a reset button
        if reset {
            reset = false
            displayTimeLabel.text = "00:00.00"
            startButton.isEnabled = true
            stopResetButton.isEnabled = false
            saveButton.isEnabled = false
        } else {
            time = stopwatch.elapsedTimeAsString
            saveButton.isEnabled = true
            stopwatch.stop()
            stopResetButton.setTitle("Reset", for: .normal)
            reset = true
            
            // enable app to lock the screen again
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    @IBAction func saveTime(_ sender: Any) {
        
        saveButton.isEnabled = false
        
        if let p = raceTime{
            p.distance = event
            p.time = time
            p.myEventDate?.addToMyEvents(raceTime!)
        
        }
        
        if let i = raceDate {
            let date = Date()
            let calendar = Calendar.current
            let m = calendar.component(.month, from: date)
            let y = calendar.component(.year, from: date)
            let d = calendar.component(.day, from: date)
            i.date = String(m) + "/" + String(d) + "/" + String(y)
            i.location = location
        }
        
        item?.addToMyAthleteEvents(raceTime!)
        raceTime?.myEventDate = raceDate!
        
        // go back to previous view controller
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateElapsedTimeLabel(_ timer: Timer) {
        if stopwatch.isRunning {
            displayTimeLabel.text = stopwatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }

}
