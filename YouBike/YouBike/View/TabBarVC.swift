//
//  TabBarVC.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit

struct TabController {
    let vc: UIViewController
    let tab: UITabBarItem
}

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parkVM: ViewModel<BikeParkVM> = .init(.init())
        
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        
        let vcs: [TabController] = [
            .init(
                vc: iPad
                    ? BikeParkPadVC(favouriteOnly: false, vm: parkVM)
                    : BikeParkVC(favouriteOnly: false, vm: parkVM),
                tab: .init(title: "列表", image: "list".image, tag: 0)
            ),
            .init(
                vc: iPad
                    ? BikeParkPadVC(favouriteOnly: true, vm: parkVM)
                    : BikeParkVC(favouriteOnly: true, vm: parkVM),
                tab: .init(title: "最愛", image: "bookmark".image, tag: 1)
            )
        ]
        
        viewControllers = vcs
            .map{ model -> UINavigationController in
                BaseNC(rootViewController: model.vc).with{
                    $0.tabBarItem = model.tab
                }
        }
    }
    
}
