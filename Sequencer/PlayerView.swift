//
//  PlayerView.swift
//  Sequencer
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit
import SnapKit

protocol PlayerViewDelegate: class {
    func play()
    func playLongPressed()
    func fastForwardPressed(sender: PlayerView.Panel)
}

class PlayerView: UIView {
    enum Panel: Int {
        case left
        case right
    }
    @IBOutlet var leftLed: UIView!
    @IBOutlet var rightLed: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var playBtn: UIButton!
    weak var delegate: PlayerViewDelegate?
    var longPressRecognizer: UILongPressGestureRecognizer?
    var leftPanel = WavePanelView(images: ["A1", "A2", "A3"])
    var rightPanel = WavePanelView(images: ["B1", "B2", "B3"])
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if longPressRecognizer == nil {
            longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(playLongPressed))
            guard let longPressRecognizer = longPressRecognizer else { return }
            playBtn.addGestureRecognizer(longPressRecognizer)
            setupConstraints()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        leftPanel.delegate = self
        rightPanel.delegate = self
        addSubviews(leftPanel,
                    rightPanel)
    }
    
    func setupConstraints() {
        leftPanel.backgroundColor = .red
        leftPanel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(playBtn.snp.top).offset(-50)
        }
        rightPanel.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.height.width.equalTo(leftPanel)
            make.leading.equalTo(leftPanel.snp.trailing).offset(20)
        }
    }
    
    @objc func playLongPressed() {
    }
    
    func blinkLed(_ panel: Panel) {
        switch panel {
        case .left:
            leftLed.blink()
        case .right:
            rightLed.blink()
        }
    }
    @objc func fastForwardTapped(_ sender: UIButton) {
        guard let btnTag = Panel(rawValue: sender.tag) else { return }
        delegate?.fastForwardPressed(sender: btnTag)
    }
    @IBAction func repeatTapped(_ sender: UIButton) {
    }
}

extension PlayerView: WavePanelViewDelegate {
    func didFastForward(panel: WavePanelView) {
        let tag: Panel = panel.isEqual(leftPanel) ? .left : .right
        delegate?.fastForwardPressed(sender: tag)
    }
}


