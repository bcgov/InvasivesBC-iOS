//
//  APIRequest.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
enum APIRequestType {
    case Get
    case Post
}

protocol APIRequest {
    static func headers() -> [String : String]
    static func get(endpoint: URL, completion: @escaping (_ response: Any?) -> Void)
    static func post(endpoint: URL, params: [String: Any], completion: @escaping (_ response: Any?) -> Void)
}
