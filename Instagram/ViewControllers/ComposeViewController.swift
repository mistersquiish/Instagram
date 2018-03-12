//
//  ComposeViewController.swift
//  Instagram
//
//  Created by Henry Vuong on 3/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBAction func cancelButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        Post.postUserImage(image: photoView.image, withCaption: captionTextView.text, withCompletion: nil)
        // present UIAlertController about successful save
        /*let alertController = UIAlertController(title: "Post Uploaded!", message: "Your picture has successfully been uploaded", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        */
        // return to HomeViewController
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
        self.present(vc, animated: false, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            // after it is completed
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Do something with the images (based on your use case)
        photoView.image = originalImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

}
