//
//  CodeObject.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CodeObject: Object {
    @objc dynamic var localId: String = {
        return UUID().uuidString
    }()
    
    override class func primaryKey() -> String? {
        return "localId"
    }
    
    @objc dynamic var des: String = ""
    @objc dynamic var remoteId: Int = -1
}

class CodeTableModel: Object {
    
    @objc dynamic var localId: String = {
        return UUID().uuidString
    }()
    
    override class func primaryKey() -> String? {
        return "localId"
    }
    
    @objc dynamic var type: String = ""
    let items: List<String> = List<String>()
    var codes: List<CodeObject> = List<CodeObject>()
    var provinces: List<CountryProvince> = List<CountryProvince>()
}

class CountryProvince: CodeObject {
    @objc dynamic var province: String = ""
    @objc dynamic var country: String = ""
}
