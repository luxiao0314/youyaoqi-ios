//
//  UCollectListViewController.swift
//  U17
//
//  Created by charles on 2017/10/24.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit

class URankListViewController: UBaseViewController {
    
    private var rankList = [RankingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: URankTCell.self)
        return tableView
    }()
    
    private func loadData() {
        //请求排行列表
        ApiLoadingProvider.request(UApi.rankList, model: RankinglistModel.self) { (returnData) in
            self.rankList = returnData?.rankinglist ?? []
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
    
}
