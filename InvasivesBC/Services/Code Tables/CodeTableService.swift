//
//  CodeTableService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-30.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CodeTableService {
    public static let shared = CodeTableService()
    
    private init() {}
    
    public func download(completion: @escaping (_ success: Bool)-> Void) {
        guard let endpoint = URL(string: APIURL.codes) else {return}
        APIService.get(endpoint: endpoint) { (_result) in
            guard let result = _result as? [String: Any] else {return completion(false)}
            guard let data = result["data"] as? [String: Any] else {return completion(false)}
            self.deleteAll()
            for (key, value) in data {
                let model = CodeTableModel()
                model.type = key
                guard let codesJSON = value as? [[String: Any]] else {continue}
                for code in codesJSON {
                    guard let description = code["description"] as? String else {continue}
                    let codeModel = CodeObject()
                    codeModel.des = description
                    for (k, _) in code where k.contains("_id") {
                        if let id = code[k] as? Int {
                            codeModel.remoteId = id
                        }
                    }
                    model.codes.append(codeModel)
                    model.items.append(description)
                }
                RealmRequests.saveObject(object: model)
            }
            return completion(true)
        }
    }
    
    private func deleteAll() {
        if let query = RealmRequests.getObject(CodeTableModel.self) {
            for object in query {
                RealmRequests.deleteObject(object)
            }
        } else {
            return
        }
    }
    
    public func getAll() -> [CodeTableModel] {
        if let query = RealmRequests.getObject(CodeTableModel.self) {
            return query
        } else {
            return []
        }
    }
    
    public func get(type: String) -> CodeTableModel? {
        guard let realm = try? Realm(), let object = realm.objects(CodeTableModel.self).filter("type = %@", type).first else {
            return nil
        }
        return object
    }
    
    public func getCodeObjects(type: String) -> [CodeObject] {
        guard let model = get(type: type) else {return []}
        var objects: [CodeObject] = []
        for object in model.codes {
            objects.append(object)
        }
        return objects
    }
    
    public func getDropdowns(type: String) -> [DropdownModel] {
        let codes = getCodeObjects(type: type)
        var objects: [DropdownModel] = []
        for object in codes {
            objects.append(DropdownModel(display: object.des))
        }
        return objects
    }
    
    func getAllDropdownNames() -> [String] {
        let all = getAll()
        return all.map({$0.type})
    }
}
