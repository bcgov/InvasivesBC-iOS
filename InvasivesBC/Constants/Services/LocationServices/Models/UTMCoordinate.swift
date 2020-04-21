//
//  UTMCoordinate.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation

public struct UTMCoordinate {
    var northings: Double
    var eastings: Double
    var zone: Int

    init(northings: Double, eastings: Double, zone: Int) {
        self.northings = northings
        self.eastings = eastings
        self.zone = zone
    }
}
