//
//  ProfileController.swift
//  GitHubClient
//
//  Created by Kirill on 22.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileController: UITableViewController {
    
    let loadDataForUserProfile = LoadDataForUserProfile.sharedInstance
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userPrivateGistsCount: UILabel!
    @IBOutlet weak var userTotalPrivateRepoCount: UILabel!
    @IBOutlet weak var userOwnedPrivateRepoCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = loadDataForUserProfile.userInformationForProfile[0].userName
        userLogin.text = loadDataForUserProfile.userInformationForProfile[0].userLogin
        userEmail.text = loadDataForUserProfile.userInformationForProfile[0].userEmail
        userLocation.text = loadDataForUserProfile.userInformationForProfile[0].userLocation
        userPrivateGistsCount.text = String(describing: loadDataForUserProfile.userInformationForProfile[0].userPrivateGistsCount!)
        userTotalPrivateRepoCount.text = String(describing: loadDataForUserProfile.userInformationForProfile[0].userTotalPrivateRepositoriesCount!)
        userOwnedPrivateRepoCount.text = String(describing: loadDataForUserProfile.userInformationForProfile[0].userOwnedPrivateRepositoresCount!)
        
        if let imageUrlString = loadDataForUserProfile.userInformationForProfile[0].userImageUrl {
            let imageUrl = NSURL(string: imageUrlString)
            profileImage.sd_setImage(with: imageUrl as URL?, placeholderImage: UIImage(named: "profileIcon"), options: SDWebImageOptions.refreshCached)
            
        }
        
        profileImage.layer.cornerRadius = 30.0
        profileImage.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
