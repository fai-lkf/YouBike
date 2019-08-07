//
//  TabBarVC.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parkVM: ViewModel<BikeParkVM> = .init(.init())
        
        viewControllers = [
            (BikeParkVC.create(favouriteOnly: false, vm: parkVM), "列表"),
            (BikeParkVC.create(favouriteOnly: true, vm: parkVM), "最愛")
            ]
            .map{ vc, title -> UINavigationController in
                BaseNC(rootViewController: vc).with{
                    $0.tabBarItem.title = title
                }
        }
    }
    
}
