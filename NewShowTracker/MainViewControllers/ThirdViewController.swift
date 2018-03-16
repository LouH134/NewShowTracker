//
//  ThirdViewController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 3/16/18.
//  Copyright © 2018 Louis Harris. All rights reserved.
//

import UIKit
import Firebase

/*
 TO DO:
 1. When add Friend button pushed alert with textfield appears prompts user to enter friends name with a button.
 2. The button searches for username from firebase and adds friend to an array.
 3. the Tableview is refereshed and the friend is displayed.
 4. If username is not in firebase an error shows.
 5. If user clicks on friend in table view a drop down happens with another tableview that shows the firends list.
 6.delete removes friend from array and tableview and refreshes the tableview
 */

class ThirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var deleteFriendsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addFriendsPressed(_ sender: Any) {
    }
    
    @IBAction func deleteFriendsPressed(_ sender: Any) {
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
