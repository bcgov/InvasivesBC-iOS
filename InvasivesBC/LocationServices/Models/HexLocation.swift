//
//  HexLocation.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
struct HexLocation {
    var cc: Int
    var ur: Int
    var cr: Int
    var lr: Int
    var ll: Int
    var cl: Int
    var ul: Int
    
    init(cc: Int, ur: Int, cr: Int, lr: Int, ll: Int, cl: Int, ul: Int) {
        self.cc = cc
        self.ur = ur
        self.cr = cr
        self.lr = lr
        self.ll = ll
        self.cl = cl
        self.ul = ul
    }
}
