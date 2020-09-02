//
//  SyncActivity.swift
//  InvasivesBC
//
//  Created by Micheal Wells on 2020-08-26.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Alamofire

func getToken() -> String?
{
    guard let token = AuthenticationService.authServices.credentials?.accessToken else { return nil }
    return token
}


func uploadActivity(activity: Activity) {
    guard let url = URL(string: "https://api-mobile-dev-invasivesbc.pathfinder.gov.bc.ca/api/activity") else {
        return
    }
    
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer " + getToken()! ?? "tokenExpired",
        "Accept": "application/json",
        "ContentType": "application/json"
    ]
    
    
    let thisReq = Alamofire.request(url,
                                    method: Alamofire.HTTPMethod.post,
                                    parameters: convertStringToDictionary(text: transformActivityToJSON(input: activity) as String),
                                    encoding: JSONEncoding.default,
                                    headers: headers
    )
        .validate()
        .responseJSON { response in
            
            
            guard response.result.isSuccess else {
                print("ErrorBody\(response.data?.json)")
                return
            }
    }
}


// TODO: this can be refactored by nesting GRDB Record Structs vs db linking them.  Would also allow it to be run during a db read/write.
func transformActivityToJSON(input: Activity) -> NSString
{
    // used to convert GRDB structs/tables to dictionaries
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted,.sortedKeys]
    // to get json dates:
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    //formatter.timeStyle =  .none
    encoder.dateEncodingStrategy = .formatted(formatter)
    
    
    // get activity struct as a copy of a dictionary to make it easy to edit
    let encodedActivityData: Data = try! encoder.encode(input)
    guard var activityDictionary = try! JSONSerialization.jsonObject(with: encodedActivityData, options: .allowFragments) as? [String: Any] else {
        return "Unable to encode Activity"
    }
    
    // get related Activity Type Instance (Observation, Treatment, Monitoring)
    // start with getting db connection:
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // get the right Activity Type instance and encode it
    var encodedActivityTypeData: Data = Data()
    switch input.activityType {
    case "Observation":
        let relatedObservation = try! appDelegate.dbQueue.read { db in
            try Observation.fetchOne(db,
                                     sql: "SELECT * FROM observation WHERE local_activity_id = ?",
                                     arguments: [input.local_id])!
        }
        encodedActivityTypeData = try! encoder.encode(relatedObservation)
    default:
        print("banana")
    }
    
    //get that as a dictionary
    guard var activityTypeDataDictionary = try! JSONSerialization.jsonObject(with: encodedActivityTypeData, options: .allowFragments) as? [String: Any] else {
        return "Unable to encode ActivityTypeData"
    }
    
    // get the right Activity Type instance and encode it
    var encodedActivitySubTypeData: Data = Data()
    switch input.activitySubType {
    case "Terrestrial Plant":
        let relatedTerrestrialPlantObservation = try! appDelegate.dbQueue.read { db in
            try TerrestrialPlant.fetchOne(db,
                                     sql: "SELECT * FROM terrestrialplant WHERE local_activity_id = ?",
                                     arguments: [input.local_id])!
        }
        encodedActivitySubTypeData = try! encoder.encode(relatedTerrestrialPlantObservation)
    default:
        print("banana")
    }
    
    //get that as a dictionary
    guard var activitySubTypeDataDictionary = try! JSONSerialization.jsonObject(with: encodedActivitySubTypeData, options: .allowFragments) as? [String: Any] else {
        return "Unable to encode ActivitySubTypeData"
    }
    
    
    var encodedLocationAndGeometryData: Data = Data()
       
    let relatedLocationAndGeometry = try! appDelegate.dbQueue.read { db in
            try LocationAndGeometry.fetchOne(db,
                                        sql: "SELECT * FROM locationAndGeometry WHERE local_activity_id = ?",
                                        arguments: [input.local_id])!
           }
    encodedLocationAndGeometryData = try! encoder.encode(relatedLocationAndGeometry)

       
       
       //get that as a dictionary
    guard var locationAndGeometryDictionary = try! JSONSerialization.jsonObject(with: encodedLocationAndGeometryData, options: .allowFragments) as? [String: Any] else {
        return "Unable to encode LocationAndGeometryData"
    }
    
    
    
    //TODO come up with a scheme to filter these based on naming or other attribute
    // strip out fields we don't want in request
    activityDictionary.removeValue(forKey: "local_id")
    activityDictionary.removeValue(forKey: "synched")
    activityDictionary.removeValue(forKey: "synch")
    activityDictionary.removeValue(forKey: "synch_error")
    activityDictionary.removeValue(forKey: "synch_error_string")
    activityTypeDataDictionary.removeValue(forKey: "local_id")
    activitySubTypeDataDictionary.removeValue(forKey: "local_id")
    
    locationAndGeometryDictionary.removeValue(forKey: "local_id")
    locationAndGeometryDictionary.removeValue(forKey: "local_activity_id")
    
    
    //relabel poly / point for the api
    switch relatedLocationAndGeometry.geometry.type
    {
    case "Point":
        if var pointGeom = locationAndGeometryDictionary["geometry"] as! [String: AnyObject]?
        {
            
            pointGeom["coordinates"] = pointGeom["coordinates_Point"]
            pointGeom.removeValue(forKey: "coordinates_Point")
            locationAndGeometryDictionary["geometry"] = pointGeom
        }
    default :
        if var pointGeom = locationAndGeometryDictionary["geometry"] as! [String: AnyObject]?
        {
            
            pointGeom["coordinates"] = pointGeom["coordinates_Poly"]
            pointGeom.removeValue(forKey: "coordinates_Poly")
            locationAndGeometryDictionary["geometry"] = pointGeom
        }
    }
    
    // nest the objects as they need to be for the POST:
    activityDictionary["activityTypeData"] = activityTypeDataDictionary
    activityDictionary["activitySubTypeData"] = activitySubTypeDataDictionary
    
    
    activityDictionary["locationAndGeometry"] = locationAndGeometryDictionary
    
    let jsonData = try! JSONSerialization.data(withJSONObject: activityDictionary, options: [.sortedKeys, .prettyPrinted])
    guard let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) else { return "banana" }
    print("activity sent to the API: \(jsonString)")
    return jsonString
}


