//
//  LoginViewController.swift
//  Instagram
//
//  Created by Henry Vuong on 3/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var alertController: UIAlertController!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        if !((usernameTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)!) {
            loginUser()
        } else {
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        if !((usernameTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)!) {
            registerUser()
        } else {
            self.present(alertController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // username and password UIAlertController
        alertController = UIAlertController(title: "Error", message: "Please enter a username and password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                let alertController = UIAlertController(title: "Sign-up Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            } else {
                let alertController = UIAlertController(title: "Success!", message: "User successfully registered", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func loginUser() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                let alertController = UIAlertController(title: "Login Failed", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
        
    }
}
