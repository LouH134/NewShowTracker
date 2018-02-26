//
//  DetailsViewController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var currentEpisodeLabel: UILabel!
    @IBOutlet weak var totalEpisodesLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var currentSeasonLabel: UILabel!
    @IBOutlet weak var totalSeasonsLabel: UILabel!
    @IBOutlet weak var airingLabel: UILabel!
    var currentlySelectedShow:Show!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = currentlySelectedShow.showName
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = barButtonItem
        barButtonItem.tintColor = UIColor.yellow
        
        displayShowDetails()
        
        if currentlySelectedShow.summary == "Enter Summary..."{
            summaryTextView.isHidden = true
        }
        
        let tempArray = [currentEpisodeLabel,currentSeasonLabel,rankingLabel]
        
        for mainLabels in tempArray{
            if mainLabels?.text == nil{
                airingLabel.isHidden = true
                break
            }
        }
    }
    
    @objc func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

    func displayShowDetails(){
        summaryTextView.text = currentlySelectedShow.summary
        
        let rankString = String(currentlySelectedShow.rank)
        rankingLabel.text = rankString
        
        currentEpisodeLabel.text = currentlySelectedShow.currentEpisode
        currentEpisodeLabel.sizeToFit()
        currentEpisodeLabel.adjustsFontSizeToFitWidth = true
        currentEpisodeLabel.adjustsFontForContentSizeCategory = true
        
        totalEpisodesLabel.text = currentlySelectedShow.totalEpisodes
        totalEpisodesLabel.sizeToFit()
        totalEpisodesLabel.adjustsFontSizeToFitWidth = true
        totalEpisodesLabel.adjustsFontForContentSizeCategory = true
        
        currentSeasonLabel.text = currentlySelectedShow.currentSeason
        currentSeasonLabel.sizeToFit()
        currentSeasonLabel.adjustsFontSizeToFitWidth = true
        currentSeasonLabel.adjustsFontForContentSizeCategory = true
        
        totalSeasonsLabel.text = currentlySelectedShow.totalSeasons
        totalSeasonsLabel.sizeToFit()
        totalSeasonsLabel.adjustsFontSizeToFitWidth = true
        totalSeasonsLabel.adjustsFontForContentSizeCategory = true
        
        if currentlySelectedShow.airing == true{
            airingLabel.text = "YES"
        }else{
            airingLabel.text = "NO"
        }
    }
}