func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: .utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

let sample_request = """
{
  "activityType": "Observation",
  "activitySubType": "Terrestrial Invasive Plant",
  "date": "2019-04-12",
  "deviceRequestUID": "string",
  "locationAndGeometry": {
    "anchorPointY": 48.3,
    "anchorPointX": -125.6,
    "area": 0,
    "geometry": {
        "type": "Feature",
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [-125.6, 48.3],[-126.6, 48.3],[-126.6, 49.3],[-125.6, 48.3]
            ]
          ]},
         "properties": {}
    },
    "jurisdiction": "string",
    "agency": "string",
    "observer1FirstName": "string",
    "observer1LastName": "string",
    "locationComment": "string",
    "generalComment": "string",
    "photoTaken": true
  },
  "activityTypeData": {
    "negative_observation_ind": false,
    "aquatic_observation_ind": false,
    "primary_user_last_name": "mike",
    "secondary_user_first_name": "mike",
    "secondary_user_last_name": "mike",
    "species": "banana",
    "primary_file_id": "test",
    "secondary_file_id": "test",
    "location_comment": "test",
    "general_observation_comment": "general comment",
    "sample_taken_ind": true,
    "sample_label_number": "string"
  },
  "activitySubTypeData": {
    "species": "banana",
    "distribution": 123,
    "density": 123,
    "soil_texture": 1,
    "slope": 123,
    "aspect": 123,
    "flowering": true,
    "specific_use": 123,
    "proposed_action": 123,
    "seed_stage": 123,
    "plant_health": 123,
    "plant_life_stage": 123,
    "early_detection": 1,
    "research": true,
    "well_on_site_ind": true,
    "special_care_ind": true,
    "biological_care_ind": true,
    "legacy_site_ind": true,
    "range_unit": "Canyon"
  }
}

"""
