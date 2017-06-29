//
//  PlacesCell.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit

class PlacesCell: UITableViewCell {

    @IBOutlet var placeTextField: UILabel!
    @IBOutlet var addedByTextField: UILabel!
    @IBOutlet var placePictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
