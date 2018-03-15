//
//  SecondViewController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/27/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var addShowButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addPossibleShowButton: UIButton!
    @IBOutlet weak var possibleShowsTableView: UITableView!
    @IBOutlet weak var possibleShowsImage: UIImageView!
    var possibleShows:[Show] = []
    var addShowString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        possibleShowsTableView.allowsMultipleSelection = false
        
        //UI for Navbar
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
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
        addShowButton.isEnabled = false
        deleteButton.isEnabled = false
        
        //Setting up tableview
        self.possibleShowsTableView.delegate = self
        self.possibleShowsTableView.dataSource = self
        possibleShowsTableView.backgroundColor = UIColor.black
        possibleShowsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        possibleShowsTableView.reloadData()
        getSavedObjectsAndShow()
    }
    
    func designForUI(){
        addShowButton.layer.cornerRadius = 5
        addShowButton.layer.borderWidth = 2.5
        addShowButton.layer.borderColor = UIColor.purple.cgColor
        addShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 2.5
        deleteButton.layer.borderColor = UIColor.purple.cgColor
        deleteButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        addPossibleShowButton.layer.cornerRadius = 5
        addPossibleShowButton.layer.borderWidth = 2.5
        addPossibleShowButton.layer.borderColor = UIColor.purple.cgColor
        addPossibleShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func getSavedObjectsAndShow()  {
        //look at core data for saved shows only shows that aren't followed
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        fetchRequest.predicate = NSPredicate(format: "followed == false")
        
        do{
            possibleShows = try managedContext.fetch(fetchRequest)
            self.possibleShowsTableView.reloadData()
            
        }catch let error as NSError{
            print("Could not fetch! \(error), \(error.userInfo)")
        }
        
        if possibleShows.count == 0{
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            addShowButton.isEnabled = false
            addShowButton.setTitleColor(.gray, for: .normal)
            deleteButton.isEnabled = false
            deleteButton.setTitleColor(.gray, for: .normal)
            
            possibleShowsImage.isHidden = false
            possibleShowsTableView.isHidden = true
        }else{
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            addShowButton.isEnabled = true
            addShowButton.setTitleColor(.yellow, for: .normal)
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
            
            possibleShowsImage.isHidden = true
            possibleShowsTableView.isHidden = false
        }
    }
    
    func save(name:String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:"Show", in: managedContext)
        let possibleShow = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        possibleShow.setValue(name, forKey: "showName")
        possibleShow.setValue(false, forKey: "followed")
        
        do{
            try managedContext.save()
            possibleShows.append(possibleShow as! Show)
            possibleShowsTableView.reloadData()
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
    }
    
    func deleteSelectedRow(){
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        //guard statement because it is possible that the indexPath is nil
        guard let index = indexPath else {
            return
        }
        deletePossibleShow(atIndexPath: index)
    }
    
    func deletePossibleShow(atIndexPath indexPath: IndexPath)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //currently selected show or highlighted show in tableview
        let thisPossibleShow = possibleShows[possibleShows.count - indexPath.row-1]
        
        for show in possibleShows{
            if (show.showName == thisPossibleShow.showName){
                managedContext.delete(show)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
            
        }
        
        self.possibleShows.remove(at: possibleShows.count - indexPath.row-1)
        self.possibleShowsTableView.deleteRows(at: [indexPath], with: .fade)
        
        if possibleShows.count == 0 {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            addShowButton.isEnabled = false
            addShowButton.setTitleColor(.gray, for: .normal)
            
            deleteButton.isEnabled = false
            deleteButton.setTitleColor(.gray, for: .normal)
            
            possibleShowsImage.isHidden = false
            possibleShowsTableView.isHidden = true
        }
    }
    
    @IBAction func addShowPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstVC = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! FirstViewController
        
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        let currentShow = possibleShows[possibleShows.count - index.row-1]
        currentShow.followed = true
        
        firstVC.selectedShow = currentShow
        firstVC.allShows = possibleShows
        
        self.possibleShows.remove(at: possibleShows.count - index.row - 1)
        self.possibleShowsTableView.deleteRows(at: [index], with: .fade)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("Could not Save! \(error), \(error.userInfo)")
        }
        
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func deletePossibleShowPressed(_ sender: Any) {
        let customAlert = CustomDeletePossibleShowAlertVC()
        customAlert.secondVC = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
    }
    
    @IBAction func addPossibleShowPressed(_ sender: Any) {
        let customAlert = CustomSaveAlertVC()
        customAlert.secondVC = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true)
        
        possibleShowsImage.isHidden = true
        possibleShowsTableView.isHidden = false
    }
    @IBAction func goToEditVC(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editShowVC = storyboard.instantiateViewController(withIdentifier: "editShowViewController") as! EditShowViewController
        
        let indexPath = possibleShowsTableView.indexPathForSelectedRow
        guard let index = indexPath else{
            return
        }
        
        let currentShow = possibleShows[possibleShows.count - index.row-1]
        
        editShowVC.currentlySelectedShow = currentShow
        editShowVC.allEditedShows = possibleShows
        
        self.navigationController?.pushViewController(editShowVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = possibleShowsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell2
        
        let possibleShow = possibleShows[possibleShows.count - indexPath.row-1]
        
        cell.mainLabel.text = possibleShow.value(forKey: "showName") as? String
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.purple.cgColor
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.purple
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            addShowButton.isEnabled = true
            addShowButton.setTitleColor(.yellow, for: .normal)
            
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            addShowButton.isEnabled = false
            addShowButton.tintColor = .gray
            
            deleteButton.isEnabled = false
            deleteButton.tintColor = .gray
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deletePossibleShow(atIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathForSelectedRow != nil {
            self.navigationItem.rightBarButtonItem?.tintColor = .yellow
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            
            addShowButton.isEnabled = true
            addShowButton.setTitleColor(.yellow, for: .normal)
            
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.yellow, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = .gray
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            addShowButton.isEnabled = false
            addShowButton.tintColor = .gray
            
            deleteButton.isEnabled = false
            deleteButton.tintColor = .gray
        }
    }
}

