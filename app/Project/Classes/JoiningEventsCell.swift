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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
