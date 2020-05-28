//
//  CommentsViewController.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 26/05/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    var passedPostId:Int?
   
    var users:[User]?
    var posts:[Post]?
    var comments:[Comment]?
    
    var error_users:Error?
    var error_posts:Error?
    var error_comments:Error?
    
    @IBOutlet weak var tappedView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingManager.handleJsonGetting(
            requestedType1: User.self, requestedType2: Post.self, requestedType3: Comment.self,
            dataContainer1: &users, dataContainer2: &posts, dataContainer3: &comments,
            errorContainer1: &error_users, errorContainer2: &error_posts, errorContainer3: &error_comments)
        
        if error_users != nil { print(error_users!); exit(1) }
        if error_posts != nil { print(error_posts!); exit(1) }
        if error_comments != nil { print(error_comments!); exit(1) }
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.unwind(_:)))
        tappedView.addGestureRecognizer(tapGestureRecogniser)
        tappedView.isUserInteractionEnabled = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "ReusableCell_post")
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "ReusableCell_comments")
    }
    
    @objc func unwind(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "unwindComments", sender: self)
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _comments = comments else {
            print("Comments unwrap failed unexpectedely.")
            exit(1)
        }
        
        var ourCommentAmount = 0
        var currentComment:Comment
        for i in 0..<_comments.count {
            currentComment = _comments[i]
            
            if currentComment.postId == self.passedPostId {
                ourCommentAmount += 1
            }
        }
        
        return 1 + ourCommentAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 { //post
            
            guard let _posts = posts else {
                print("Posts unwrap failed unexpectedely.")
                exit(1)
            }
            guard let _users = users else {
                print("Users unwrap failed unexpectedely.")
                exit(1)
            }
            guard let _comments = comments else {
                print("Comments unwrap failed unexpectedely.")
                exit(1)
            }
            
            var ourPost:Post?
            var ourUser:User?
            var ourCommentAmount = 0
            
            var currentPost:Post
            for i in 0..<_posts.count {
                currentPost = _posts[i]
                
                if currentPost.id == passedPostId {
                    ourPost = currentPost
                }
            }
            guard let _ourPost = ourPost else {
                print("No post with such ID, the post might have been deleted..")
                exit(1)
            }
            
            var currentUser:User
            for i in 0..<_users.count {
                currentUser = _users[i]
                
                if currentUser.id == _ourPost.userId {
                    ourUser = currentUser
                }
            }
            guard let _ourUser = ourUser else {
                print("No user with such ID, the account might have been deleted..")
                exit(1)
            }
            
            var currentComment:Comment
            for i in 0..<_comments.count {
                currentComment = _comments[i]
                
                if currentComment.postId == _ourPost.id {
                    ourCommentAmount += 1
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell_post", for: indexPath) as! PostCell
            
            cell.Username.setTitle(_ourUser.username, for: .normal)
            cell.Title.text = _ourPost.title
            cell.Body.text = _ourPost.body
            cell.CommentAmount.text = String(ourCommentAmount)
            
            cell.Comments.isUserInteractionEnabled = false
            
            return cell
        }
        else { //komentarze
            
            guard let _comments = comments else {
                print("Comments unwrap failed unexpectedely.")
                exit(1)
            }
            
            var ourComment:Comment! //operator forsujący - na tym etapie możemy być pewni, że komentarz nie będzie nullem
                                    //(metoda 'numberOfRowsInSection' - liczba komentarzy znalezionych po id posta)
            
            var currentComment:Comment
            for i in 0..<_comments.count {
                currentComment = _comments[i]
                
                if currentComment.postId == self.passedPostId {
                    ourComment = currentComment
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell_comments", for: indexPath) as! CommentCell
            
            cell.email.text = ourComment.email
            cell.name.text = ourComment.name
            cell.body.text = ourComment.body
            
            return cell
        }
    }
}
