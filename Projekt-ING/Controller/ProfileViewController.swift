//
//  ProfileViewController.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 28/05/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var passedUserId:Int!
    
    //dane + dane w interfejsie
    
    var user:User? //optional - konto mogło zostać usunięte
    
    @IBOutlet weak var usernameMain: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    
    //unwind
    
    @IBOutlet weak var tappedView: UIView!
    
    //widoki w contentView do auto resize'u
/*
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var streetView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var zipcodeView: UIView!
*/
    //przyciski do zaokrąglenia
    
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var geoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //dane
        
        var users:[User]?
        var error_users:Error?
        
        NetworkingManager.handleJsonGetting(requestedType: User.self, dataContainer: &users, errorContainer: &error_users)
        
        if error_users != nil { print(error_users!); exit(1) }
        
        guard let _users = users else {
            print("Users unwrap failed unexpectedely.")
            exit(1)
        }
        
        var currentUser:User
        for i in 0..<_users.count {
            currentUser = _users[i]
            
            if currentUser.id == passedUserId {
                self.user = currentUser
                break
            }
        }
        
        guard let _user = user else {
            print("No user with such id, the account might have been deleted..")
            exit(1)
        }
        
        //interfejs
        
        self.usernameMain.text = _user.username
        self.username.text = "Username: " + _user.username
        self.email.text = "Email: " + _user.email
        self.website.text = "Website: " + _user.website
        self.street.text = "Street: " + _user.address.street
        self.city.text = "City: " + _user.address.city
        self.zipcode.text = "Zipcode: " + _user.address.zipcode
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(unwind(_:)))
        tappedView.addGestureRecognizer(tapGestureRecogniser)
        tappedView.isUserInteractionEnabled = true
/*
        usernameView.sizeToFit()
        emailView.sizeToFit()
        websiteView.sizeToFit()
        streetView.sizeToFit()
        cityView.sizeToFit()
        zipcodeView.sizeToFit()
        
        usernameView.layoutIfNeeded()
        emailView.layoutIfNeeded()
        websiteView.layoutIfNeeded()
        streetView.layoutIfNeeded()
        cityView.layoutIfNeeded()
        zipcodeView.layoutIfNeeded()
*/
        photosButton.layer.cornerRadius = 5
        geoButton.layer.cornerRadius = 5
        
        photosButton.layer.masksToBounds = true
        geoButton.layer.masksToBounds = true
    }
    
    @objc func unwind(_ selector: UITapGestureRecognizer) {
        performSegue(withIdentifier: "unwindProfile", sender: self)
    }
}
