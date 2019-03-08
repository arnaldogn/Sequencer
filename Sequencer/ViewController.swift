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
    let player1 = AudioPlayer(queue: ["A1","A2", "A3"])
    let player2 = AudioPlayer(tag: Player.two.rawValue, queue: ["B1","B2", "B3"])
    let audio = Test2()
    
    @IBOutlet weak var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        player1.delegate = self
        player2.delegate = self
//        player1.start()
//        player2.start()
        
        
       
        
        audio.start()
    }
}

extension ViewController: PlayerViewDelegate {
    func playLongPressed() {
        
    }
    
    func play() {
        if player1.isPlaying, player2.isPlaying {
            player1.pause()
            player2.pause()
        } else {
            player1.play()
            player2.play()
        }
    }
    
    func fastForwardPressed(sender: PlayerView.Panel) {
        switch sender {
        case .left:
            player1.playNext()
            playerView.leftPanel.nextImage()
        case .right:
            player2.playNext()
            playerView.rightPanel.nextImage()
        }
    }
}

extension ViewController: AudioPlayerDelegate {
    func didFinishPlaying(audioPlayer: AudioPlayer) {
        switch audioPlayer.tag {
        case Player.one.rawValue:
            playerView.leftPanel.nextImage()
        case Player.two.rawValue:
            playerView.rightPanel.nextImage()
        default:
            break
        }
    }
    
    func didStartPlaying(audioPlayer: AudioPlayer, mediaDuration: TimeInterval) {
        switch audioPlayer.tag {
        case Player.one.rawValue:
            playerView.leftPanel.maxValue = mediaDuration
        case Player.two.rawValue:
            playerView.rightPanel.maxValue = mediaDuration
        default:
            break
        }
    }
    
    func didUpdatePlayTime(audioPlayer: AudioPlayer, currentTime: TimeInterval) {
        switch audioPlayer.tag {
            case Player.one.rawValue:
            playerView.leftPanel.currentValue = currentTime
        case Player.two.rawValue:
            playerView.rightPanel.currentValue = currentTime
        default:
            break
        }
    }
}
