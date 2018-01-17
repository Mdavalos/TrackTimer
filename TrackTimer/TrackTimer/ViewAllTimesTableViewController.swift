//
//  ViewAllTimesTableViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/20/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class ViewAllTimesTableViewController: UITableViewController {
    
    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    var timeView: [AthleteTime] = []
    
    var items: [Event] = []
    var items2: [RelayLeg] = []
    
    override func viewDidLoad() {
        moc = coreDataStack.viewContext
        tableView.register(BestTimesCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "BestTimesTableCell", bundle: nil)
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
        let timeSorter = NSSortDescriptor(key: "time", ascending: true)
        let eventSorter = NSSortDescriptor(key: "distance", ascending: true)
        
        // Sort the two types of events and then add to one array
        items = Event.items(for: moc, matching: nil, sortedBy: [eventSorter, timeSorter])
        items2 = RelayLeg.items(for: moc, matching: nil, sortedBy: [eventSorter, timeSorter])
        for i in items {
            if i.time != nil{
            let t = AthleteTime(time: i.time!, athleteName: "\(i.myAthlete!.firstName!) \(i.myAthlete!.lastName!)",
                team: (i.myAthlete?.teamName!)!, info: "\(i.myEventDate!.location!) (\(i.myEventDate!.date!)) ", event: i.distance!)
            timeView.append(t)
            }
        }
        for i in items2 {
            if i.time != nil{
            let t = AthleteTime(time: i.time!, athleteName: "\(i.myAthleteLeg!.firstName!) \(i.myAthleteLeg!.lastName!)",
                team: (i.myAthleteLeg?.teamName!)!, info: "\(i.myRelayEventDate!.location!) (\(i.myRelayEventDate!.date!))", event: i.distance!)
            timeView.append(t)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count + items2.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BestTimesCell
        
        if indexPath.row < timeView.count {
            
            let p = timeView[indexPath.row]
            cell.nameLabel?.text = p.athleteName
            cell.eventTimeLabel.text = "\(p.event)M [\(p.time)]"
            cell.teamLabel.text = p.team
            cell.placeDateLabel.text = p.info
        }
        
        return cell
    }
}
