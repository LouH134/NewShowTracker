//
//  CustomDeletePossibleShowAlertVC.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomDeletePossibleShowAlertVC: UIViewController {
    
    @IBOutlet weak var deletePossibleShowAlertView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var secondVC:CreateShowVC!

    override func viewDidLoad() {
        super.viewDidLoad()

        deletePossibleShowAlertView.layer.cornerRadius = 5
        deletePossibleShowAlertView.layer.borderWidth = 2.5
        deletePossibleShowAlertView.layer.borderColor = UIColor.purple.cgColor
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2.5
        cancelButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func deletePressed(_ sender: Any) {
        self.secondVC.deleteSelectedRow()
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.presentingViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
