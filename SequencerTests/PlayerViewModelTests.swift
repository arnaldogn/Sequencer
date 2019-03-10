//
//  PlayerViewModelTests.swift
//  SequencerTests
//
//  Created by Arnaldo on 3/7/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import XCTest
@testable import Sequencer

class FakeMTI: MTIProtocol {
    var bars: Int = 0
    var beats: Int = 0
    var sixteenths: Int = 0
    var delegate: MTIDelegate?
    var stringValue: String = "5:3:1"
    
    func update(timeInterval: TimeInterval) {}
    
    func barsToSeconds(bars: Bar) -> TimeInterval {
        return 200
    }
    
}

class PlayerViewModelTests: XCTestCase {
    
    var viewModel: PlayerViewModelProtocol?

    override func setUp() {
        viewModel = PlayerViewModel(mti: FakeMTI())
    }

    override func tearDown() {
        viewModel = nil
    }
    
    func testMTIStringFromInterval() {
        XCTAssertEqual(viewModel?.mti(from: 0), "5:3:1")
    }

    func testBarsToSeconds() {
        XCTAssertEqual(viewModel?.barsToSeconds(bars: 2), 200)
    }
}
