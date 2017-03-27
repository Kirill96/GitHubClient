//
//  AccountAuthorization.swift
//  GitHubClient
//
//  Created by Kirill on 22.03.17.
//  Copyright © 2017 Kirill. All rights reserved.
//

import UIKit

class AccountAuthorization: UIViewController {
    
    let loadDataForUserProfile = LoadDataForUserProfile.sharedInstance
    let loadDataForGitHubUsers = LoadDataForGitHubUsers.sharedInstance
    let myActivityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var topConstraintGitHub: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataForUserProfile.userInformationForProfile.removeAll()
        loadDataForUserProfile.listOfNameOfRepositories.removeAll()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccountAuthorization.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AccountAuthorization.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(myActivityIndicator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInGitHubAccount(_ sender: UIButton) {
        
        if (login.text?.isEmpty)! || (password.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Error", message: "All fields must be filled!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.view.endEditing(true)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.myActivityIndicator.startAnimating()
            loadDataForUserProfile.authorization(user: login.text!, password: password.text!) { response in
                if response["message"].string != nil {
                    
                    let alert = UIAlertController(title: "Error", message: "Incorrect login/password!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
                    self.view.endEditing(true)
                    self.present(alert, animated: true, completion: nil)
                    self.myActivityIndicator.stopAnimating()
                    
                } else {
                    self.loadDataForUserProfile.userInformationForProfile.removeAll()
                    self.present(self.animate_swipe(idefiner: "TabBarController", presentationStyle:
                        0, transitionStyle: 1), animated:true, completion:nil)
                    self.myActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func animate_swipe(idefiner: String, presentationStyle: Int, transitionStyle: Int ) -> UIViewController{
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: idefiner)
        resultViewController.modalPresentationStyle = UIModalPresentationStyle(rawValue: presentationStyle)!
        resultViewController.modalTransitionStyle = UIModalTransitionStyle(rawValue: transitionStyle)!
        
        return resultViewController
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if login.isEditing || password.isEditing {
            topConstraintGitHub.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        topConstraintGitHub.constant = 90
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        login.resignFirstResponder()
        password.resignFirstResponder()
    }
}
