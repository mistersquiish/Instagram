//
//  HomeViewController.swift
//  Instagram
//
//  Created by Henry Vuong on 3/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource {
    
    var posts: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.current() will now be nil
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func composeButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // parse query
        var query = PFQuery(className:"Post")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects {
                    for post in objects {
                        self.posts.append(post.value(forKey: "objectId") as! String)
                        self.tableView.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        var query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: "\(posts[indexPath.row])") {
            (post: PFObject?, error: Error?) -> Void in
            if error == nil && post != nil {
                cell.photoDescriptionLabel.text = post?.value(forKey: "caption") as! String
                // get UIImage from PFFfile
                let postPicture = post?.value(forKey: "media")! as! PFFile
                    postPicture.getDataInBackground(block: {
                        (imageData: Data!, error: Error!) -> Void in
                        if (error == nil) {
                            cell.photoView.image = UIImage(data:imageData)

                        }
                    })
            } else {
                print(error)
            }
        }
        return cell
    }
}
