//
//  PracticeTimerSelectViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/11/18.
//  Copyright © 2018 Miguel Davalos. All rights reserved.
//

import UIKit

class PracticeTimerSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let distance = ["100","200","300","400","500","600","700","800","900","1000","1100","1200","1300","1400","1500","1600"]
    let split = ["100","200","300","400","500","600","700","800"]

    @IBOutlet weak var practicePicker: UIPickerView!
    @IBOutlet weak var runnerTextField: UILabel!
    @IBOutlet weak var runnerStepper: UIStepper!
    var splitCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runnerStepper.maximumValue = 10
        runnerStepper.minimumValue = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        runnerTextField.text = "Number of Runners: " + Int(sender.value).description
    }
    
    
    // MARK:-
    // MARK: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return distance.count
        } else {
//            return split.count
            return splitCount
        }
    }
    
    // MARK:-
    // MARK: Picker Delegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return distance[row]
        } else {
            return split[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            if row > 7 {
                splitCount = split.count
            } else {
                splitCount = row + 1
            }
        }
        pickerView.reloadComponent(1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send the event, the gender, and location
        if let dvc = segue.destination as? PracticeTimerViewController {
            dvc.distance = distance[practicePicker.selectedRow(inComponent: 0)]
            dvc.split = split[practicePicker.selectedRow(inComponent: 1)]
            dvc.numRunner = Int(runnerStepper.value)
        }
        
    }

}
