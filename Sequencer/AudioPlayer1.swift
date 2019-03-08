//
//  AudioPlayer1.swift
//  Sequencer
//
//  Created by Arnaldo on 3/8/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import AudioToolbox
import AVFoundation

class HXAudioEngine {
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    
    var digitFileUrl: URL? {
        didSet {
            if let digitUrl = digitFileUrl {
                do {
                    digitAudioFile = try AVAudioFile(forReading: digitUrl)
                } catch let error {
                    print("Error loading Digit file: \(error.localizedDescription)")
                }
            }
        }
    }
    var digitAudioFile: AVAudioFile? {
        didSet {
            if let digitFile = digitAudioFile {
                digitAudioFormat = digitFile.processingFormat
                digitFileBuffer = AVAudioPCMBuffer(pcmFormat: digitFile.processingFormat, frameCapacity: UInt32(digitFile.length))
            }
        }
    }
    var digitFileBuffer: AVAudioPCMBuffer? {
        didSet {
            if let buffer = digitFileBuffer {
                do {
                    try digitAudioFile?.read(into: buffer)
                } catch let error {
                    print("Error loading digit file into buffer: \(error.localizedDescription)")
                }
            }
        }
    }
    var digitAudioFormat: AVAudioFormat?
    var digitPlayer: AVAudioPlayerNode = AVAudioPlayerNode()
    
    func playDigit() {
        let file = "A1"
        digitFileUrl = Bundle.main.url(forResource: file, withExtension: "wav")
        audioEngine.attach(digitPlayer)
        audioEngine.connect(digitPlayer, to: audioEngine.mainMixerNode, format: digitAudioFormat)
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch let error {
            print(error)
        }
        
        guard let digitBuffer = digitFileBuffer else { return }
        guard let digitAudioFile = digitAudioFile else { return }
        
        digitPlayer.scheduleBuffer(digitBuffer, at: nil, options: .interrupts) {
            print("Done playing digit")
        }
        digitPlayer.play()
    }
}

struct Tempo {
    var bpm: Double
    func seconds(duration: Double = 0.25) -> Double {
        return self.bpm * 60 * 4.0 * duration
    }
}

class Test2 {
    var audioUrl = Bundle.main.url(forResource: "A1", withExtension: "wav")
    var offsetTime: AVAudioTime?
    var engine = AVAudioEngine() {
        didSet {
            offsetTime = engine.outputNode.lastRenderTime
        }
    }
    let player = AVAudioPlayerNode()
    let myTempo = Tempo(bpm: 120)
    
    var currentPositionInSeconds: TimeInterval {
        get {
            guard let lastRenderTime = engine.outputNode.lastRenderTime,
            let offsetTime = offsetTime
            else { return 0 }
            let frames = lastRenderTime.sampleTime - offsetTime.sampleTime
            return Double(frames) / offsetTime.sampleRate
        }
    }
    
    var currentPositionInBeats: TimeInterval {
        get {
            return currentPositionInSeconds/myTempo.seconds()
        }
    }
    
    init() {
        
        // Do any additional setup after loading the view.
        
        engine.attach(player)
        
        let audioFile = try! AVAudioFile(forReading: audioUrl!)
        
        engine.connect(player, to: engine.mainMixerNode, format: audioFile.processingFormat)
        player.scheduleFile(audioFile, at: nil) {
            let position = self.currentPositionInBeats
            let bars = Int(floor(position / 4))
            
            let beats = Int(floor(position.truncatingRemainder(dividingBy: 4)))
            print("Algo \(bars).\(beats)")
        }
        try! engine.start()
        
       
        
        
        
    }
    
    func start() {
        player.play()
    }
    
    func addFile() {
        var audioUrl = Bundle.main.url(forResource: "A2", withExtension: "wav")
        let audioFile = try! AVAudioFile(forReading: audioUrl!)
        player.scheduleFile(audioFile, at: nil, completionHandler: nil)
    }
    

}
