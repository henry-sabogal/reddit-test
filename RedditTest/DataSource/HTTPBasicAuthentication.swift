//
//  HTTPBasicAuthentication.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 4/05/21.
//

import Foundation

class HTTPBasicAuthentication: NSObject, URLSessionTaskDelegate{
    
    let credential:URLCredential
    
    let user = "qNeTSz88SSgEUg"
    let password = "L4Q9wN1tpZXz1p2J5AYdKmOgzaGDXA"
    
    override init() {
        self.credential = URLCredential(user: user,
                                        password: password,
                                        persistence: URLCredential.Persistence.forSession)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, credential)
    }
}
