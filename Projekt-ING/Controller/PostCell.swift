//
//  PostCell.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 09/05/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

//klasa (Cocoa Touch) powiązana z plikiem .xib - kontroler dla widoku komórki

class PostCell: UITableViewCell {

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Body: UILabel!
    @IBOutlet weak var Comments: UILabel!
    @IBOutlet weak var CommentAmount: UILabel!
    
    override func awakeFromNib() { //nib - stara nazwa dla xib
        super.awakeFromNib()
        
        //init zmiennych - jak w normalnym ViewControllerze
        
        //..
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
