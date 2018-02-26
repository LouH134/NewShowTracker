//
//  CustomDeleteShowVC.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomDeleteShowVC: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteShowView: UIView!
    var firstVC:FirstViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteShowView.layer.cornerRadius = 5
        deleteShowView.layer.borderWidth = 2.5
        deleteShowView.layer.borderColor = UIColor.purple.cgColor
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2.5
        cancelButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func deletePressed(_ sender: Any) {
        self.firstVC.deleteSelectedRow()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.presentingViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
}
