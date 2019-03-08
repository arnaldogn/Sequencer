//
//  AudioPlayer.swift
//  Sequencer
//
//  Created by Arnaldo on 3/8/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import AudioToolbox
import AVFoundation

protocol AudioPlayerDelegate: class {
    func didStartPlaying(audioPlayer: AudioPlayer, mediaDuration: TimeInterval)
    func didUpdatePlayTime(audioPlayer: AudioPlayer, currentTime: TimeInterval)
    func didFinishPlaying(audioPlayer: AudioPlayer)
}

class AudioPlayer: NSObject {
    private let queue: [String]
    private var audioPlayer: AVAudioPlayer?
    private var updater: CADisplayLink?
    weak var delegate: AudioPlayerDelegate?
    private let defaultIndex = 0
    private var currentIndex = 0
    let tag: Int
    var isPlaying: Bool {
        get {
            return audioPlayer?.isPlaying ?? false
        }
    }
    
    init(tag: Int = 0, queue: [String]) {
        self.queue = queue
        self.tag = tag
    }
    
    func playAudioFile(_ index: Int) {
        do {
            updater = CADisplayLink(target: self, selector: #selector(trackAudio))
            updater?.preferredFramesPerSecond = 20
            updater?.add(to: .current, forMode: .common)
            guard let soundURL = Bundle.main.url(forResource: queue[index], withExtension: "wav") else { return }
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            guard let audioPlayer = audioPlayer else { return }
            delegate?.didStartPlaying(audioPlayer: self, mediaDuration: audioPlayer.duration)
        }
        catch { print("error") }
    }
    
    @objc func trackAudio() {
        guard let audioPlayer = audioPlayer else { return }
        delegate?.didUpdatePlayTime(audioPlayer: self, currentTime: audioPlayer.currentTime)
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func playNext() {
        currentIndex = (currentIndex == queue.count - 1) ? 0 : currentIndex + 1
        playAudioFile(currentIndex)
        print("song")
        print(queue[currentIndex])
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func start() {
        playAudioFile(defaultIndex)
    }
    
    func cancel() {
        updater?.invalidate()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if flag {
//            playNext()
//            delegate?.didFinishPlaying(audioPlayer: self)
//        }
    }
}
