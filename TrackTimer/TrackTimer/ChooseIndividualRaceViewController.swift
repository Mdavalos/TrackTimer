//
//  ChooseIndividualRaceViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 3/23/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ChooseIndividualRaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate {
    
    let race = ["100","100H","110H","200","400","400H","800"]
    let gender = ["Male", "Female"]
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var racePicker: UIPickerView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    // reverse geolocate location of the user to get city
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if
                let city = placemarks?.first?.locality {
                completion(city)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.okButton.layer.cornerRadius = 10
        //        locationTextField.delegate = self
        
        // for use when the app is open & in the background
        //        locationManager.requestAlwaysAuthorization()
        
        // for use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // if location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // you can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
    }
    
    // get the location of the user in latitude and longitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            fetchCountryAndCity(location: location) { city in
                // set location of city to textfield
                self.locationTextField.text = city
                // stop getting th users location
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    // if we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to know where you're running we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrameNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:-
    // MARK: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return race.count
        } else {
            return gender.count
        }
    }
    
    // MARK:-
    // MARK: Picker Delegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return race[row]
        } else {
            return gender[row]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send the event, the gender, and location
        if let dvc = segue.destination as? ChooseIndividualAthleteTableViewController {
            dvc.race = race[racePicker.selectedRow(inComponent: 0)]
            dvc.sex = gender[racePicker.selectedRow(inComponent: 1)]
            dvc.place = locationTextField.text
        }
        
    }
    @IBAction func tapRecognizer(_ sender: Any) {
        locationTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // resign responder and return true so Return/Enter key on keyboard hides keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // keep track of which textfield we are editing so we can use it in keyboardWillChangeFrameNotification
        currentField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // not editing a textfield
        currentField = nil
    }
    
    @objc func keyboardWillChangeFrameNotification(notification: Notification) {
        // if we are currently editing some textfield
        if let field = currentField,
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let fieldFrame = field.frame
            // adjusted (based on current viewOffset) bottom of field + 25 to leave some space above the keyboard
            let fieldBottom = fieldFrame.origin.y + fieldFrame.height + 25 - viewOffset
            
            // if keyboard hides frame, move view up
            if fieldBottom > keyboardFrame.origin.y {
                let offset = fieldBottom - keyboardFrame.origin.y
                viewOffset += offset
                UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                    self.view.frame.origin.y -= offset
                })
            } else if viewOffset > 0 {
                // if we've already moved view up and this textfield is far enough above, move view down
                if fieldBottom + 30 < keyboardFrame.origin.y {
                    let offset = min(40, viewOffset)
                    viewOffset -= offset
                    UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                        self.view.frame.origin.y += offset
                    })
                }
            }
        } else {
            // not editing any textfield so move back to original location
            if view.frame.origin.y < 0.0 {
                UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                    self.view.frame.origin.y = 0
                })
                viewOffset = 0.0
            }
        }
    }
    
    private var viewOffset: CGFloat = 0.0
    private var currentField: UITextField? = nil


}
