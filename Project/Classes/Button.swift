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
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet{
//            self.layer.borderWidth = borderWidth
//            
//        }
//    }
//    @IBInspectable var borderColor: UIColor = UIColor.yellow {
//        didSet{
//            self.layer.borderColor = borderColor.cgColor
//            
//        }
//    }
    
    
}
