//
//  CommentCell.swift
//  Projekt-ING
//
//  Created by Konrad Rybicki on 27/05/2020.
//  Copyright © 2020 Konrad Rybicki. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
