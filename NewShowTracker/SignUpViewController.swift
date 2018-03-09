//
//  SignUpViewController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 3/5/18.
//  Copyright © 2018 Louis Harris. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designForUI()
        
        self.signUpButton.isEnabled = false
        
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func handleTextField()
    {
        userNameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldChanged(){
        guard let userNameString = userNameTextField.text, !userNameString.isEmpty, let emailString = emailTextField.text, !emailString.isEmpty, let passwordString = passwordTextField.text, !passwordString.isEmpty else{
            self.signUpButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            self.signUpButton.isEnabled = false
            
            return
        }
        self.signUpButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        self.signUpButton.isEnabled = true
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        ProgressHUD.show("Waiting....", interaction:false)
        DataHandler.signUp(username: self.userNameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, onSuccess: {
            DispatchQueue.main.async {
                ProgressHUD.show("Success!")
                self.performSegue(withIdentifier: "goToTabBarVCFromCreate", sender: nil)
            }
            
        }, onError: {
            (errorString) in ProgressHUD.showError(errorString)
        })
    }
    
    
    @IBAction func dismissSignup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func designForUI(){
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.borderWidth = 2.5
        userNameTextField.layer.borderColor = UIColor.purple.cgColor
        
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 2.5
        emailTextField.layer.borderColor = UIColor.purple.cgColor
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 2.5
        passwordTextField.layer.borderColor = UIColor.purple.cgColor
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 2.5
        signUpButton.layer.borderColor = UIColor.purple.cgColor
        signUpButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        alreadyHaveAccountButton.layer.cornerRadius = 5
        alreadyHaveAccountButton.layer.borderWidth = 2.5
        alreadyHaveAccountButton.layer.borderColor = UIColor.purple.cgColor
        alreadyHaveAccountButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
    }
    
    
}
