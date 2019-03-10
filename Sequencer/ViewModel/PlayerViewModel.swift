//
//  PlayerViewModel.swift
//  Sequencer
//
//  Created by Arnaldo on 3/8/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import AudioToolbox
import AVFoundation

typealias Bar = Int

protocol PlayerViewModelProtocol {
    var delegate: MTIDelegate? { get set }
    var repeatingTime: TimeInterval { get }
    var timeFrame: TimeInterval { get }
    func mti(from time: TimeInterval) -> String
    func barsToSeconds(bars: Bar) -> TimeInterval
}

class PlayerViewModel: PlayerViewModelProtocol {
    static let microloopRate: Bar = 2
    private var mti: MTIProtocol
    weak var delegate: MTIDelegate? {
        didSet {
            mti.delegate = delegate
        }
    }
    var repeatingTime: TimeInterval {
        get {
            return barsToSeconds(bars: PlayerViewModel.microloopRate)
        }
    }
    var timeFrame: TimeInterval {
        return TimeInterval(1)/Double(Constants.refreshRate)
    }
    
    init(mti: MTIProtocol) {
        self.mti = mti
    }
    
    func mti(from time: TimeInterval) -> String {
        mti.update(timeInterval: time)
        return mti.stringValue
    }
  
    func barsToSeconds(bars: Bar) -> TimeInterval {
        return mti.barsToSeconds(bars: bars)
    }
}
