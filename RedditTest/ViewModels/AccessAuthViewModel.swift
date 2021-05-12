//
//  AccessAuthViewModel.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 4/05/21.
//

import Foundation
import Combine

enum HTTPError: LocalizedError {
    case statusCode
}

class AccessAuthViewModel: ObservableObject {
    
    private let url = URL(string: "https://www.reddit.com/api/v1/access_token/")!
    private let param = "grant_type=client_credentials"
    private var cancellable: AnyCancellable?
    
    @Published private(set) var token: String = ""
    
    func getAccessToken(){
        let request = createRequest()
        let delegate = HTTPBasicAuthentication()
        let sessionAuth = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
        
        self.cancellable = sessionAuth.dataTaskPublisher(for: request)
            .tryMap{ output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else{
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: AccessAuth.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    break
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }, receiveValue: { accessAuth in
                self.token = accessAuth.accessToken
            })
    }
    
    func createRequest() -> URLRequest{
        let httpBody = param.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("MyTest/0.0.1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
