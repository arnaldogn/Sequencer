//
//  TimeInterval+Extensions.swift
//  Sequencer
//
//  Created by Arnaldo on 3/8/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toMinutes() -> Float {
        let ti = Float(self)
        let minutes = ti / 60
        return minutes
    }
}
