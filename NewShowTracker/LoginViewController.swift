//
//  LoginViewController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 3/1/18.
//  Copyright © 2018 Louis Harris. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController:UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designForUI()
        
        self.loginButton.isEnabled = false
        
        handleTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil{
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in self.performSegue(withIdentifier: "goToTabBarController", sender: nil)})
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    func textFieldChanged(){
        guard let emailString = emailTextField.text, !emailString.isEmpty, let passwordString = passwordTextField.text, !passwordString.isEmpty else{
            self.loginButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            self.loginButton.isEnabled = false
            
            return
        }
        self.loginButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        self.loginButton.isEnabled = true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        ProgressHUD.show("Waiting....", interaction:false)
        DataHandler.logIn(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSuccess: {
            DispatchQueue.main.async {
                ProgressHUD.showSuccess("Success!")
                self.performSegue(withIdentifier: "goToTabBarController", sender: nil)
            }
            
        }, onError: {
            error in ProgressHUD.showError(error)
        })
        self.view.endEditing(true)
    }
    
    func designForUI(){
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 2.5
        emailTextField.layer.borderColor = UIColor.purple.cgColor
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 2.5
        passwordTextField.layer.borderColor = UIColor.purple.cgColor
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 2.5
        loginButton.layer.borderColor = UIColor.purple.cgColor
        loginButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderWidth = 2.5
        signupButton.layer.borderColor = UIColor.purple.cgColor
        signupButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    
}
