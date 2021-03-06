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
        
        /// 书架
        let onePageVC = UHomeViewController(titles: ["推荐","VIP","订阅","排行"],
                                            vcs:[UBoutiqueListViewController(),
                                                 UVIPListViewController(),
                                                 USubscibeListViewController(),
                                                 URankListViewController()],
                                            pageStyle: .navgationBarSegment)
        
        addChildViewController(controller:onePageVC,
                               title: "首页",
                               image: UIImage(named: "tab_home"),
                               selectedImage: UIImage(named: "tab_home_S"))
        
        addChildViewController(controller: UCateListViewController(),
                               title: "分类",
                               image: UIImage(named: "tab_class"),
                               selectedImage: UIImage(named: "tab_class_S"))
        
        /// 书架
        let bookVC = UBookViewController(titles: ["收藏","书单","下载"],
                                         vcs: [UCollectListViewController(),
                                               UDocumentListViewController(),
                                               UDownloadListViewController()],
                                         pageStyle: .navgationBarSegment)
        
        addChildViewController(controller: bookVC,
                               title: "书架",
                               image: UIImage(named: "tab_book"),
                               selectedImage: UIImage(named: "tab_book_S"))
        
        addChildViewController(controller: UMineViewController(),
                               title: "我的",
                               image: UIImage(named: "tab_mine"),
                               selectedImage: UIImage(named: "tab_mine_S"))
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
