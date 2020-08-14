//
//  StorageService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-08-14.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class StorageService {
    public static let shared = StorageService()
    
    private init() {}
    
    public func getAllForms(type: ActivityFormType) -> [BaseObject] {
        switch type {
        case .PlantObservation:
            if let query = RealmRequests.getObject(PlantObservationModel.self) {
                return query
            } else {
                return []
            }
        case .PlantTreatment:
            return []
        case .PlantMonitoring:
            return []
        case .AnimalObservation:
            return []
        case .AnimalTreatment:
            return []
        case .AnimalMonitoring:
            return []
        }
    }
}
