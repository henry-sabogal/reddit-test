//
//  ViewControllerPresenter.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 4/05/21.
//

import Foundation
import Combine

class ViewControllerPresenter {
    
    private let accessAuthViewModel:AccessAuthViewModel
    private let topViewModel:TopViewModel
    private var cancellable: AnyCancellable?
    private var cancellableTopList: AnyCancellable?
    
    init() {
        accessAuthViewModel = AccessAuthViewModel()
        accessAuthViewModel.getAccessToken()
        
        topViewModel = TopViewModel()
        
        self.observeAccessTokenValue()
        self.observePostList()
    }
    
    func observeAccessTokenValue(){
        cancellable = accessAuthViewModel.$token.sink{ [weak self] accessAuth in
            if accessAuth != "" {
                self?.topViewModel.getTopPosts(token: accessAuth)
            }
        }
    }
    
    func observePostList(){
        cancellableTopList = topViewModel.$topList.sink{ [weak self] topList in
            if topList.count > 0 {
                print(topList)
            }
        }
    }
}
