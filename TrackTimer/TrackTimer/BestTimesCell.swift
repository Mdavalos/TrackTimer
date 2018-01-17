//
//  BestTimesCell.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/20/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit

class BestTimesCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var placeDateLabel: UILabel!
    
}
