//
//  HomeViewController.swift
//  Instagram
//
//  Created by Henry Vuong on 3/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var posts: [String] = []
    let queryLimit = 3
    var loadedPagesCount = 1
    // refresh controller
    var refreshControl: UIRefreshControl!
    // scrollView variables
    var isMoreDataLoading = false
    // infinite scroll loading variables
    var loadingMoreView: InfiniteScrollView?

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
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Infinite Scroll loading indicator configuration
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
        loadingMoreView = InfiniteScrollView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollView.defaultHeight
        tableView.contentInset = insets
        
        // parse query
        queryPost()

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
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: "\(posts[indexPath.row])") {
            (post: PFObject?, error: Error?) -> Void in
            if error == nil && post != nil {
                cell.photoDescriptionLabel.text = post?.value(forKey: "caption") as? String
                let usernamePointer = post?.value(forKey: "author") as! PFUser
                //cell.username = usernamePointer.value(forKey: "username") as! String
                cell.likes = post?.value(forKey: "likesCount") as! Int
                cell.dateCreated = String(describing: post?.value(forKey: "createdAt"))
                // get UIImage from PFFfile
                let postPicture = post?.value(forKey: "media")! as! PFFile
                    postPicture.getDataInBackground(block: {
                        (imageData: Data!, error: Error!) -> Void in
                        if (error == nil) {
                            cell.photoView.image = UIImage(data:imageData)

                        }
                    })
            } else {
                print("Error in tableView: \(error!)")
            }
        }
        return cell
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        queryPost()
    }
    
    //MARK: Scroll View
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                
                // Using NSPredicate
                let query = PFQuery(className: "Post")
                query.addDescendingOrder("createdAt")
                if posts.count == queryLimit * loadedPagesCount {
                    loadedPagesCount += 1
                }
                query.limit = queryLimit * loadedPagesCount
                query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
                    if error == nil {
                        // The find succeeded.
                        // Do something with the found objects
                        if let objects = objects {
                            for post in objects {
                                print(post.value(forKey: "objectId")!)
                                if !(self.posts.contains(post.value(forKey: "objectId")! as! String)) {
                                    self.posts.append(post.value(forKey: "objectId") as! String)
                                    self.tableView.reloadData()
                                    self.isMoreDataLoading = false
                                }
                            }
                        }
                    } else {
                        // Log details of the failure
                        print("Error in Scroll View: \(error!)")
                    }
                }
                loadingMoreView!.stopAnimating()
            }
        }
    }
    
    // query for posts
    func queryPost() {
        // parse query
        let query = PFQuery(className:"Post")
        query.addDescendingOrder("createdAt")
        query.limit = queryLimit
        loadedPagesCount = 1
        isMoreDataLoading = false
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects {
                    var posts: [String] = []
                    for post in objects {
                        posts.append(post.value(forKey: "objectId") as! String)
                    }
                    self.posts = posts
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } else {
                // Log details of the failure
                print("Error in queryPost: \(error!)")
            }
        }
    }
}
