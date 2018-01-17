//
//  detailAthleteViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/4/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class detailAthleteViewController: UIViewController, UITextFieldDelegate {
    
    var item: Athlete?
    
    var moc: NSManagedObjectContext! = nil
    let coreDataStack = CoreDataStack.shared

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var teamNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        genderTextField.delegate = self
        yearTextField.delegate = self
        dobTextField.delegate = self
        teamNameTextField.delegate = self

        moc = coreDataStack.viewContext

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrameNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        // get the info from the athlete and display in the text fields
        if let p = item {
            firstNameTextField.text = p.firstName
            lastNameTextField.text = p.lastName
            genderTextField.text = p.gender
            yearTextField.text = p.year
            dobTextField.text = p.dateOfBirth
            teamNameTextField.text = p.teamName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        // Put the updated text from the text fields to the Athlete
        let p = item
        if firstNameTextField.text == "" && lastNameTextField.text == "" && genderTextField.text == "" && yearTextField.text == ""
            && dobTextField.text == "" && teamNameTextField.text == "" {
            // delete the person if no information was entered
            moc.performAndWait { [unowned self] in
                self.moc.delete(p!)
            }
        } else {
            p?.firstName = firstNameTextField.text
            p?.lastName = lastNameTextField.text
            p?.gender = genderTextField.text
            p?.year = yearTextField.text
            p?.dateOfBirth = dobTextField.text
            p?.teamName = teamNameTextField.text
        }
    }
    
    @IBAction func tapRecognize(_ sender: Any) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
        dobTextField.resignFirstResponder()
        teamNameTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ViewTimesTableViewController {
            dvc.runner = item
        }
        if let dvc = segue.destination as? ViewRelayTimesTableViewController {
            dvc.runner = item
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
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
