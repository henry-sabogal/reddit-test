	//
//  TopViewModel.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 7/05/21.
//

import Foundation
import Combine

class TopViewModel: ObservableObject{
    private let url = URL(string: "https://oauth.reddit.com/r/subreddit/best")!
    private var cancellable: AnyCancellable?
    
    @Published private(set) var topList: [TopModel] = []
    
    func getTopPosts(token: String){
        let request = createRequest(token: token)
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                fatalError("Error: invalid HTTP response code")
            }
            
            guard let data = data else {
                fatalError("Error misssing response data")
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let parse = json as? [String:Any],
                  let firstdata = parse["data"] as? [String:Any],
                  let children = firstdata["children"] as? [[String:Any]] else {
                return
            }

            var topList = [TopModel]()
            children.forEach{ post in
                guard let data = post["data"] as? [String:Any] else{
                    return
                }
                topList.append(self.createTopModel(data: data))
            }
            self.topList = topList
        }
        
        task.resume()
    }
    
    private func createRequest(token: String) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("A toy app", forHTTPHeaderField: "User-Agent")
        request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func createTopModel(data: [String:Any]) -> TopModel{
        let author = data["author"] as? String ?? ""
        let createdUTC = data["created_utc"] as? Int ?? 0
        let title = data["title"] as? String ?? ""
        let thumbnail = data["thumbnail"] as? String ?? ""
        let preview = data["thumbnail"] as? String ?? ""
        let numComments = data["num_comments"] as? Int ?? 0
        
        return TopModel(author: author,
                        createdUTC: createdUTC,
                        title: title,
                        thumbnail: thumbnail,
                        preview: preview,
                        numComments: numComments)
    }
}
