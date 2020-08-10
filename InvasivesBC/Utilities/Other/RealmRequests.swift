//
//  RealmRequest.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct RealmRequests {

    static func saveObject<T: Object>(object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            print("Error while saving realm object")
            print(error)
        }
    }
    
    static func updateObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch let error as NSError {
            print("Error while upadating realm object")
            print(error)
        }
    }

    static func deleteObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            print("Error while deleting realm object")
            print(error)
        }
    }

    static func getObject<T: Object>(_ object: T.Type) -> [T]? {
        do {
            let realm = try Realm()
            let objs = realm.objects(object).map { $0 }
            return Array(objs)
        } catch let error as NSError {
            print("Error while getting realm object")
            print(error)
        }
        return nil
    }
}
