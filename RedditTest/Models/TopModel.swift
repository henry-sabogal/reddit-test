//
//  TopModel.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 9/05/21.
//

import Foundation

enum URLImageError:Error{
    case invalidURL
}

struct TopModel{
    var author:String
    var createdUTC:Int
    var title:String
    var thumbnail:String
    var preview:String
    var numComments:Int
    
    var createdString:String{
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .short
        utcDateFormatter.timeStyle = .short
        utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = Date(timeIntervalSince1970: Double(createdUTC))
        
        return utcDateFormatter.string(from: date)
    }
    
    func getURLThumbnail() throws -> URL {
        guard let url = URL(string: thumbnail), thumbnail != "self", thumbnail != "default", thumbnail != "nsfw" else {
            throw URLImageError.invalidURL
        }
        return url
    }
    
    func getURLPreview() throws -> URL {
        guard let url = URL(string: preview), preview != "self", preview != "default", preview != "nsfw" else {
            throw URLImageError.invalidURL
        }
        return url
    }
    
    func getURLImage() throws -> URL{
        if let url = try? self.getURLThumbnail() {
            return url
        }
        
        if let url = try? self.getURLPreview() {
            return url
        }
        
        throw URLImageError.invalidURL
    }
    
}
