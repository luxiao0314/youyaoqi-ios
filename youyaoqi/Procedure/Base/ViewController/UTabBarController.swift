//
//  UTabBarController.swift
//  youyaoqi
//
//  Created by lucio on 2020/7/19.
//  Copyright © 2020 lucio. All rights reserved.
//

import Foundation

import UIKit

class UTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        
        let classVC = UCateListViewController()
        
        addChildViewController(controller: classVC,
                               title: "分类",
                               image: UIImage(named: "tab_class"),
                               selectedImage: UIImage(named: "tab_class_S"))
        
        let childController = UCateListViewController()
        
        addChildViewController(controller: childController,
                               title: "我的",
                               image: UIImage(named: "tab_class"),
                               selectedImage: UIImage(named: "tab_class_S"))
    }
    
    func addChildViewController(controller:UIViewController,title:String?,
                                image:UIImage?,selectedImage:UIImage?) {
        
        
        controller.title = title
        controller.tabBarItem = UITabBarItem(title: nil,
                                             image: image?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(UNavigationController(rootViewController: controller))
    }
}

extension UTabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}
