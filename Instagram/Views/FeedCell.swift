//
//  FeedCell.swift
//  Instagram
//
//  Created by Henry Vuong on 3/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import Parse

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var photoDescriptionLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func moreInfoButton(_ sender: Any) {
        let alertController = UIAlertController(title: "More info", message: "Date Created: \(dateCreated!) \n Likes: \(likes!)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    var username: String!
    var dateCreated: String!
    var likes: Int!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //usernameLabel.text = username
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
