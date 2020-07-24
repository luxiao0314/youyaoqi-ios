
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
        view.addSubview(contentView)
        contentView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
        self.contentView.uHead?.beginRefreshing()
    }
    
    lazy var contentView : UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.delegate = self
        cw.dataSource = self
        cw.register(cellType: UComicCCell.self)
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        //URefreshHeader页面初始化会主动loadData
        cw.uHead = URefreshHeader{ [weak self] in self?.loadData() }
        cw.uempty = UEmptyView { [weak self] in self?.loadData() }
        cw.uFoot = URefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        return cw
    }()
    
    private func loadData() {
        
        ApiProvider.request(UApi.subscribeList, model: SubscribeListModel.self) { (data) in
            self.subscribeList = data?.newSubscribeList ?? []
            
            self.contentView.uempty?.allowShow = true
            self.contentView.uHead?.endRefreshing()
            //重新加载数据
            self.contentView.reloadData()
        }
    }
}

extension USubscibeListViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        let comicList = subscribeList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscribeList.count
    }
}
