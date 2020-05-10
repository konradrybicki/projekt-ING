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
    var comments:[Comment]?
    
    var networkingError_users:Error?
    var networkingError_posts:Error?
    var networkingError_comments:Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pobieranie danych z API do zmiennych - "puszczamy" proces, na który będziemy musieli poczekać
        
        NetworkingManager.getJsonData(ofType: User.self) { result in
            switch result {
            case .failure(let error):
                self.networkingError_users = error
            case .success(let decodedData):
                self.users = decodedData
            }
        }
        NetworkingManager.getJsonData(ofType: Post.self) { result in
            switch result {
            case .failure(let error):
                self.networkingError_posts = error
            case .success(let decodedData):
                self.posts = decodedData
            }
        }
        NetworkingManager.getJsonData(ofType: Comment.self) { result in
            switch result {
            case .failure(let error):
                self.networkingError_posts = error
            case .success(let decodedData):
                self.comments = decodedData
            }
        }
        
        //synchronizacja - dane z API muszą znaleźć się w zmiennych ZANIM wykonane zostaną metody dla tableView, czekamy więc na:
        
        //1. Odpowiedź ze strony API ('result')
        
        print("Waiting for API response...")
        
        var errorResponse: Bool = false
        var dataResponse: Bool = false
        var apiResponse: Bool = false
        
        repeat {
            errorResponse = ((networkingError_users != nil) || (networkingError_posts != nil) || (networkingError_comments != nil))
            //wstępna inicjalizacja zmiennych:
            dataResponse = ((self.users?.count != nil) && (self.posts?.count != nil) && (self.comments?.count != nil))
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
            if networkingError_comments != nil {
                print(networkingError_comments!)
                return
            }
        }
        
        //2. "Wypełnienie" tablic danymi  - pełną inicjalizację (dopiero teraz, gdy wiemy ile obiektów zostanie zdekodowanych)
        
        print("Waiting for variable initialisation...")
        while(!((self.users?[self.users!.count - 1] != nil) &&
                (self.posts?[self.posts!.count - 1] != nil) &&
                (self.comments?[self.comments!.count - 1] != nil))) {}
        print("Variables initialized - decoding complete.")
        
        //inicjalizacja interfejsu
        
        //delegacja do źródła danych
        tableView.dataSource = self
        //rejestr pliku NIB dla komórki wielokrotnego użytku - po załadowaniu danych
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //(na wszelki wypadek)
        guard let postsUnwrapped = posts else {
            print("Posts unwrapping failed unexpectedly.")
            exit(1)
        }
        
        return postsUnwrapped.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //wykorzysujemy komórkę wielokrotnego użytku do tworzenia komórek określonej klasy
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PostCell
        
        guard let postsUnwrapped = posts else {
            print("Posts unwrapping failed unexpectedly.")
            exit(1)
        }
        guard let usersUnwrapped = users else {
            print("Users unwrapping failed unexpectedly.")
            exit(1)
        }
        guard let commentsUnwrapped = comments else {
            print("Comments unwrapping failed unexpectedly.")
            exit(1)
        }
        
        var post:Post!
        var user:User!
        var commentsAmount = 0
        
        post = postsUnwrapped[indexPath.row]
        for currentUser in usersUnwrapped {
            if currentUser.id == post.userId {
                user = currentUser
                break
            }
        }
        for currentComment in commentsUnwrapped {
            if currentComment.postId == post.id {
                commentsAmount += 1
            }
        }
        
        cell.Username.text = user.username
        cell.Title.text = post.title
        cell.Body.text = post.body
        cell.CommentAmount.text = String(commentsAmount)
       
        return cell
    }
}
