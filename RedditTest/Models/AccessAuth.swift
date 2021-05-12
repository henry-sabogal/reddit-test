//
//  AccessAuth.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 4/05/21.
//

import Foundation

struct AccessAuth: Hashable, Codable {
    var tokenType:String
    var accessToken:String
    var expiresIn:Int
    
    enum CodingKeys: String, CodingKey{
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}
