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
    func didFinishMicroLoop()
}

class AudioPlayer: NSObject {
    private let queue: [String]
    private var audioPlayer: AVAudioPlayer?
    private var updater: CADisplayLink?
    weak var delegate: AudioPlayerDelegate?
    private let defaultIndex = 0
    private var currentIndex = 0
    let tag: Int
    var microStartTime: TimeInterval? {
        didSet {
            guard let startTime = microStartTime else { return }
            microEndTime = startTime + 3.84
        }
    }
    var microEndTime: TimeInterval?
    var isMicroloopEnabled = false
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
            updater?.preferredFramesPerSecond = Constants.refreshRate
            updater?.add(to: .current, forMode: .common)
            updater?.isPaused = true
            guard let soundURL = Bundle.main.url(forResource: queue[index], withExtension: "wav") else { return }
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            guard let audioPlayer = audioPlayer else { return }
            delegate?.didStartPlaying(audioPlayer: self, mediaDuration: audioPlayer.duration)
        }
        catch { print("error") }
    }
    
    @objc func trackAudio() {
        startMicroloopIfEnabled()
        delegate?.didUpdatePlayTime(audioPlayer: self, currentTime: audioPlayer?.currentTime ?? 0)
    }
    
    func startMicroloopIfEnabled() {
        guard let audioPlayer = audioPlayer else { return }
        if isMicroloopEnabled,
            let startTime = microStartTime,
            let endTime = microEndTime {
            if Int(audioPlayer.currentTime) == Int(endTime) {
                play(atTime: startTime)
                delegate?.didFinishMicroLoop()
            }
        }
    }
    
    func play() {
        updater?.isPaused = false
        audioPlayer?.play()
    }
    
    func play(atTime: TimeInterval) {
        audioPlayer?.currentTime = atTime
        audioPlayer?.play()
    }
    
    func enqueueNext() {
        updater?.invalidate()
        currentIndex = (currentIndex == queue.count - 1) ? 0 : currentIndex + 1
        playAudioFile(currentIndex)
    }
    
    func pause() {
        updater?.isPaused = true
        audioPlayer?.pause()
    }
    
    func stop() {
        updater?.isPaused = true
        audioPlayer?.stop()
    }
    
    func start() {
        playAudioFile(defaultIndex)
        play()
    }
    
    func cancel() {
        updater?.invalidate()
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.didFinishPlaying(audioPlayer: self)
    }
}
