//
//  MyProfileViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import FlexiblePageControl
import MagazineLayout

class MyProfileViewController: UIViewController , UIScrollViewDelegate{
   var editBtn:UIButton!
    
    let scrollSize: CGFloat = 350
    let numberOfPage: Int = 100
    var pageControl:FlexiblePageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        editBtn = UIButton()
        editBtn.setTitle("Edit", for:UIControl.State.normal)
        editBtn.backgroundColor = UIColor.blue
        editBtn.frame = CGRect(x: (self.view.frame.width - 100 ) , y: 50, width: 50, height: 50)
        view.addSubview(editBtn)
        
        pageControl = FlexiblePageControl()
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRect(x: (self.view.frame.width - scrollSize ) * 0.5, y: 100, width: scrollSize, height: scrollSize)
        //scrollView.center = view.center
        scrollView.contentSize = CGSize(width: scrollSize * CGFloat(numberOfPage), height: scrollSize)
        scrollView.isPagingEnabled = true
        
        pageControl.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)
        pageControl.numberOfPages = numberOfPage
        
        for index in  0..<numberOfPage {
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * scrollSize, y: 0, width: scrollSize, height: scrollSize))
            let _index = index % 10
            let imageNamed = NSString(format: "image%02d.jpg", _index)
            view.image = UIImage(named: imageNamed as String)
            scrollView.addSubview(view)
        }

        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
    
        
        view.addSubview(collectionView)
        
        
        
        
        
        collectionView.frame = CGRect(x: 0, y: self.view.frame.height - 400, width: self.view.frame.width, height: 400)
        
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            ])
        
        loadDefaultData()
    }
    private lazy var collectionView: UICollectionView = {
        let layout = MagazineLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.description())
        collectionView.register(
            Header.self,
            forSupplementaryViewOfKind: MagazineLayout.SupplementaryViewKind.sectionHeader,
            withReuseIdentifier: Header.description())
        collectionView.isPrefetchingEnabled = false
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 1, bottom: 24, right: 1)
        return collectionView
    }()
    private var lastItemCreationPanelViewState: ItemCreationPanelViewState?
    private lazy var dataSource = DataSource()
    
//    private func removeAllData() {
//        for sectionIndex in (0..<dataSource.numberOfSections).reversed() {
//            dataSource.removeSection(atSectionIndex: sectionIndex)
//        }
//
//        collectionView.reloadData()
//    }
    
    private func loadDefaultData() {
        //removeAllData()
        
        let section0 = SectionInfo(
            headerInfo: HeaderInfo(
                visibilityMode: .visible(heightMode: .dynamic),
                title: "Tsukasa"),
            itemInfos: [
                ItemInfo(
                    sizeMode: MagazineLayoutItemSizeMode(
                        widthMode: .fullWidth(respectsHorizontalInsets: true),
                        heightMode: .dynamic),
                    text: "ここにプロフィールを書いていく",
                    color: Colors.blue)
                ])
        

        
        dataSource.insert(section0, atSectionIndex: 0)
     
        
        collectionView.reloadData()
    }

    @objc func backToMap(_ sender: UIButton) {
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        
    }



}

extension  MyProfileViewController: UICollectionViewDelegateMagazineLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeModeForItemAt indexPath: IndexPath)
        -> MagazineLayoutItemSizeMode
    {
        return dataSource.sectionInfos[indexPath.section].itemInfos[indexPath.item].sizeMode
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        visibilityModeForHeaderInSectionAtIndex index: Int)
        -> MagazineLayoutHeaderVisibilityMode
    {
        return dataSource.sectionInfos[index].headerInfo.visibilityMode
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        visibilityModeForBackgroundInSectionAtIndex index: Int)
        -> MagazineLayoutBackgroundVisibilityMode
    {
        return .hidden
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        horizontalSpacingForItemsInSectionAtIndex index: Int)
        -> CGFloat
    {
        return 12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        verticalSpacingForElementsInSectionAtIndex index: Int)
        -> CGFloat
    {
        return 12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetsForItemsInSectionAtIndex index: Int)
        -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
}

extension MyProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            if dataSource.numberOfItemsInSection(withIndex: indexPath.section) > 1 {
                dataSource.removeItem(atItemIndex: indexPath.item, inSectionAtIndex: indexPath.section)
                collectionView.deleteItems(at: [indexPath])
            } else {
//                dataSource.removeSection(atSectionIndex: indexPath.section)
//                collectionView.deleteSections(IndexSet(integer: indexPath.section))
            }
        }, completion: nil)
    }
    
}
