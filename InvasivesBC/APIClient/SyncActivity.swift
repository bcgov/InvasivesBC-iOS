//
//  SyncActivity.swift
//  InvasivesBC
//
//  Created by Nancy Mac Air on 2020-08-26.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Alamofire

func getToken() -> String?
{
    guard let token = AuthenticationService.authServices.credentials?.accessToken else { return nil }
    return token
}


func uploadActiitycompletion(activity: Activity) {
guard let url = URL(string: "https://invasivesbc-api-mobile-831-8ecbmv-dev.pathfinder.gov.bc.ca/api/activity") else {
  return
}
    
let headers: HTTPHeaders = [
    "Authorization": "Bearer " + getToken()! ?? "tokenExpired",
        "Accept": "application/json",
        "ContentType": "application/json"
]
    

    let thisReq = Alamofire.request(url,
                  method: Alamofire.HTTPMethod.post,
                  parameters: convertStringToDictionary(text: sample_request),
                  encoding: JSONEncoding.default,
                  headers: headers
                  )
.validate()
.responseJSON { response in
    
    
  guard response.result.isSuccess else {
    print("ErrorBanana")
    print("responseBanana\(response.result.value as? [String: Any])")
    print("ErrorBanana\(response.error)")
   
    return
  }
   // debugPrint(thisReq)
    
  
    //print("responseBanana\(response.result.value as? [String: Any])")
  
    }
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

let sample_request = """
{
    "activityType": "Observation",
    "activitySubType": "Terrestrial Invasive Plant",
    "date": "2019-04-12",
    "deviceRequestUID": "string",
    "locationAndGeometry": {
        "anchorPointY": 0,
        "anchorPointX": 0,
        "area": 0,
        "geometry": {},
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