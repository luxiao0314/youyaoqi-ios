//
//  UCollectListViewController.swift
//  U17
//
//  Created by charles on 2017/10/24.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit
import Toast_Swift

class URankListViewController: UBaseViewController {
    
    private var rankList = [RankingModel]()
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        
        self.tableView.uHead?.beginRefreshing()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: URankTCell.self)
        //URefreshHeader页面初始化会主动loadData
        tableView.uHead = URefreshHeader{ [weak self] in self?.loadData() }
        tableView.uempty = UEmptyView { [weak self] in self?.loadData() }
        tableView.uFoot = URefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        return tableView
    }()
    
    private func loadData() {
        //请求排行列表
        ApiProvider.request(UApi.rankList, model: RankinglistModel.self) { (returnData) in
            self.rankList = returnData?.rankinglist ?? []
            //停止刷新
            self.tableView.uHead?.endRefreshing()
            self.tableView.uempty?.allowShow = true
            //重新加载数据
            self.tableView.reloadData()
        }
    }
}

extension URankListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: URankTCell.self)
        cell.model = rankList[indexPath.row]
        return cell
    }
    
    /**
     不设置cell高度,切换页面会导致cell高度有问题
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.makeToast(rankList[indexPath.row].title)
    }
    
}
