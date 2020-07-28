//
//  SSO.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-28.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
struct SSO {
    static var baseUrl: URL {
        return RemoteURLManager.default.keyCloakURL
    }
    
    static let redirectUri = "ibc-ios://client"
    static let clientId = "lucy"
    static let realmName = "dfmlcg7z"
    static var idpHint = ""
}
