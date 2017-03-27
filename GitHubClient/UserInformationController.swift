//
//  UserInformationController.swift
//  GitHubClient
//
//  Created by Kirill on 22.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit
import SDWebImage

class UserInformationController: UITableViewController {

    let getUserInfo = LoadDataForGitHubUsers.sharedInstance
    var loginFromUsersTable = ""
    var search = false
    
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var countOfPublicGists: UILabel!
    @IBOutlet weak var countPublicRepositories: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogin.text = loginFromUsersTable
        if search {
            for user in getUserInfo.githubSearchUsersInformation {
                if user.userLogin == loginFromUsersTable {
                    userName.text = user.userName
                    userEmail.text = user.userEmail
                    userLocation.text = user.userLocation
                    countOfPublicGists.text = String(describing: user.userPublicGistsCount!)
                    countPublicRepositories.text = String(describing: user.userPublicRepositoriesCount!)
                    
                    if let imageUrlString = user.userImageUrl {
                        let imageUrl = NSURL(string: imageUrlString)
                        userImage.sd_setImage(with: imageUrl as URL?, placeholderImage: UIImage(named: "usersIcon"), options: SDWebImageOptions.refreshCached)
                        
                    }
                }
            }
        } else {
            for user in getUserInfo.githubUsersInformation {
                if user.userLogin == loginFromUsersTable {
                    userName.text = user.userName
                    userEmail.text = user.userEmail
                    userLocation.text = user.userLocation
                    countOfPublicGists.text = String(describing: user.userPublicGistsCount!)
                    countPublicRepositories.text = String(describing: user.userPublicRepositoriesCount!)
                    
                    if let imageUrlString = user.userImageUrl {
                        let imageUrl = NSURL(string: imageUrlString)
                        userImage.sd_setImage(with: imageUrl as URL?, placeholderImage: UIImage(named: "usersIcon"), options: SDWebImageOptions.refreshCached)
                        
                    }
                }
            }
        }
        userImage.layer.cornerRadius = 30.0
        userImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
