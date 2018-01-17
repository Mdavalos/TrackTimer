//
//  AthleteListTableViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/4/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class AthleteListTableViewController: UITableViewController {
    
    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    var items: [Athlete] = []
    var selectedItem: Athlete? = nil
    
    var test: [Event] = []

    override func viewDidLoad() {
        moc = coreDataStack.viewContext
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "AthleteTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
//         Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false
//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         let rightEditBarButtonItem:UIBarButtonItem = self.editButtonItem
        
        // add a plus button to add more people
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewAthlete(_ :)))
        self.navigationItem.rightBarButtonItems = [addButton, rightEditBarButtonItem ]
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
    
    @objc func insertNewAthlete(_ sender: Any) {
        selectedItem = Athlete(context: moc)
        performSegue(withIdentifier: "showDetail", sender: sender)
    }
    
    func reload() {
        // reload the data in sorted order to display
        let firstNameSorter = NSSortDescriptor(key: "firstName", ascending: true)
        let lastNameSorter = NSSortDescriptor(key: "lastName", ascending: true)
        let genderSorter = NSSortDescriptor(key: "gender", ascending: true)
        let teamSorter = NSSortDescriptor(key: "teamName", ascending: true)
        let yearSorter = NSSortDescriptor(key: "year", ascending: true)
        items = Athlete.items(for: moc, matching: nil, sortedBy: [teamSorter, genderSorter, yearSorter, lastNameSorter, firstNameSorter])
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let p = items[indexPath.row]
            moc.performAndWait { [unowned self] in
                self.moc.delete(p)
            }
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < items.count {
            selectedItem = items[indexPath.row]
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? detailAthleteViewController {
            dvc.item = selectedItem
        }
        
    }

}
