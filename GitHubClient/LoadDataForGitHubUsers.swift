//
//  LoadDataForGitHubUsers.swift
//  GitHubClient
//
//  Created by Kirill on 24.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoadDataForGitHubUsers {
    
    static let sharedInstance = LoadDataForGitHubUsers()
    
    private init() {}
    
    var githubUsersInformation = [GitHubUser]()
    var arrayOfUsersLogin = [String]()
    var arrayOfUsersId = [Int]()
    var firstNumberForPagination = 0
    var secondNumberForPagination = 30
    
    var githubSearchUsersInformation = [GitHubUser]()
    var arrayOfSearchUsersLogin = [String]()
    var firstNumberForPaginationSearch = 0
    var secondNumberForPaginationSearch = 30
    var login = ""
    var password = ""
    
    func getUsersLoginSinceLastUserID(lastId: Int, completionHandler: @escaping () -> Void) {
        
        let plainString = "\(login):\(password)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + base64String!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://api.github.com/users?since=\(lastId)", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.getUsersLoginFromJSON(json: json, search: false)
                completionHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserInformationWithLogin(search: Bool, userLogin: String, completionHandler: @escaping () -> Void) {
        
        let plainString = "\(login):\(password)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + base64String!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://api.github.com/users/\(userLogin)", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.getUserInfoFromJSON(json: json, search: search)
                completionHandler()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUsersFromSearch(searchUser: String, completionHandler: @escaping () -> Void, completionHandler1: @escaping () -> Void) {
        
        
        let plainString = "\(login):\(password)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + base64String!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://api.github.com/search/users?q=\(searchUser)", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.getUsersLoginFromJSON(json: json, search: true)
                completionHandler()
                completionHandler1()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUsersLoginFromJSON(json: JSON, search: Bool) {
        if search {
            let usersCount = json["items"].count
            for userNumber in 0 ..< usersCount {
                if let userLogin = json["items"][userNumber]["login"].string {
                    arrayOfSearchUsersLogin.append(userLogin)
                }
            }
        } else {
            let usersCount = json.count
            for userNumber in 0 ..< usersCount {
                if let userLogin = json[userNumber]["login"].string, let userId = json[userNumber]["id"].int {
                    arrayOfUsersLogin.append(userLogin)
                    arrayOfUsersId.append(userId)
                }
            }
        }
    }
    
    func getUserInfoFromJSON(json: JSON, search: Bool){
        var userLogin = ""
        var userName = ""
        var userEmail = ""
        var userLocation = ""
        var userPublicGistsCount = 0
        var userPublicRepositoriesCount = 0
        var userImageUrl = ""
        
        if let login = json["login"].string { userLogin = login }
        if let name = json["name"].string { userName = name }
        if let email = json["email"].string { userEmail = email }
        if let location = json["location"].string { userLocation = location }
        if let publicGistsCount = json["public_gists"].int { userPublicGistsCount = publicGistsCount }
        if let publicRepositoriesCount = json["public_repos"].int { userPublicRepositoriesCount = publicRepositoriesCount }
        if let imageUrl = json["avatar_url"].string { userImageUrl = imageUrl }
        
        let userInfo = GitHubUser(userLogin: userLogin, userName: userName, userEmail: userEmail, userLocation: userLocation, userPublicGistsCount: userPublicGistsCount, userPublicRepositoriesCount: userPublicRepositoriesCount, userImageUrl: userImageUrl)
        if search {
            githubSearchUsersInformation.append(userInfo)
        } else {
            githubUsersInformation.append(userInfo)
        }
    }
}

