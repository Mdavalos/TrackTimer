//
//  CustomTableViewCell.swift
//  TrackTimer
//
//  Created by Miguel Davalos on 4/6/17.
//  Copyright © 2017 Miguel Davalos. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    
}
