//
//  ListOfRepositoriesController.swift
//  GitHubClient
//
//  Created by Kirill on 22.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class ListOfRepositoriesController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listOfRepositoriesTableView: UITableView!
    
    let getListOfRepositories = LoadDataForUserProfile.sharedInstance
    let myActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfRepositoriesTableView.delegate = self
        listOfRepositoriesTableView.dataSource = self
        if getListOfRepositories.listOfNameOfRepositories.isEmpty {
            getListOfRepositories.loadRepositoriesFromUrl(firstNumberForPagination: getListOfRepositories.firstNumberForPagination, secondNumberForPagination: getListOfRepositories.secondNumberForPagination, reloadData: {self.listOfRepositoriesTableView.reloadData()})
        }
        
        listOfRepositoriesTableView.addInfiniteScroll { (tableView) -> Void in
            tableView.finishInfiniteScroll()
        }
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(myActivityIndicator)
        self.myActivityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToProfile" {
            let tabBarController = segue.destination as! UITabBarController
            tabBarController.selectedIndex = 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getListOfRepositories.listOfNameOfRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.myActivityIndicator.stopAnimating()
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        cell.nameOfRepository.text = getListOfRepositories.listOfNameOfRepositories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == getListOfRepositories.secondNumberForPagination - 1 {
            getListOfRepositories.firstNumberForPagination = getListOfRepositories.secondNumberForPagination
            getListOfRepositories.secondNumberForPagination += 15
            getListOfRepositories.loadRepositoriesFromUrl(firstNumberForPagination: getListOfRepositories.firstNumberForPagination, secondNumberForPagination: getListOfRepositories.secondNumberForPagination, reloadData: {self.listOfRepositoriesTableView.reloadData()})
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
