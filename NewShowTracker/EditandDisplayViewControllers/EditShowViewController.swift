//
//  EditShowViewController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit
import CoreData

class EditShowViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var currentEpisodeTxtField: UITextField!
    @IBOutlet weak var totalEpisodesTxtField: UITextField!
    @IBOutlet weak var currentSeasonTxtField: UITextField!
    @IBOutlet weak var totalSeasonsTxtField: UITextField!
    @IBOutlet weak var rankTxtField: UITextField!
    @IBOutlet weak var airingLabel: UILabel!
    @IBOutlet weak var airingSwitch: UISwitch!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var saveShowButton: UIButton!
    var currentlySelectedShow:Show!
    var allEditedShows:[Show] = []
    var keyboardHeight:CGRect!
    var summaryString:String?
    var editedSummaryString:String?
    var placeholderString = "Enter Summary..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI for NavController and action to go back
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]
        self.title = "Edit Show"
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
        //UI for button and textfields
        designForUI()

        //behavoir for diplaying or not displaying attributes of show
        showAttributes()
        
        //simple actions
        self.keyboardHeight = self.view.frame

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        saveShowButton.isEnabled = false
        saveShowButton.setTitleColor(.gray, for: .normal)

        textFieldChanged()
        handleTextField()
    }
    
    @objc func goBack()
    {
        //print("Back button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func designForUI(){
        saveShowButton.layer.cornerRadius = 5
        saveShowButton.layer.borderWidth = 2.5
        saveShowButton.layer.borderColor = UIColor.purple.cgColor
        saveShowButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        currentEpisodeTxtField.layer.cornerRadius = 5
        currentEpisodeTxtField.layer.borderWidth = 2.5
        currentEpisodeTxtField.layer.borderColor = UIColor.purple.cgColor
        
        currentSeasonTxtField.layer.cornerRadius = 5
        currentSeasonTxtField.layer.borderWidth = 2.5
        currentSeasonTxtField.layer.borderColor = UIColor.purple.cgColor
        
        totalEpisodesTxtField.layer.cornerRadius = 5
        totalEpisodesTxtField.layer.borderWidth = 2.5
        totalEpisodesTxtField.layer.borderColor = UIColor.purple.cgColor
        
        totalSeasonsTxtField.layer.cornerRadius = 5
        totalSeasonsTxtField.layer.borderWidth = 2.5
        totalSeasonsTxtField.layer.borderColor = UIColor.purple.cgColor
        
        rankTxtField.layer.cornerRadius = 5
        rankTxtField.layer.borderWidth = 2.5
        rankTxtField.layer.borderColor = UIColor.purple.cgColor
        
        summaryTextView.delegate = self
        
        summaryTextView.textColor = UIColor.yellow
        summaryTextView.layer.borderWidth = 2.5
        summaryTextView.layer.borderColor = UIColor.purple.cgColor
    }
    
    func showAttributes(){
        showTitleLabel.text = currentlySelectedShow.showName
        
        if currentlySelectedShow.summary != nil{
            summaryString = currentlySelectedShow.summary
            summaryTextView.text = summaryString
        }else{
            summaryTextView.text = placeholderString
        }
        
        if currentEpisodeTxtField.text == nil{
            currentEpisodeTxtField.placeholder = "Enter Current Episode..."
        }else{
            currentEpisodeTxtField.text = currentlySelectedShow.currentEpisode
        }
        
        if totalEpisodesTxtField.text == nil{
            totalEpisodesTxtField.placeholder = "Enter Total # of Episodes..."
        }else{
            totalEpisodesTxtField.text = currentlySelectedShow.totalEpisodes
        }
        
        if currentSeasonTxtField.text == nil{
            currentSeasonTxtField.placeholder = "Enter Current Season..."
        }else{
            currentSeasonTxtField.text = currentlySelectedShow.currentSeason
        }
        
        if totalSeasonsTxtField.text == nil{
            totalSeasonsTxtField.placeholder = "Enter Total # of Seasons..."
        }else{
            totalSeasonsTxtField.text = currentlySelectedShow.totalSeasons
        }
        
        if currentlySelectedShow.rank == 0{
            rankTxtField.placeholder = "Enter Rank..."
        }else{
            let rankString = String(currentlySelectedShow.rank)
            rankTxtField.text = rankString
        }
        
        if currentlySelectedShow.airing == false{
            airingSwitch.isOn = false
            airingLabel.text = "No"
        }else{
            airingSwitch.isOn = true
            airingLabel.text = "Yes"
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: keyboardHeight.height - keyboardSize.height - 1)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification)
    {
        if((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil{
            self.view.frame = keyboardHeight
        }
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    //Fuction to enable save button
    @objc func textFieldChanged()
    {
        guard let showEpisodeString = currentEpisodeTxtField.text,  !showEpisodeString.isEmpty, let seasonEpisodeString = currentSeasonTxtField.text, !seasonEpisodeString.isEmpty, let rankString = rankTxtField.text, !rankString.isEmpty else{
            saveShowButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
            saveShowButton.isEnabled = false
            
            return
        }
        saveShowButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
        saveShowButton.isEnabled = true
    }
    
    func handleTextField()
    {
        currentEpisodeTxtField.addTarget(self, action: #selector(EditShowViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        currentSeasonTxtField.addTarget(self, action: #selector(EditShowViewController.textFieldChanged), for: UIControlEvents.editingChanged)
        rankTxtField.addTarget(self, action: #selector(EditShowViewController.textFieldChanged), for: UIControlEvents.editingChanged)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if summaryString != nil && summaryString != placeholderString{
            textView.text = summaryString
        }else if textView.textColor == UIColor.yellow {
                textView.text = nil
                summaryString = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && summaryString == nil {
            textView.text = placeholderString
        }else{
            editedSummaryString = textView.text
            summaryString = editedSummaryString
        }
    }
    
    @IBAction func airing(_ sender: UISwitch) {
        if airingSwitch.isOn == true
        {
            airingLabel.text = "Yes"
            currentlySelectedShow.airing = true
        }else{
            airingLabel.text = "No"
            currentlySelectedShow.airing = false
        }
    }
    
    @IBAction func saveShow(_ sender: Any) {
        //loop through all coredata objects if rank isn't nil, if the rank of the object is equal to ranktext and the current show is not ranktext throw alert otherwise save
        var flag = true
        for show in self.allEditedShows {
            if show.rank != 0  {
                let rankString = String(show.rank)
                let selectedShowRank = String(currentlySelectedShow.rank)
                if rankString == rankTxtField.text && selectedShowRank != rankTxtField.text{
                    // we can't save
                    flag = false
                    break
                }
            }
        }
        
        //if the flag is true save info to coredata and go to a tabbarVC
        if flag{
            updateShow()
            
            //look for followed bool if followed bool is true go to firstVC if followed bool is false go to secondVC
            if currentlySelectedShow.followed == true{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let firstVC = storyboard.instantiateViewController(withIdentifier: "firstViewController") as! FirstViewController
                self.navigationController?.pushViewController(firstVC, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondVC = storyboard.instantiateViewController(withIdentifier: "secondViewController") as! SecondViewController
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
            
        }else{
            // throw a error
            let customAlert = CustomRankAlertVC()
            customAlert.modalPresentationStyle = .overCurrentContext
            customAlert.modalTransitionStyle = .crossDissolve
            
            let castedRank = Int32(rankTxtField.text!)
            
            customAlert.currentlySelectedShow = self.currentlySelectedShow
            customAlert.newRankForShow = castedRank
            customAlert.everyShow = allEditedShows
            customAlert.navController = self.navigationController
            
            present(customAlert, animated: true)
        }
    }
    
    func updateShow(){
        currentlySelectedShow.currentEpisode = currentEpisodeTxtField.text
        currentlySelectedShow.totalEpisodes = totalEpisodesTxtField.text
        currentlySelectedShow.currentSeason = currentSeasonTxtField.text
        currentlySelectedShow.totalSeasons = totalSeasonsTxtField.text
        currentlySelectedShow.summary = summaryTextView.text
        
        //convert ranktextfield to int cast as int32 to be saved
        let showRank: Int? = Int(rankTxtField.text!)
        currentlySelectedShow.rank = Int32(showRank!)
        
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
