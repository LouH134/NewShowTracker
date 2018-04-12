//
//  FollowedShowsVC.swift
//  NewShowTracker
//
//  Created by Louis Harris on 4/11/18.
//  Copyright © 2018 Louis Harris. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FollowedShowsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var followedShowsTableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var shareUpdateButton: UIButton!
    @IBOutlet weak var unShareButton: UIButton!
    var allShows:[Show] = []
    var followedShows:[Show] = []
    var selectedShow:Show?
    var sharedShowNames = [String]()
    var currentUser = User()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followedShowsTableView.allowsMultipleSelection = false
        
        //Tab bar and nav controler UI
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]
        if(self.navigationController?.navigationBar.backItem != nil){
            self.navigationItem.hidesBackButton = true
        }
        
        self.tabBarController?.tabBar.barTintColor = UIColor.purple
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.tintColor = UIColor.yellow
        
        //UI for buttons
        designForUI()
        
        //Disable buttons when nothing is selected
        self.navigationItem.rightBarButtonItem?.tintColor = .gray
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        detailsButton.isEnabled = false
        detailsButton.setTitleColor(.gray, for: .normal)
        
        deleteButton.isEnabled = false
        deleteButton.setTitleColor(.gray, for: .normal)
        
        //Setup Tableview
        self.followedShowsTableView.delegate = self
        self.followedShowsTableView.dataSource = self
        followedShowsTableView.backgroundColor = UIColor.black
        followedShowsTableView.tableFooterView = UIView()
        followedShowsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFollowedObjectsAndShow()
    }
    
    func designForUI(){
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        deleteButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        detailsButton.layer.cornerRadius = 5
        detailsButton.layer.borderWidth = 2.5
        detailsButton.layer.borderColor = UIColor.purple.cgColor
        detailsButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        shareUpdateButton.layer.cornerRadius = 5
        shareUpdateButton.layer.borderWidth = 2.5
        shareUpdateButton.layer.borderColor = UIColor.purple.cgColor
        shareUpdateButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        unShareButton.layer.cornerRadius = 5
        unShareButton.layer.borderWidth = 2.5
        unShareButton.layer.borderColor = UIColor.purple.cgColor
        unShareButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func getFollowedObjectsAndShow(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let sectionSortDescriptor = NSSortDescriptor(key: "rank", ascending: true)
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        
        do{
            allShows = try managedContext.fetch(fetchRequest)
            checkForFollowedShow()
            
        }catch let error as NSError{
            print("Could not fetch! \(error), \(error.userInfo)")
        }
        
        if followedShows.count != 0{
            image.isHidden =  true
            followedShowsTableView.isHidden = false
        }else{
            image.isHidden = false
            followedShowsTableView.isHidden = true
        }
    }
    
    func checkForFollowedShow(){
        followedShows.removeAll()
        
        for show in self.allShows{
            if show.followed != false{
                followedShows.append(show)
            }
        }
        
        //Handle nil rank, Takes nils at beinning of array and append them to the end of the array so nil rank appears at bottom of tableview
        var tempArray = [Show]()
        for zeroRank in self.followedShows {
            if zeroRank.rank == 0 {
                tempArray.append(zeroRank)
                self.followedShows.removeFirst()
            }
        }
        self.followedShows.append(contentsOf: tempArray)
        
        followedShowsTableView.reloadData()
    }
    
    func deleteShow(atIndexPath indexPath: IndexPath)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //currently selected show or highlighted show in tableview
        let thisShow = followedShows[indexPath.row]
        
        for show in followedShows{
            if (show.showName == thisShow.showName){
                managedContext.delete(show)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
            
        }
        
        self.followedShows.remove(at: indexPath.row)
        self.followedShowsTableView.deleteRows(at: [indexPath], with: .fade)
        
        if followedShows.count == 0 {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            detailsButton.isEnabled = false
            detailsButton.setTitleColor(.gray, for: .normal)
            
            deleteButton.isEnabled = false
            deleteButton.setTitleColor(.gray, for: .normal)
            
            image.isHidden = false
            followedShowsTableView.isHidden = true
        }
    }
    
    func deleteSelectedRow(){
        let indexPath = followedShowsTableView.indexPathForSelectedRow
        //guard statement because it is possible that the indexPath is nil
        guard let index = indexPath else {
            return
        }
        deleteShow(atIndexPath: index)
    }
    
    @IBAction func detailsPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let showDetailsVC = storyboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        
        let indexPath = followedShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = followedShows[index.row]
        
        showDetailsVC.currentlySelectedShow = currentShow
        
        self.navigationController?.pushViewController(showDetailsVC, animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let customAlert = CustomDeleteShowVC()
        customAlert.firstVC = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
    }
    
    @IBAction func goToEditVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editShowVC = storyboard.instantiateViewController(withIdentifier: "editShowViewController") as! EditShowViewController
        
        let indexPath = followedShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = followedShows[index.row]
        
        editShowVC.currentlySelectedShow = currentShow
        editShowVC.allEditedShows = followedShows
        
        self.navigationController?.pushViewController(editShowVC, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch let logOutError{
            print(logOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        //Problem: if app is closed currentUser.listID will always be nil.
        checkDataInDatabase()
        
        if currentUser.listID != nil{
            //            checkDataInDatabase()
        }else{
            //            postDataToDatabase()
        }
    }
    
    
    @IBAction func unSharePressed(_ sender: Any) {
        let ref: DatabaseReference! = Database.database().reference()
        ref.child("Lists").child(currentUser.listID!).child("List").removeValue()
    }
    
    func checkDataInDatabase(){
        Database.database().reference().child("Lists").observeSingleEvent(of: DataEventType.childAdded) { (snapshot) in
            if snapshot.exists() {
                print("LIST  \(String(describing: snapshot.value))")
            }
        }
    }
    
    //        Database.database().reference().child("Lists").child(currentUser.listID!).runTransactionBlock({(currentData:MutableData) -> TransactionResult in
    //            if var post = currentData.value as? [String:AnyObject], let userID = Auth.auth().currentUser?.uid{
    //                var lists: Dictionary<String, String>
    //                if let lists = post["List"] as? [String:String] {
    //                    print("LISTS    \(lists)")
    //                } else {
    //                    print("NO LIST")
    //
    //                }
    //
    //                if let _ = lists[userID]{
    //                    lists.removeValue(forKey: userID)
    //                }else{
    //                    lists[userID] = true
    //                }
    //
    //                post["List"] = lists as AnyObject?
    //                currentData.value = post
    //
    //                return TransactionResult.success(withValue: currentData)
    //            }
    //            return TransactionResult.success(withValue: currentData)
    //        }){
    //            (error, commited, snapshot) in
    //            if let error = error{
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
    func postDataToDatabase(){
        for show in followedShows{
            let showName = show.showName
            sharedShowNames.append(showName!)
        }
        
        let listID = NSUUID().uuidString
        currentUser.userID = Auth.auth().currentUser?.uid
        
        DataHandler.sendDataToDatabase(shareArray: sharedShowNames, storageID: listID, userID: currentUser.userID!, onSuccess: {_,optionalString in
            DispatchQueue.main.async {
                ProgressHUD.showSuccess("Woot! It worked!")
                let optionalListID = optionalString
                
                if let listID = optionalListID{
                    self.currentUser.listID = listID
                }
            }
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = followedShowsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell1
        
        let followedShow = followedShows[indexPath.row]
        
        cell.mainLabel.text = followedShow.value(forKey: "showName") as? String
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.purple.cgColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.purple
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteShow(atIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            detailsButton.isEnabled = true
            detailsButton.setTitleColor(.yellow, for: .normal)
            
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            detailsButton.isEnabled = false
            detailsButton.tintColor = .gray
            
            deleteButton.isEnabled = false
            deleteButton.tintColor = .gray
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            detailsButton.isEnabled = true
            detailsButton.setTitleColor(.yellow, for: .normal)
            
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            detailsButton.isEnabled = false
            detailsButton.tintColor = .gray
            
            deleteButton.isEnabled = false
            deleteButton.tintColor = .gray
        }
    }

}
