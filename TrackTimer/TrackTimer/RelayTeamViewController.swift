//
//  RelayTeamViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/23/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class RelayTeamViewController: UIViewController {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var leg1Label: UILabel!
    @IBOutlet weak var leg2Label: UILabel!
    @IBOutlet weak var leg3Label: UILabel!
    @IBOutlet weak var leg4Label: UILabel!
    @IBOutlet weak var leg1TimeLabel: UILabel!
    @IBOutlet weak var leg2TimeLabel: UILabel!
    @IBOutlet weak var leg3TimeLabel: UILabel!
    @IBOutlet weak var leg4TimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
    let coreDataStack = CoreDataStack.shared
    var moc: NSManagedObjectContext! = nil
    var item: RelayLeg?
    var team: [RelayLeg] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = coreDataStack.viewContext
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
        // set the test of the labels
        eventLabel.text = item?.distance
        leg1Label.text = "\(team[0].myAthleteLeg!.firstName!) \(team[0].myAthleteLeg!.lastName!)"
        leg1TimeLabel.text = team[0].time
        leg2Label.text = "\(team[1].myAthleteLeg!.firstName!) \(team[1].myAthleteLeg!.lastName!)"
        leg2TimeLabel.text = team[1].time
        leg3Label.text = "\(team[2].myAthleteLeg!.firstName!) \(team[2].myAthleteLeg!.lastName!)"
        leg3TimeLabel.text = team[2].time
        leg4Label.text = "\(team[3].myAthleteLeg!.firstName!) \(team[3].myAthleteLeg!.lastName!)"
        leg4TimeLabel.text = team[3].time
        totalTimeLabel.text = item?.totalTime

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func reload() {
        // reload the data in sorted order to display
        let eventPredicate = NSPredicate(format: "distance = %@ AND totalTime = %@ AND myRelayEventDate.date = %@",  (item?.distance!)!, (item?.totalTime!)!, (item?.myRelayEventDate?.date)!)
        let legSorter = NSSortDescriptor(key: "leg", ascending: true)
        team = RelayLeg.items(for: moc, matching: eventPredicate , sortedBy: [legSorter])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
