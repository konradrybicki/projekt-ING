//
//  ViewController.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //zmienne - networking
    
    var users:[User]?
    var posts:[Post]?
    var comments:[Comment]?
    
    var networkingError_users:Error?
    var networkingError_posts:Error?
    var networkingError_comments:Error?
    
    //zmienne - tableView
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataLoadingIndicator: UIActivityIndicatorView!
    
    var displayedPostsAmount:Int?
    var allPostsDisplayed:Bool?
    
    var numberOfRowsInSectionSkipper = 0 //dodatkowa zmienna dla tymczasowego zaradzenia problemowi z metodą 'numberOfRowsInSection'                                        (metoda zostaje wywołana się 3 razy a powinna raz)
    
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
        
        displayedPostsAmount = 0
        allPostsDisplayed = false //po poprawnym zdekodowaniu liczba postów zawsze będzie większa od 0
        
        tableView.dataSource = self
        tableView.delegate = self
        //rejestr plików NIB dla komórek wielokrotnego użytku (jeden NIB dla jednej komórki)
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell_posts")
        tableView.register(UINib(nibName: "SeparatorCell", bundle: nil), forCellReuseIdentifier: "ReusableCell_separators")
        
        dataLoadingIndicator.startAnimating() //problemy z synchronizacją indicatora z przeładowaniem postów - będzie się kręcić cały                                        czas
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //(tymczasowe rozwiązanie problemu ze zwielokrotnionym wywołaniem metody)
        //-----------------------------------------------------------------------
        if numberOfRowsInSectionSkipper < 2 {
            numberOfRowsInSectionSkipper += 1
            return 0
        }
        //-----------------------------------------------------------------------
        
        //(na wszelki wypadek)
        
        guard let _posts = posts else {
            print("Posts unwrap failed unexpectedly.")
            exit(1)
        }
        guard var _displayedPostsAmount = displayedPostsAmount else {
            print("Variable unwrap failed unexpectedely ('displayedPostsAmount').")
            exit(1)
        }
        
        //określamy liczbę wyświetlanych postów (max 10)
        
        for _ in _displayedPostsAmount..._posts.count {
            _displayedPostsAmount += 1
            
            if _displayedPostsAmount % 10 == 0 {
                break
            }
        }
        
        //zmienne globalne
        
        self.displayedPostsAmount = _displayedPostsAmount
        
        if _displayedPostsAmount == _posts.count {
            allPostsDisplayed = true
            
            //footer - indicator, label
            
            dataLoadingIndicator.hidesWhenStopped = true
            dataLoadingIndicator.stopAnimating()
            
            //TODO - label z komentarzem typu 'All posts displayed'
        }
        
        //ret
        
        return (_displayedPostsAmount +    //posty
                _displayedPostsAmount - 1) //separatory
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 { //posty
            
            //wykorzysujemy komórkę wielokrotnego użytku do tworzenia komórek określonej klasy (jedna klasa dla jednej komórki)
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell_posts", for: indexPath) as! PostCell
            
            guard let _posts = posts else {
                print("Posts unwrap failed unexpectedly.")
                exit(1)
            }
            guard let _users = users else {
                print("Users unwrap failed unexpectedly.")
                exit(1)
            }
            guard let _comments = comments else {
                print("Comments unwrap failed unexpectedly.")
                exit(1)
            }
            
            var post:Post!
            var user:User!
            var commentsAmount = 0
            
            post = _posts[(indexPath.row)/2]
            for currentUser in _users {
                if currentUser.id == post.userId {
                    user = currentUser
                    break
                }
            }
            for currentComment in _comments {
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
        else { //separatory
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell_separators", for: indexPath) as! SeparatorCell
            return cell
        }
    }
}

//delegacja - przeniesienie funkcjonalności w zakresie reagowania na określone zdarzenia do osobnej klasy

extension ViewController: UITableViewDelegate /*, UIScrollViewDelegate*/ {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if tableView.contentOffset.y == tableView.contentSize.height - tableView.bounds.height { //sam doł naszego tableView
            guard let _allPostsDisplayed = allPostsDisplayed else {
                print("Variable unwrap failed unexpectedely ('allPostsDisplayed').")
                exit(1)
            }
            
            if !_allPostsDisplayed {
                tableView.reloadData()
            }
        }
    }
}
