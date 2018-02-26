//
//  CustomTabBarController.swift
//  NewShowTracker
//
//  Created by Louis Harris on 10/28/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = self.selectedIndex
        var nav = UINavigationController()
        nav = self.viewControllers![selectedIndex] as! UINavigationController
        
        nav.popToRootViewController(animated: false)
    }

}
