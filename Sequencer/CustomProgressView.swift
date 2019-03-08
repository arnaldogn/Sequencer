//
//  CustomProgressView.swift
//  Sequencer
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit

class CustomProgressView: UISlider {
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 120))
        indicatorView.layer.cornerRadius = 7.5
        indicatorView.backgroundColor = .lightBlue
        indicatorView.layer.borderWidth = 0.25
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
        thumbTintColor = .clear
        backgroundColor = .clear
        tintColor = .clear
        isContinuous = true
        minimumValue = 0
        setThumbImage(indicatorView.asImage(), for: .normal)
    }
}


    
