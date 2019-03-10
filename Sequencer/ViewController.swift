//
//  ViewController.swift
//  Sequencer
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    enum Player: Int {
        case one
        case two
    }
    @IBOutlet weak var playerView: PlayerView!
    let player1 = AudioPlayer(queue: ["A1","A2", "A3"])
    let player2 = AudioPlayer(tag: Player.two.rawValue, queue: ["B1","B2", "B3"])
    var viewModel = Binder.resolve(PlayerViewModelProtocol.self)!
    var isMicroloopEnabled: Bool = false
    var currentTime1: TimeInterval = 0
    var currentTime2: TimeInterval = 0
    var totalTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .customLightGray
        playerView.delegate = self
        player1.delegate = self
        player2.delegate = self
        viewModel.delegate = self
        player1.start()
        player2.start()
        playerView.playBtn.isSelected = true
    }
}

extension ViewController: PlayerViewDelegate {
    func player(from panel: PlayerView.Panel) -> AudioPlayer {
        return panel == .left ? player1 : player2
    }
    
    func didTapRepeat() {
        isMicroloopEnabled = !isMicroloopEnabled
        if isMicroloopEnabled {
            player1.microStartTime = currentTime1
            player2.microStartTime = currentTime2
        }
    }
    
    func didPlayLongPressed() {
        player1.play(atTime: 0)
        player2.play(atTime: 0)
    }
    
    func didTapPlay() {
        if player1.isPlaying, player2.isPlaying {
            player1.pause()
            player2.pause()
        } else {
            player1.play()
            player2.play()
        }
    }
    
    func didTapFastForward(sender: PlayerView.Panel) {
        let selectedPlayer = player(from: sender)
        selectedPlayer.enqueueNext()
        playerView.panel(from: sender).nextImage()
        didTapPlay()
    }
}

extension ViewController: AudioPlayerDelegate {
    func panel(from player: AudioPlayer) -> WavePanelView {
        return player.tag == Player.one.rawValue ? playerView.leftPanel : playerView.rightPanel
    }
    
    func didFinishMicroLoop() {
        totalTime -= viewModel.repeatingTime
    }
    
    func didFinishPlaying(audioPlayer: AudioPlayer) {
    }
    
    func didStartPlaying(audioPlayer: AudioPlayer, mediaDuration: TimeInterval) {
        panel(from: audioPlayer).maxValue = mediaDuration
    }
    
    func didUpdatePlayTime(audioPlayer: AudioPlayer, currentTime: TimeInterval) {
        panel(from: audioPlayer).currentValue = currentTime
        switch audioPlayer.tag {
            case Player.one.rawValue:
            currentTime1 = currentTime
        case Player.two.rawValue:
            currentTime2 = currentTime
        default:
            break
        }
        audioPlayer.isMicroloopEnabled = isMicroloopEnabled
        totalTime += viewModel.timeFrame
        playerView.timeLbl.text = viewModel.mti(from: totalTime)
    }
}

extension ViewController: MTIDelegate {
    func didChangeBeat() {
        playerView.blinkLed(.left)
    }
    
    func didChangeBar() {
        playerView.blinkLed(.right)
    }
}
