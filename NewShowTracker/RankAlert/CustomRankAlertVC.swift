//
//  CustomRankAlertVC.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit
import CoreData

class CustomRankAlertVC: UIViewController {
    @IBOutlet weak var rankAlertView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var everyShow:[Show] = []
    var newRankForShow:Int32?
    var currentlySelectedShow:Show!
    var navController:UINavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rankAlertView.layer.cornerRadius = 5
        rankAlertView.layer.borderWidth = 2.5
        rankAlertView.layer.borderColor = UIColor.purple.cgColor
        
        yesButton.layer.cornerRadius = 5
        yesButton.layer.borderWidth = 2.5
        yesButton.layer.borderColor = UIColor.purple.cgColor
        
        noButton.layer.cornerRadius = 5
        noButton.layer.borderWidth = 2.5
        noButton.layer.borderColor = UIColor.purple.cgColor
    }

    @IBAction func yesPressed(_ sender: Any) {
        changeRank()
        
        //push to a viewcontroller depending on followed bool
        if currentlySelectedShow.followed == true{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let firstVC = storyboard.instantiateViewController(withIdentifier: "followedShowsVC") as! FollowedShowsVC
            navController?.pushViewController(firstVC, animated: true)
            dismiss(animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "createShowVC") as! CreateShowVC
            navController?.pushViewController(secondVC, animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func noPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeRank(){
        //loop through every coredata object in array if an objects rank is equal to the current shows rank, then the objects rank becomes nil and the current shows rank is maintained
        for show in self.everyShow{
            let newRank = newRankForShow
            if show.rank == newRank{
                show.rank = 0
            
                currentlySelectedShow.rank = newRank!
            }
        }
        
        //save changes to coredata
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
    }
}
