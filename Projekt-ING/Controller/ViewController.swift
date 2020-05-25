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
    
    var error_users:Error?
    var error_posts:Error?
    var error_comments:Error?
    
    //zmienne - tableView
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataLoadingIndicator: UIActivityIndicatorView!
    
    var displayedPostsAmount:Int?
    var allPostsDisplayed:Bool?
    
    var numberOfRowsInSectionSkipper = 0 //dodatkowa zmienna dla tymczasowego zaradzenia problemowi z metodą 'numberOfRowsInSection'                                        (metoda zostaje wywołana 3 razy a powinna raz)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dane z API
        
        NetworkingManager.handleJsonGetting(requestedType1: User.self, requestedType2: Post.self, requestedType3: Comment.self,
                                            dataContainer1: &users, dataContainer2: &posts, dataContainer3: &comments,
                                            errorContainer1: &error_users, errorContainer2: &error_posts, errorContainer3: &error_comments)
        
        //obsługa błędów - zaimplementowana właśnie we VC, ze względu na ew. konieczność wypisania błędów,
        //czy też odpowiednich komunikatów na ekran
        
        if (error_posts != nil) { print(error_posts!); exit(1) }
        if (error_comments != nil) { print(error_comments!); exit(1) }
        if (error_users != nil) { print(error_users!); exit(1) }
        
        //interfejs
        
        displayedPostsAmount = 0
        allPostsDisplayed = false //po poprawnym zdekodowaniu liczba postów zawsze będzie większa od 0
        
        tableView.dataSource = self
        tableView.delegate = self
 
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell_posts")
        tableView.register(UINib(nibName: "SeparatorCell", bundle: nil), forCellReuseIdentifier: "ReusableCell_separators")
        
        dataLoadingIndicator.startAnimating() //problemy z synchronizacją indicatora z przeładowaniem postów - będzie się kręcić cały czas
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
        
        if tableView.contentOffset.y == tableView.contentSize.height - tableView.bounds.height { //sam dół naszego tableView
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
