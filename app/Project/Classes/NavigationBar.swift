//
//  NavigationBar.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NavigationBar: UINavigationItem {
    
    @IBInspectable var tintColor: UIColor = UIColor.orange {
        didSet{
            self.tintColor = UIColor.orange
        }
    }
}
