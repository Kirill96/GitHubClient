//
//  UserProfile.swift
//  GitHubClient
//
//  Created by Kirill on 23.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import Foundation

class UserProfile {
    
    let userLogin: String?
    let userName: String?
    let userEmail: String?
    let userLocation: String?
    let userPrivateGistsCount: Int?
    let userTotalPrivateRepositoriesCount: Int?
    let userOwnedPrivateRepositoresCount: Int?
    let userRepositoriesUrl: String?
    let userImageUrl: String?
    
    init(userLogin: String?, userName: String?, userEmail: String?, userLocation: String?, userPrivateGistsCount: Int?, userTotalPrivateRepositoriesCount: Int?, userOwnedPrivateRepositoresCount: Int?, userRepositoriesUrl: String?, userImageUrl: String?) {
        self.userLogin = userLogin
        self.userName = userName
        self.userEmail = userEmail
        self.userLocation = userLocation
        self.userPrivateGistsCount = userPrivateGistsCount
        self.userTotalPrivateRepositoriesCount = userTotalPrivateRepositoriesCount
        self.userOwnedPrivateRepositoresCount = userOwnedPrivateRepositoresCount
        self.userRepositoriesUrl = userRepositoriesUrl
        self.userImageUrl = userImageUrl
    }
}
