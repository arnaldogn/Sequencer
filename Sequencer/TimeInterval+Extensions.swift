//
//  TimeInterval+Extensions.swift
//  Sequencer
//
//  Created by Arnaldo on 3/8/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toMinutes() -> Int {
        let ti = NSInteger(self)
        let minutes = (ti / 60) % 60
        return minutes
    }
}
