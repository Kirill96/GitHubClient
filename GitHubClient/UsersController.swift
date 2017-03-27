//
//  UsersController.swift
//  GitHubClient
//
//  Created by Kirill on 22.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit
import SDWebImage
import UIScrollView_InfiniteScroll

class UsersController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let myActivityIndicator = UIActivityIndicatorView()
    
    let loadUsers = LoadDataForGitHubUsers.sharedInstance
    var lastId = 0
    var searchActive = false
    var searchLogin = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
        searchBar.delegate = self
        
        self.usersTableView.addSubview(self.refreshControl)
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(myActivityIndicator)
        
        loadUsers.arrayOfSearchUsersLogin.removeAll()
        loadUsers.githubSearchUsersInformation.removeAll()
        
        if loadUsers.arrayOfUsersLogin.isEmpty {
            loadUsers.getUsersLoginSinceLastUserID(lastId: self.lastId, completionHandler: {self.getInfo(firstNumberForPagination: self.loadUsers.firstNumberForPagination, secondNumberForPagination: self.loadUsers.secondNumberForPagination, search: false)})
        }
        
        usersTableView.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tap_searchBar(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUserInformation" {
            let tableWithInfo = segue.destination as! UserInformationController
            if let indexPath = usersTableView.indexPathForSelectedRow {
                let currentCell = usersTableView.cellForRow(at: indexPath) as! UserTableViewCell
                if let userLogin = currentCell.usersName.text {
                    tableWithInfo.loginFromUsersTable = userLogin
                    tableWithInfo.search = searchActive
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return loadUsers.githubSearchUsersInformation.count
        }else{
            return loadUsers.githubUsersInformation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        self.myActivityIndicator.stopAnimating()
        if searchActive {
            if let imageUrlString = loadUsers.githubSearchUsersInformation[indexPath.row].userImageUrl {
                let imageUrl = NSURL(string: imageUrlString)
                cell.usersImage.sd_setImage(with: imageUrl as URL?, placeholderImage: UIImage(named: "usersIcon"), options: SDWebImageOptions.refreshCached)
            }
            cell.usersName.text = loadUsers.githubSearchUsersInformation[indexPath.row].userLogin
            
        }else{
            if let imageUrlString = loadUsers.githubUsersInformation[indexPath.row].userImageUrl {
                let imageUrl = NSURL(string: imageUrlString)
                cell.usersImage.sd_setImage(with: imageUrl as URL?, placeholderImage: UIImage(named: "usersIcon"), options: SDWebImageOptions.refreshCached)
            }
            cell.usersName.text = loadUsers.githubUsersInformation[indexPath.row].userLogin
        }
        
        cell.usersImage.layer.cornerRadius = 30.0
        cell.usersImage.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchActive {
            if indexPath.row == loadUsers.secondNumberForPaginationSearch - 1 {
                loadUsers.firstNumberForPaginationSearch = loadUsers.secondNumberForPaginationSearch
                loadUsers.secondNumberForPaginationSearch += 30
                loadUsers.getUsersFromSearch(searchUser: searchLogin, completionHandler: {self.getInfo(firstNumberForPagination: self.loadUsers.firstNumberForPaginationSearch, secondNumberForPagination: self.loadUsers.secondNumberForPaginationSearch, search: true)}, completionHandler1: {self.usersTableView.reloadData()})
            }
        } else {
            if indexPath.row == loadUsers.secondNumberForPagination - 1 {
                lastId = loadUsers.arrayOfUsersId.last!
                loadUsers.firstNumberForPagination = loadUsers.secondNumberForPagination
                loadUsers.secondNumberForPagination += 30
                loadUsers.getUsersLoginSinceLastUserID(lastId: lastId, completionHandler: {self.getInfo(firstNumberForPagination: self.loadUsers.firstNumberForPagination, secondNumberForPagination: self.loadUsers.secondNumberForPagination, search: false)})
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(UsersController.handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.usersTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getInfo(firstNumberForPagination: Int, secondNumberForPagination: Int, search: Bool) {
        if search {
            let leftLimit = firstNumberForPagination
            var rightLimit = secondNumberForPagination
            let count = loadUsers.arrayOfSearchUsersLogin.count
            if secondNumberForPagination > count {
                rightLimit = count
            }
            self.myActivityIndicator.startAnimating()
            for number in leftLimit ..< rightLimit {
                let login = loadUsers.arrayOfSearchUsersLogin[number]
                loadUsers.getUserInformationWithLogin(search: true, userLogin: login, completionHandler: {self.usersTableView.reloadData()})
            }
            
        } else {
            let leftLimit = firstNumberForPagination
            var rightLimit = secondNumberForPagination
            let count = loadUsers.arrayOfUsersLogin.count
            if secondNumberForPagination > count {
                rightLimit = count
            }
            self.myActivityIndicator.startAnimating()
            for number in leftLimit ..< rightLimit {
                let login = loadUsers.arrayOfUsersLogin[number]
                loadUsers.getUserInformationWithLogin(search: false, userLogin: login, completionHandler: {self.usersTableView.reloadData()})
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        loadUsers.arrayOfSearchUsersLogin.removeAll()
        loadUsers.githubSearchUsersInformation.removeAll()
        usersTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        loadUsers.arrayOfSearchUsersLogin.removeAll()
        loadUsers.githubSearchUsersInformation.removeAll()
        usersTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = true
        if let searchText = searchBar.text {
            searchLogin = searchText
            loadUsers.getUsersFromSearch(searchUser: searchLogin, completionHandler: {self.getInfo(firstNumberForPagination: self.loadUsers.firstNumberForPaginationSearch, secondNumberForPagination: self.loadUsers.secondNumberForPaginationSearch, search: true)}, completionHandler1: {self.usersTableView.reloadData()})
        }
        usersTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        usersTableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
}
