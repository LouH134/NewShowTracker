//
//  CustomSaveAlertVC.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomSaveAlertVC: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveAlertView: UIView!
    var secondVC: CreateShowVC!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveAlertView.layer.cornerRadius = 5
        saveAlertView.layer.borderWidth = 2.5
        saveAlertView.layer.borderColor = UIColor.purple.cgColor
        
        inputTextField.layer.cornerRadius = 5
        inputTextField.layer.borderWidth = 2.5
        inputTextField.layer.borderColor = UIColor.purple.cgColor
        
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 2.5
        saveButton.layer.borderColor = UIColor.purple.cgColor
        saveButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2.5
        cancelButton.layer.borderColor = UIColor.purple.cgColor
        cancelButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }

    @IBAction func save(_ sender: Any) {
        self.secondVC.save(name: inputTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.secondVC.getSavedObjectsAndShow()
        self.dismiss(animated: true, completion: nil)
    }

}
