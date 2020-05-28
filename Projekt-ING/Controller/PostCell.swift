//
//  PostCell.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 09/05/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit
import Foundation

//klasa (Cocoa Touch) powiązana z plikiem .xib - kontroler dla widoku komórki

class PostCell: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Username: UIButton!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Body: UILabel!
    @IBOutlet weak var Comments: UIButton!
    @IBOutlet weak var CommentAmount: UILabel!
    
    //delegacja, przekaz danych do innych kontrolerów
    
    var delegate:PostCellDelegate!
    var postId:Int!
    
    override func awakeFromNib() { //(nib - stara nazwa dla xib)
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func usernameTapped(_ sender: UIButton) {
        print("Username tapped")
        
        //..
    }
    @IBAction func commentsTapped(_ sender: UIButton) {
        print("Comments tapped")
        
        //mechanizm wykorzystujący delegację - wywoływanie metody poprzez obiekt kl. PostV.C. z poziomu kl. PostCell nie działało
    
        self.delegate.callSegueFromCell(matchingPostWith: self.postId)
    }
}

protocol PostCellDelegate {
    func callSegueFromCell(matchingPostWith id: Int)
}
