//
//  APIService.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService: APIRequest {
    static func headers() -> [String : String] {
        if let token = AuthenticationService.getAccessToken() {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return ["Content-Type": "application/json"]
        }
    }
    
    static func get(endpoint: URL, completion: @escaping (Any?) -> Void) {
        // Manual 20 second timeout for each call
        var completed = false
        var timedOut = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            if !completed {
                timedOut = true
                print("Request Time Out")
                return completion(nil)
            }
        }
        
        let configuration = URLSessionConfiguration.default
        // disable default credential store
        configuration.urlCredentialStorage = nil
        _ = Alamofire.SessionManager(configuration: configuration)
        
        // Make the call
        _ = Alamofire.request(endpoint, method: .get, headers: headers()).responseData { (response) in
            completed = true
            if timedOut {return}
            
            guard response.result.description == "SUCCESS", let value = response.result.value else {
                return completion(nil)
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: value, options: []) as? [String: Any] else {
                    return completion(nil)
                }
                if let error = json["error"] as? String {
                    print("GET call rejected:")
                    print("Endpoint: \(endpoint)")
                    print("Error: \(error)")
                    return completion(nil)
                } else {
                    // Success
                    return completion(json)
                }
                
            } catch {
                return completion(nil)
            }
        }
    }
    
    static func post(endpoint: URL, params: [String : Any], completion: @escaping (Any?) -> Void) {
        // Manual 20 second timeout for each call
        var completed = false
        var timedOut = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            if !completed {
                timedOut = true
                print("Request Time Out")
                return completion(nil)
            }
        }
        
        // Request
        _ = Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers()).responseJSON { response in
            completed = true
            if timedOut {return}
            guard response.result.description == "SUCCESS", let value = response.result.value else {
                return completion(nil)
            }
            let json = JSON(value)
            if let error = json["error"].string {
                print("POST call rejected:")
                print("Endpoint: \(endpoint)")
                print("Error: \(error)")
                return completion(nil)
            } else {
                // Success
                return completion(json)
            }
        }
    }
}
