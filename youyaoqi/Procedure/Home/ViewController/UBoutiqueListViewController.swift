//
//  File.swift
//  youyaoqi
//
//  Created by luxiao on 2020/8/18.
//  Copyright © 2020 lucio. All rights reserved.
//

import Foundation
import UIKit
import LLCycleScrollView

class UBoutiqueListViewController: UBaseViewController {
    
    private var comicLists = [ComicListModel]()
    private var galleryItems = [GalleryItemModel]()
    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(collectionView.contentInset.top)
        }
        
        self.collectionView.uHead?.beginRefreshing()
    }
    
    private lazy var bannerView: LLCycleScrollView = {
        let bw = LLCycleScrollView()
        bw.backgroundColor = UIColor.background
        bw.autoScrollTimeInterval = 6
        bw.placeHolderImage = UIImage(named: "normal_placeholder")
        bw.coverImage = UIImage()
        bw.pageControlPosition = .right
        bw.pageControlBottom = 20
        bw.titleBackgroundColor = UIColor.clear
//        bw.lldidSelectItemAtIndex = didSelectBanner(index:)
        return bw
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: UComicCCell.self)
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        cw.uHead = URefreshHeader{ [weak self] in self?.loadData() }
        cw.uFoot = URefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        cw.uempty = UEmptyView { [weak self] in self?.loadData() }
        return cw
    }()
    
    private func loadData() {
        ApiProvider.request(UApi.boutiqueList(sexType: 3), model: BoutiqueListModel.self) { (data) in
            self.collectionView.uHead?.endRefreshing()
            self.collectionView.uempty?.allowShow = true
            
            self.comicLists = data?.comicLists ?? []
            self.galleryItems = data?.galleryItems ?? []
            self.bannerView.imagePaths = self.galleryItems.filter { $0.cover != nil }.map { $0.cover! }
            self.collectionView.reloadData()
        }
    }
}

extension UBoutiqueListViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.prefix(4).count ?? 0
    }
    
    //header样式
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    //footer样式
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    //header和footer数据填充
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UComicCHead.self)
                let comicList = comicLists[indexPath.section]
                head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
                head.titleLabel.text = comicList.itemTitle
                head.moreButton.isHidden = !comicList.canMore
                return head
            } else {
                let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: UComicCFoot.self)
                return foot
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
    
        cell.style = .withTitle
        let comicList = comicLists[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }
    
}
