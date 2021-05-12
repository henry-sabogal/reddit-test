//
//  TopModel.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 9/05/21.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let data: PostData
}

// MARK: - WelcomeData
struct PostData: Codable {
    let dist: Int
    let children: [Child]
}

// MARK: - Child
struct Child: Codable {
    let data: ChildData
}

// MARK: - ChildData
struct ChildData: Codable {
    let author: String
    let createdUTC: Int

    enum CodingKeys: String, CodingKey {
        case author
        case createdUTC = "created_utc"
    }
}

struct TopModel{
    var author:String
    var createdUTC:Int
    
    var createdString:String{
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .short
        utcDateFormatter.timeStyle = .short
        utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = Date(timeIntervalSince1970: Double(createdUTC))
        
        return utcDateFormatter.string(from: date)
    }
}
