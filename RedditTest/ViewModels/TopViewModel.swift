	//
//  TopViewModel.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 7/05/21.
//

import Foundation
import Combine

class TopViewModel: ObservableObject{
    private let url = URL(string: "https://oauth.reddit.com/r/subreddit/top")!
    private var cancellable: AnyCancellable?
    
    @Published private(set) var topList: [TopModel] = []
    
    func fetchData(token: String){
        let request = createRequest(token: token)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
       

        self.cancellable = session.dataTaskPublisher(for: request)
        .tryMap { output in
            guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                throw HTTPError.statusCode
            }
            return output.data
        }
        .decode(type: Post.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .handleEvents(receiveSubscription: { (subscription) in
            print("Receive subscription")
        }, receiveOutput: { output in
            print("Received output: \(output)")
        }, receiveCompletion: { _ in
            print("receive completion")
        }, receiveCancel: {
            print("Receive cancel")
        }, receiveRequest: { demand in
            print("Receive Request: \(demand)")
        })
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }, receiveValue: { posts in
            print(posts.data.dist)
        })        
    }
    
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
        return TopModel(author: author, createdUTC: createdUTC)
    }
}
