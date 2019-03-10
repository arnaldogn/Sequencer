//
//  MTI.swift
//  Sequencer
//
//  Created by Arnaldo on 3/10/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Foundation

protocol MTIDelegate: class {
    func didChangeBeat()
    func didChangeBar()
}

protocol MTIProtocol {
    var bars: Int { get }
    var beats: Int { get }
    var sixteenths: Int { get }
    var delegate: MTIDelegate? { get set }
    var stringValue: String { get }
    func update(timeInterval: TimeInterval)
    func barsToSeconds(bars: Bar) -> TimeInterval
}

class MTI: MTIProtocol {
    static let beatsPerMinute: Float = 125
    static let beatsPerBars: Float = 4
    static let sixteenthsPerBeat: Float = 4
    
    var bars: Int = 0 {
        didSet {
            if bars != oldValue {
                delegate?.didChangeBar()
            }
        }
    }
    var beats: Int = 0 {
        didSet {
            if beats != oldValue {
                delegate?.didChangeBeat()
            }
        }
    }
    var sixteenths: Int = 0
    weak var delegate: MTIDelegate?
    var stringValue: String {
        get {
            return "\(bars):\(beats):\(sixteenths)"
        }
    }
    
    func update(timeInterval: TimeInterval) {
        let totalSixteenths = timeInterval.toMinutes() * MTI.beatsPerMinute * MTI.sixteenthsPerBeat
        let partial = totalSixteenths / MTI.sixteenthsPerBeat
        bars = Int(partial) / Int(MTI.beatsPerBars)
        beats =  Int(partial.truncatingRemainder(dividingBy: MTI.beatsPerBars))
        sixteenths = Int(totalSixteenths.truncatingRemainder(dividingBy: MTI.sixteenthsPerBeat))
    }
    
    func barsToSeconds(bars: Bar) -> TimeInterval {
        return TimeInterval((Float(bars * 60) * MTI.beatsPerBars) / MTI.beatsPerMinute)
    }
}
