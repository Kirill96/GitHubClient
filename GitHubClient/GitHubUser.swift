//
//  GitHubUser.swift
//  GitHubClient
//
//  Created by Kirill on 24.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import Foundation

class GitHubUser {
    
    let userLogin: String?
    let userName: String?
    let userEmail: String?
    let userLocation: String?
    let userPublicGistsCount: Int?
    let userPublicRepositoriesCount: Int?
    let userImageUrl: String?
    
    init(userLogin: String?, userName: String?, userEmail: String?, userLocation: String?, userPublicGistsCount: Int?, userPublicRepositoriesCount: Int?, userImageUrl: String?) {
        self.userLogin = userLogin
        self.userName = userName
        self.userEmail = userEmail
        self.userLocation = userLocation
        self.userPublicGistsCount = userPublicGistsCount
        self.userPublicRepositoriesCount = userPublicRepositoriesCount
        self.userImageUrl = userImageUrl
    }
}
