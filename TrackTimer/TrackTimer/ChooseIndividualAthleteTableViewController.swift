//
//  ChooseIndividualAthleteTableViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/16/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class ChooseIndividualAthleteTableViewController: UITableViewController {

    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    var items: [Athlete] = []
    var selectedItem: Athlete? = nil
    
    var race: String?
    var sex: String?
    var place: String?
    var selectedRace: Event? = nil
    var raceInfo: EventDate? = nil
    
    override func viewDidLoad() {
        moc = coreDataStack.viewContext
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "AthleteTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        if indexPath.row < items.count {
            let p = items[indexPath.row]
            if let firstName = p.firstName {
                cell.nameLabel?.text = "\(firstName) \(p.lastName!)"
                cell.teamNameLabel?.text = "\(p.teamName!)"
                cell.yearLabel?.text = "\(p.year!)"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < items.count {
            selectedItem = items[indexPath.row]
            selectedRace = Event(context: moc)
            raceInfo = EventDate(context: moc)
            self.performSegue(withIdentifier: "athleteTime", sender: nil)
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? IndividualTimerViewController {
            dvc.item = selectedItem
             dvc.raceTime = selectedRace
            dvc.raceDate = raceInfo
            dvc.event = race
            dvc.location = place
           
            
        }
        
    }

}
