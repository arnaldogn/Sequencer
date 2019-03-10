//
//  UIView+Extensions.swift
//  Sequencer
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit

extension UIView {
    func blink(color: UIColor = .yellow) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut, .autoreverse], animations: {
            self.backgroundColor = color
        }, completion: { _ in
            self.backgroundColor = .white
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
