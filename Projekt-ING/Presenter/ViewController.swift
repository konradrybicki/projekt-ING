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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pobieranie danych z API do zmiennych - "puszczamy" proces, na który będziemy musieli poczekać
        
        NetworkingManager.getJsonData(decodedType: User.self) { result in
            switch result {
            case .failure(let error):
                print(error)
                return
            case .success(let decodedData):
                self.users = decodedData
            }
        }
        NetworkingManager.getJsonData(decodedType: Post.self) { result in
            switch result {
            case .failure(let error):
                print(error)
                return
            case .success(let decodedData):
                self.posts = decodedData
            }
        }
        
        //synchronizacja - dane z API muszą znaleźć się w zmiennych ZANIM wykonane zostaną metody dla tableView
        
        //Czekamy na:
        //1. Odpowiedź ze strony API ('result') - wstępną inicjalizację zmiennych
        print("Waiting for API response...")
        while(!((self.users?.count != nil) &&
                (self.posts?.count != nil))) {}
        //2. "Wypełnienie" tablic danymi  - pełną inicjalizację (dopiero teraz, gdy wiemy ile obiektów zostanie zdekodowanych)
        print("Waiting for variable initialisation...")
        while(!((self.users?[self.users!.count - 1] != nil) &&
                (self.posts?[self.posts!.count - 1] != nil))) {}
        print("Decoding complete.")
        
        //dane dla widoku tabelarycznego
        
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        
        //rejestr NIB - widok dla komórki
        
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
}

//źródło danych dla widoku tabelarycznego (delegacja)

extension ViewController: UITableViewDataSource {
    
    //liczba wierszy - X
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts!.count
    }
    
    //wiersze - pętla wykona się X razy
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
 
        //charakterystyka komórki
        
        cell.usernameLabel.text = "username"
        cell.bodyLabel.text = posts![indexPath.row].body
        //commentsLabel
        cell.commentAmountLabel.text = "X"
        
        return cell
    }
}

