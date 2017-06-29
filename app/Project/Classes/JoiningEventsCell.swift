//
//  JoinginEventsCell.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit

class JoiningEventsCell: UITableViewCell {
   
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var addedByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("check7")
        // Configure the view for the selected state
    }
    
}
