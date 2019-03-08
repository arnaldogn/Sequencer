//
//  UIView+Extensions.swift
//  Sequencer
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit

extension UIView {
    func blink() {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.alpha = 0.0
        })
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
