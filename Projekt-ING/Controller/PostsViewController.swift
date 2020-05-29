//
//  ViewController.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 21/04/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController, PostCellDelegate {
    
    //networking
    
    var users:[User]?
    var posts:[Post]?
    var comments:[Comment]?
    
    var error_users:Error?
    var error_posts:Error?
    var error_comments:Error?
    
    //tableView
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataLoadingIndicator: UIActivityIndicatorView!
    
    var displayedPostsAmount:Int?
    var allPostsDisplayed:Bool?
    
    var numberOfRowsInSectionSkipper = 0 //dodatkowa zmienna dla tymczasowego zaradzenia problemowi z metodą 'numberOfRowsInSection'                                        (metoda zostaje wywołana 3 razy a powinna raz)
    
    //przekaz danych do innych kontrolerów (tylko id - networking od 0 (coś w API mogło w czasie "przechodzenia" ulec zmianie))
    
    var userIdPassedBySegue:Int!
    var postIdPassedBySegue:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dane
        
        NetworkingManager.handleJsonGetting(requestedType1: User.self, requestedType2: Post.self, requestedType3: Comment.self,
                                            dataContainer1: &users, dataContainer2: &posts, dataContainer3: &comments,
                                            errorContainer1: &error_users, errorContainer2: &error_posts, errorContainer3: &error_comments)
        
        //obsługa błędów została zaimplementowana właśnie we VC, ze względu na ew. konieczność wypisania błędów,
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
    
    //przejścia pomiędzy widokami (PostCellDelegate)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationController = segue.destination as? ProfileViewController {
            destinationController.passedUserId = self.userIdPassedBySegue
        }
        else if let destinationController = segue.destination as? CommentsViewController {
            destinationController.passedPostId = self.postIdPassedBySegue
        }
    }
    
    func callSegueFromCell(matchingUserWith id: Int) {
        self.userIdPassedBySegue = id
        performSegue(withIdentifier: "presentProfile", sender: self)
    }
    func callSegueFromCell(matchingPostWith id: Int) {
        self.postIdPassedBySegue = id
        performSegue(withIdentifier: "presentComments", sender: self)
    }
    
    @IBAction func unwindProfile(_ unwindSegue: UIStoryboardSegue) {}
    @IBAction func unwindComments(_ unwindSegue: UIStoryboardSegue) {}
}

extension PostsViewController: UITableViewDataSource {
    
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
        
        //określamy liczbę wyświetlanych postów
        
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
            
            //dane
            
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
            
            var postIndex:Int!
            var post:Post!
            var user:User!
            var commentsAmount = 0
            
            postIndex = indexPath.row/2
            post = _posts[postIndex]
            
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
            
            //komórka
            
            //wykorzysujemy komórkę wielokrotnego użytku do tworzenia komórek określonej klasy (jedna klasa dla jednej komórki)
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell_posts", for: indexPath) as! PostCell
            
            cell.Username.setTitle(user.username, for: .normal)
            cell.Title.text = post.title
            cell.Body.text = post.body
            cell.CommentAmount.text = String(commentsAmount)
        
            //przekaz danych (delegacja)
            
            if commentsAmount == 0 {
                cell.Username.isUserInteractionEnabled = false
                cell.Comments.isUserInteractionEnabled = false
            }
            else {
                cell.delegate = self
                cell.userId = user.id
                cell.postId = post.id //przekaz danych do kontrolera widoku komentarzy
            }
            
            return cell
        }
        else { //separatory
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell_separators", for: indexPath) as! SeparatorCell
            return cell
        }
    }
}

//delegacja - przeniesienie danej funkcjonalności do innej klasy

extension PostsViewController: UITableViewDelegate /*, UIScrollViewDelegate*/ {
    
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
