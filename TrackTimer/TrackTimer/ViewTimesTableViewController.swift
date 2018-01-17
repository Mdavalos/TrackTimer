//
//  ViewTimesTableViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/19/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class ViewTimesTableViewController: UITableViewController {
    
    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    var runner: Athlete?
    var items: [Event] = []
    
    override func viewDidLoad() {
        moc = coreDataStack.viewContext
        tableView.register(EventViewCell.self, forCellReuseIdentifier: "EventCell")
        let nib = UINib(nibName: "EventViewTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCell")
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let set = runner?.myAthleteEvents
        items = set?.allObjects as! [Event]
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
        let EventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventViewCell
        
        // Configure the cell...
        if indexPath.row < items.count {
            let p = items[indexPath.row]
            if p.distance != nil{
                EventCell.eventNameLabel?.text = "\(p.distance!)"
                EventCell.eventTimeLabel?.text = "\(p.time!)"
                EventCell.eventDateLabel?.text = "\(p.myEventDate!.date!)"
                EventCell.eventLocationLabel?.text = "\(p.myEventDate!.location!)"
                
            }
        }
        return EventCell
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
    
    
}
