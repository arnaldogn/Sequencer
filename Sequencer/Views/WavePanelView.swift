//
//  WavePanelView.swift
//  Sequencer
//
//  Created by Arnaldo on 3/8/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit
import SnapKit

protocol WavePanelViewDelegate: class {
    func didFastForward(panel: WavePanelView)
}

class WavePanelView: UIView {
    var waveForm: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let progressView = CustomProgressView()
    lazy var fastForwardBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fast_forward"), for: .normal)
        button.addTarget(self, action: #selector(fastForwardTapped(_:)), for: .touchUpInside)
        return button
    }()
    let images: [String]
    var currentIndex = 0
    let defaultIndex = 0
    weak var delegate: WavePanelViewDelegate?
    var maxValue: TimeInterval = 0 {
        didSet {
            progressView.maximumValue = Float(maxValue)
        }
    }
    var currentValue: TimeInterval = 0 {
        didSet {
            progressView.value = Float(currentValue)
        }
    }
    
    init(images: [String]) {
        self.images = images
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubviews(waveForm,
                    progressView,
                    fastForwardBtn)
        waveForm.image = UIImage(named: images[defaultIndex])
        setupConstraints()
    }
    
    func nextImage() {
        currentIndex = (currentIndex == images.count - 1) ? 0 : currentIndex + 1
        waveForm.image = UIImage(named: images[currentIndex])
    }
    
    func setupConstraints() {
        waveForm.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(50)
            make.height.equalTo(100)
        }
        progressView.snp.makeConstraints { (make) in
            make.leading.trailing.centerY.equalTo(waveForm)
        }
        fastForwardBtn.snp.makeConstraints { (make) in
            make.top.equalTo(waveForm.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(40)
        }
    }
    
    @objc func fastForwardTapped(_ sender: UIButton) {
        delegate?.didFastForward(panel: self)
    }
}
