//
//  HexRule.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-15.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

struct HexRule {
    var index: Int
    var ptID: Int
    var ruleX: String
    var ruleY: String
    var ptX: Double
    var ptY: Double
    var offX: Double
    var offY: Double
    
    var absX: Double = 0
    var absY: Double = 0
    
    init(index: Int, ptID: Int, ruleX: String, ruleY: String, ptX: Double, ptY: Double, offX: Double, offY: Double) {
        self.index = index
        self.ptID = ptID
        self.ruleY = ruleY
        self.ruleX = ruleX
        self.ptX = ptX
        self.ptY = ptY
        self.offX = offX
        self.offY = offY
    }
}
