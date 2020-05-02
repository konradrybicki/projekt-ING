//
//  ViewController.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users:[User]?
    var posts:[Post]?
    var networkingError_users:Error?
    var networkingError_posts:Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pobieranie danych z API do zmiennych - "puszczamy" proces, na który będziemy musieli poczekać
        
        NetworkingManager.getJsonData(decodedType: User.self) { result in
            switch result {
            case .failure(let error):
                self.networkingError_users = error
            case .success(let decodedData):
                self.users = decodedData
            }
        }
        NetworkingManager.getJsonData(decodedType: Post.self) { result in
            switch result {
            case .failure(let error):
                self.networkingError_posts = error
            case .success(let decodedData):
                self.posts = decodedData
            }
        }
        
        //synchronizacja - dane z API muszą znaleźć się w zmiennych ZANIM wykonane zostaną metody dla tableView, czekamy więc na:
        
        //1. Odpowiedź ze strony API ('result')
        
        print("Waiting for API response...")
        
        var errorResponse: Bool
        var dataResponse: Bool
        var apiResponse: Bool
        
        repeat {
            errorResponse = (networkingError_users != nil) || (networkingError_posts != nil)
            dataResponse = (self.users?.count != nil) && (self.posts?.count != nil) //wstępna inicjalizacja zmiennych
            apiResponse = errorResponse || dataResponse
        } while(!apiResponse)
        
        if errorResponse {
            if networkingError_users != nil {
                print(networkingError_users!)
                return
            }
            if networkingError_posts != nil {
                print(networkingError_posts!)
                return
            }
        }
        
        //2. "Wypełnienie" tablic danymi  - pełną inicjalizację (dopiero teraz, gdy wiemy ile obiektów zostanie zdekodowanych)
        
        print("Waiting for variable initialisation...")
        while(!((self.users?[self.users!.count - 1] != nil) &&
                (self.posts?[self.posts!.count - 1] != nil))) {}
        print("Decoding complete.")
        
        //tableView.dataSource ..
        
        //NIB ..
    }
}
