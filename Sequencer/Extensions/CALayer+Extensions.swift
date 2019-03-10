//
//  CALayer+Extensions.swift
//  Sequencer
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
