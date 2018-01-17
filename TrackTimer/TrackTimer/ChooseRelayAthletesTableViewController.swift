//
//  ChooseRelayAthletesTableViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 3/30/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class ChooseRelayAthletesTableViewController: UITableViewController {

    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    var items: [Athlete] = []
    
    var numAthletesSelected = 0
    
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    
    var race: String?
    var sex: String?
    var place: String?
    
    var relayRaceInfo1: EventDate? = nil
    var raceInfo1: RelayLeg? = nil
    
    var relayRaceInfo2: EventDate? = nil
    var raceInfo2: RelayLeg? = nil
    
    var relayRaceInfo3: EventDate? = nil
    var raceInfo3: RelayLeg? = nil
    
    var relayRaceInfo4: EventDate? = nil
    var raceInfo4: RelayLeg? = nil
    
    @IBOutlet weak var selectionInfoLabel: UILabel!
    @IBOutlet weak var legNum: UILabel!
    
    override func viewDidLoad() {
        moc = coreDataStack.viewContext
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "RelayCell")
        let nib = UINib(nibName: "RelayAthleteTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RelayCell")
        tableView.allowsMultipleSelection = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
        tableView.reloadData()
        tableView.tableHeaderView = selectionInfoLabel
        okButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        numAthletesSelected  = 0;
        selectionInfoLabel.text = "\(numAthletesSelected)/4 Selected"
    }
    
    func reload() {
        // reload the data in sorted order to display
        let genderPredicate = NSPredicate(format: "gender = %@",  sex!)
        let firstNameSorter = NSSortDescriptor(key: "firstName", ascending: true)
        let lastNameSorter = NSSortDescriptor(key: "lastName", ascending: true)
        let teamSorter = NSSortDescriptor(key: "teamName", ascending: true)
        let yearSorter = NSSortDescriptor(key: "year", ascending: true)
        items = Athlete.items(for: moc, matching: genderPredicate, sortedBy: [teamSorter, yearSorter, lastNameSorter, firstNameSorter])
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RelayCell", for: indexPath) as! EventTableViewCell
        
        // Configure the cell...
        if indexPath.row < items.count {
            let p = items[indexPath.row]
            if let firstName = p.firstName {
//                cell.textLabel?.text = "\(firstName) \(p.lastName!)"
                cell.nameLabel.text = "\(firstName) \(p.lastName!)"
                cell.legLabel.text = "Leg: \(numAthletesSelected)"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell

        numAthletesSelected += 1
            selectionInfoLabel.text = "\(numAthletesSelected)/4 Selected"
            cell.nameLabel.text = "\(items[indexPath.row].firstName!) \(items[indexPath.row].lastName!)"
            cell.legLabel.text? = "Leg: \(numAthletesSelected)"
        
            if numAthletesSelected > 4 {
                cell.isSelected = false
                numAthletesSelected -= 1
                selectionInfoLabel.text = "\(numAthletesSelected)/4 Selected"
                cell.legLabel.text? = "Leg: \(numAthletesSelected)"
            }
        
        if numAthletesSelected == 4{
            okButton.isEnabled = true
        }else {
            okButton.isEnabled = false
        }

    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
            numAthletesSelected -= 1
            selectionInfoLabel.text = "\(numAthletesSelected)/4 Selected"
            cell.legLabel.text? = "Leg: 0"
            
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        relayRaceInfo1 = EventDate(context: moc)
        raceInfo1 = RelayLeg(context: moc)
        relayRaceInfo2 = EventDate(context: moc)
        raceInfo2 = RelayLeg(context: moc)
        relayRaceInfo3 = EventDate(context: moc)
        raceInfo3 = RelayLeg(context: moc)
        relayRaceInfo4 = EventDate(context: moc)
        raceInfo4 = RelayLeg(context: moc)
        
        if let dvc = segue.destination as? RelayTimerViewController {
            // send the four athletes' data and the date and location
            dvc.raceDate1 = relayRaceInfo1
            dvc.raceDate2 = relayRaceInfo2
            dvc.raceDate3 = relayRaceInfo3
            dvc.raceDate4 = relayRaceInfo4
            
            dvc.raceLeg1 = raceInfo1
            dvc.raceLeg2 = raceInfo2
            dvc.raceLeg3 = raceInfo3
            dvc.raceLeg4 = raceInfo4
            dvc.event = race
            dvc.location = place
            
            let one = tableView.indexPathsForSelectedRows?[0][1]
            let two = tableView.indexPathsForSelectedRows?[1][1]
            let three = tableView.indexPathsForSelectedRows?[2][1]
            let four = tableView.indexPathsForSelectedRows?[3][1]
            dvc.runner1 = items[one!]
            dvc.runner2 = items[two!]
            dvc.runner3 = items[three!]
            dvc.runner4 = items[four!]
            
        }
        
    }
}
