//
//  FeedCell.swift
//  Instagram
//
//  Created by Henry Vuong on 3/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import Parse

protocol alerts: class {
    func presentAlert(title: String, message: String)
}

class FeedCell: UITableViewCell {
    
    var alertDelegate: alerts?
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var photoDescriptionLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func moreInfoButton(_ sender: Any) {
        alertDelegate?.presentAlert(title: "More info", message: "Date Created: \(String(describing: dateCreated!)) \n Likes: \(likes!)")
    }
    
    var username: String!
    var dateCreated: Date!
    var likes: Int!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
