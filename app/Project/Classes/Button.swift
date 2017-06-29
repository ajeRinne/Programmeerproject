//
//  Button.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class Button: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            
            self.layer.cornerRadius = cornerRadius
        }
    }
}
