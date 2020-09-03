//
//  SyncActivity.swift
//  InvasivesBC
//
//  Created by Micheal Wells on 2020-08-26.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Alamofire
import GRDB

// MARK: Auth
func getToken() -> String?
{
    guard let token = AuthenticationService.authServices.credentials?.accessToken else { return nil }
    return token
}

// MARK: Call /activity Endpoint
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


// MARK: TRANSFORM DATA TO JSON:

/* Cole's Notes:
 *   If you add a new field to an existing activity type and/or sub type it is included by default.

 *  If you want to exclude or change a field (like an id the API doesn't want) skip to 'Strip fields from JSON' mark or look at how a re-label works for geometries in
    getRelatedLocationAndGeometryAsDictionary (this is also where you would add a new geometry type if it works different than Polygon - the default).
 
 *  If you are adding a new Activity Type or Sub type you need to add queries to the switches in:
        getRelatedActivityTypeDataAsDictionary and getRelatedActivitySubTypeDataAsDictionary
 */


func transformActivityToJSON(input: Activity) -> NSString
{
    // MARK: Setup encoder:
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted,.sortedKeys]
    // to get json dates:
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    //formatter.timeStyle =  .none
    encoder.dateEncodingStrategy = .formatted(formatter)
    
    
    // MARK: DB record to Dictionaries:
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var activityDictionary = encodeToDictionary(record: input, encoder: encoder)
    var activityTypeDataDictionary = getRelatedActivityTypeDataAsDictionary(activity: input, dbQueue: appDelegate.dbQueue, encoder: encoder)
    var activitySubTypeDataDictionary = getRelatedActivitySubTypeDataAsDictionary(activity: input, dbQueue: appDelegate.dbQueue, encoder: encoder)
    var locationAndGeometryDictionary = getRelatedLocationAndGeometryAsDictionary(activity: input, dbQueue: appDelegate.dbQueue, encoder: encoder)
    
    
    // MARK: Strip fields from JSON
    activityDictionary.removeValue(forKey: "local_id")
    activityDictionary.removeValue(forKey: "synched")
    activityDictionary.removeValue(forKey: "synch")
    activityDictionary.removeValue(forKey: "synch_error")
    activityDictionary.removeValue(forKey: "synch_error_string")
    activityTypeDataDictionary.removeValue(forKey: "local_id")
    activitySubTypeDataDictionary.removeValue(forKey: "local_id")
    locationAndGeometryDictionary.removeValue(forKey: "local_id")
    locationAndGeometryDictionary.removeValue(forKey: "local_activity_id")
    
    
    // MARK: Build JSON
    activityDictionary["activityTypeData"] = activityTypeDataDictionary
    activityDictionary["activitySubTypeData"] = activitySubTypeDataDictionary
    activityDictionary["locationAndGeometry"] = locationAndGeometryDictionary
    
    let jsonData = try! JSONSerialization.data(withJSONObject: activityDictionary, options: [.sortedKeys, .prettyPrinted])
    guard let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) else { return "banana" }
    print("activity sent to the API: \(jsonString)")
    return jsonString
}


// MARK: Helper functions
func encodeToDictionary<T: Codable>(record: T, encoder: JSONEncoder) -> Dictionary<String,Any>
{
    let encodedData: Data = try! encoder.encode(record)
    guard var dict = try! JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any] else { return Dictionary<String,Any>() }
    return dict
}


func getRelatedActivityTypeDataAsDictionary(activity: Activity, dbQueue: DatabaseQueue, encoder: JSONEncoder) -> Dictionary<String,Any>
{
    var activityTypeDataDictionary = Dictionary<String,Any>()
    // MARK: New activity types here
       switch activity.activityType {
       case "Observation":
           let relatedObservation = try! dbQueue.read { db in
               try Observation.fetchOne(db,
                                        sql: "SELECT * FROM observation WHERE local_activity_id = ?",
                                        arguments: [activity.local_id])!
           }
          activityTypeDataDictionary = encodeToDictionary(record: relatedObservation, encoder: encoder)
       default:
           print("No such activity type:  \(activity.activityType)")
       }
    return activityTypeDataDictionary
}


func getRelatedActivitySubTypeDataAsDictionary(activity: Activity, dbQueue: DatabaseQueue, encoder: JSONEncoder) -> Dictionary<String,Any>
{
    // MARK: New activity sub types here

    var activitySubTypeDataDictionary = Dictionary<String,Any>()
    switch activity.activitySubType {
    case "Terrestrial Plant":
        let relatedTerrestrialPlantObservation = try! dbQueue.read { db in
            try TerrestrialPlant.fetchOne(db,
                                     sql: "SELECT * FROM terrestrialplant WHERE local_activity_id = ?",
                                     arguments: [activity.local_id])!
        }
        activitySubTypeDataDictionary = encodeToDictionary(record: relatedTerrestrialPlantObservation, encoder: encoder)
    default:
          print("No such activity sub type: \(activity.activitySubType)")
    }
    return activitySubTypeDataDictionary
}


func getRelatedLocationAndGeometryAsDictionary(activity: Activity, dbQueue: DatabaseQueue, encoder: JSONEncoder) -> Dictionary<String,Any>
{
    let relatedLocationAndGeometry = try! dbQueue.read { db in
            try LocationAndGeometry.fetchOne(db,
                                        sql: "SELECT * FROM locationAndGeometry WHERE local_activity_id = ?",
                                        arguments: [activity.local_id])!
           }
    var locationAndGeometryDictionary = encodeToDictionary(record: relatedLocationAndGeometry, encoder: encoder)
    
    // MARK: New geometries here
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
    return locationAndGeometryDictionary
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
