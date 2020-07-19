//
//  UCateListViewController.swift
//  youyaoqi
//
//  Created by lucio on 2020/7/19.
//  Copyright © 2020 lucio. All rights reserved.
//

import Foundation

import UIKit

class UCateListViewController: UBaseViewController {
    
    override func viewDidLoad() {
        edgesForExtendedLayout = .top
    }
    
    override func configUI() {
        let titileLabel = UILabel().then{
            $0.text = "作品介绍"
        }
        view.addSubview(titileLabel)
        
        titileLabel.snp.makeConstraints{
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
    }
    
    override func configNavigationBar() {
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: nil,style: .plain,target: nil,action: nil)
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: nil,style: .plain,target: nil,action: nil)
    }
}
