
//
//  File.swift
//  youyaoqi
//
//  Created by luxiao on 2020/7/23.
//  Copyright © 2020 lucio. All rights reserved.
//
import UIKit

class USubscibeListViewController: UBaseViewController {
    
    private var subscribeList = [ComicListModel]()
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        self.tableView.uHead?.beginRefreshing()
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: UComicCCell.self)
        //URefreshHeader页面初始化会主动loadData
        tableView.uHead = URefreshHeader{ [weak self] in self?.loadData() }
        tableView.uempty = UEmptyView { [weak self] in self?.loadData() }
        tableView.uFoot = URefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        return tableView
    }()
    
    private func loadData() {
        
        ApiProvider.request(UApi.subscribeList, model: SubscribeListModel.self) { (data) in
            self.subscribeList = data?.newSubscribeList ?? []
            
            self.tableView.uempty?.allowShow = true
            self.tableView.uHead?.endRefreshing()
            //重新加载数据
            self.tableView.reloadData()
        }
    }
}

extension USubscibeListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.model = subscribeList[indexPath.row]
        return cell
    }
    
    /**
     不设置cell高度,切换页面会导致cell高度有问题
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.4
    }
}
