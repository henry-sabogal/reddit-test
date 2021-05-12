//
//  ViewControllerPresenter.swift
//  RedditTest
//
//  Created by Henry Rodríguez on 4/05/21.
//

import Foundation
import Combine

protocol DataViewDelegate:NSObjectProtocol {
    func displayTopList(topList:[TopModel])
}

class ViewControllerPresenter {
    
    private let accessAuthViewModel:AccessAuthViewModel
    private let topViewModel:TopViewModel
    private var cancellable: AnyCancellable?
    private var cancellableTopList: AnyCancellable?
    
    weak private var dataViewDelegate:DataViewDelegate?
    
    init() {
        accessAuthViewModel = AccessAuthViewModel()
        accessAuthViewModel.getAccessToken()
        
        topViewModel = TopViewModel()
        
        self.observeAccessTokenValue()
        self.observePostList()
    }
    
    func setDataViewDelegate(dataViewDelegate:DataViewDelegate){
        self.dataViewDelegate = dataViewDelegate
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
                self?.dataViewDelegate?.displayTopList(topList: topList)
            }
        }
    }
    
}
