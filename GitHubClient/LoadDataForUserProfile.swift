//
//  LoadData.swift
//  GitHubClient
//
//  Created by Kirill on 22.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoadDataForUserProfile {
    
    static let sharedInstance = LoadDataForUserProfile()
    
    private init() {}
    
    var userInformationForProfile = [UserProfile]()
    var listOfNameOfRepositories = [String]()
    var firstNumberForPagination = 0
    var secondNumberForPagination = 15
    
    func authorization(user: String, password: String, completion: @escaping (JSON) -> ()) {
        let plainString = "\(user):\(password)" as NSString
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + base64String!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://api.github.com/user", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json)
                self.parseJSON(json: json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parseJSON(json: JSON){
        var userLogin = ""
        var userName = ""
        var userEmail = ""
        var userLocation = ""
        var userPrivateGistsCount = 0
        var userTotalPrivateRepositoriesCount = 0
        var userOwnedPrivateRepositoresCount = 0
        var userRepositoriesUrl = ""
        var userImageUrl = ""
        
        if let login = json["login"].string { userLogin = login }
        if let name = json["name"].string { userName = name }
        if let email = json["email"].string { userEmail = email }
        if let location = json["location"].string { userLocation = location }
        if let privateGistsCount = json["private_gists"].int { userPrivateGistsCount = privateGistsCount }
        if let totalPrivateRepositoriesCount = json["total_private_repos"].int { userTotalPrivateRepositoriesCount = totalPrivateRepositoriesCount }
        if let ownedPrivateRepositoresCount = json["owned_private_repos"].int { userOwnedPrivateRepositoresCount = ownedPrivateRepositoresCount }
        if let repositoriesUrl = json["repos_url"].string { userRepositoriesUrl = repositoriesUrl }
        if let imageUrl = json["avatar_url"].string { userImageUrl = imageUrl }
        
        let userInfo = UserProfile(userLogin: userLogin, userName: userName, userEmail: userEmail, userLocation: userLocation, userPrivateGistsCount: userPrivateGistsCount, userTotalPrivateRepositoriesCount: userTotalPrivateRepositoriesCount, userOwnedPrivateRepositoresCount: userOwnedPrivateRepositoresCount, userRepositoriesUrl: userRepositoriesUrl, userImageUrl: userImageUrl)
        
        userInformationForProfile.append(userInfo)
        
    }
    
    func loadRepositoriesFromUrl(firstNumberForPagination: Int, secondNumberForPagination: Int, reloadData: @escaping () -> Void) {
        Alamofire.request(userInformationForProfile[0].userRepositoriesUrl!).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseRepositoriesFromUrl(json: json, firstNumberForPagination: firstNumberForPagination, secondNumberForPagination: secondNumberForPagination)
                reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parseRepositoriesFromUrl(json: JSON, firstNumberForPagination: Int, secondNumberForPagination: Int) {
        for i in firstNumberForPagination ..< secondNumberForPagination {
            if let nameOfRepository = json[i]["name"].string {
                listOfNameOfRepositories.append(nameOfRepository)
            }
        }
    }
}
