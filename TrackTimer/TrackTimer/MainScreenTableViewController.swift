//
//  TestTableViewController.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/20/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit
import CoreData

class MainScreenTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //keep user from scrolling on main page
        tableView.alwaysBounceVertical = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 

}
