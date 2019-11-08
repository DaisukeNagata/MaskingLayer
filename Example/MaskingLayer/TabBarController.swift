//
//  TabBarController.swift
//  MaskMatte
//
//  Created by 永田大祐 on 2019/11/05.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private var statusBarStyle : UIStatusBarStyle = .default

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = TabBarController.viewControllers()
        
        UITabBar.appearance().tintColor = UIColor.black
        let item = UITabBarItem.appearance()
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        item.setTitleTextAttributes([kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 0)], for: .normal)
        _ = self.tabBar.sizeThatFits(CGSize())
    }


    static func viewControllers() -> [UIViewController] {

        let vi = ViewController.viewController()
        vi.view.backgroundColor = UIColor.white
        let opc = UINavigationController(rootViewController: vi)
        return [opc]
    }
}

extension UITabBar {
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        var sized = super.sizeThatFits(size)
        sized.height = 100
        return sized
    }
}
