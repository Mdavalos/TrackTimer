//
//  EventViewCell.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/19/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
}
