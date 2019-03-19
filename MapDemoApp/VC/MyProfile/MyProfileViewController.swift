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
import TinyConstraints


class MyProfileViewController: UIViewController , UIScrollViewDelegate{
    var editBtn:UIButton!
    var backBtn:UIButton!
    let scrollView = UIScrollView()
    let scrollSize: CGFloat = 350
    let numberOfPage: Int = 6
    let pageControl = FlexiblePageControl()
    let baceScrview = UIScrollView()
    let alphaView = UIView()
    var state = "ここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていくここにプロフィールを書いていく"
    var job = "学生"
    var distance = "5"
    var age = "24"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        baceScrview.backgroundColor = UIColor.white
        baceScrview.scrollIndicatorInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        baceScrview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/* - self.view.frame.height * 0.1*/)
        baceScrview.contentSize = CGSize(width:0, height: baceScrview.frame.height * 1.5)
        self.view.addSubview(baceScrview)
        
        editBtn = UIButton()
        editBtn.setTitle("EDIT INFO", for:UIControl.State.normal)
        editBtn.setShadow()
        editBtn.setRound(cornerRadius: 20.0)
        editBtn.layer.borderWidth = 2.0 // 枠線の幅
        editBtn.layer.borderColor = UIColor.white.dark().cgColor // 枠線の色
        editBtn.setTitleColor(UIColor.red,for: UIControl.State.normal)
        //editBtn.layer.cornerRadius = 10.0 // 角丸のサイズ
        editBtn.backgroundColor = UIColor.white
        editBtn.addTarget(self,
                         action: #selector(editProfile(sender:)),
                         for: .touchUpInside)
        alphaView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        alphaView.frame = CGRect(x: 0, y: view.frame.height - view.frame.height * 0.1, width: self.view.frame.width, height: view.frame.height * 0.1)
        self.view.addSubview(alphaView)
        alphaView.addSubview(editBtn)
        
        
        
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width:self.view.frame.width, height: scrollSize)
        scrollView.contentSize = CGSize(width:self.view.frame.width * CGFloat(numberOfPage), height: scrollSize)
        scrollView.isPagingEnabled = true
        pageControl.pageIndicatorTintColor = UIColor.clear
        pageControl.numberOfPages = numberOfPage
        
        for index in  0..<numberOfPage {
            let _index = index % 10
            let imageNamed = NSString(format: "image%02d.jpg", _index)
            var img = UIImage(named: imageNamed as String)
            img = resize(image: img!, width: Double(self.view.frame.width))
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * (self.view.frame.width), y: 0, width: self.view.frame.width, height: (img?.size.height)!))
            view.image = img
            scrollView.addSubview(view)
        }

        baceScrview.addSubview(scrollView)
        
        baceScrview.addSubview(pageControl)
        
        baceScrview.addSubview(collectionView)
        baceScrview.addSubview(collectionView2)
        
        backBtn = UIButton()
        backBtn.setImage(UIImage(named:"back.png"), for: UIControl.State.normal)
        backBtn.addTarget(self,
                          action: #selector(back(sender:)),
                          for: .touchUpInside)
        baceScrview.addSubview(backBtn)
        
        collectionView.backgroundColor = UIColor.white
        
        collectionView.frame = CGRect(x: 0, y: scrollView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height * 0.18)
        collectionView2.backgroundColor = UIColor.white
        
        collectionView2.frame = CGRect(x:view.frame.width*0.025, y: scrollView.frame.maxY+view.frame.height * 0.18, width: view.frame.width*0.95, height: self.view.frame.height * 0.5)
        

        
        loadDefaultData()
    }
    
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        editBtn.width(self.view.frame.width * 0.3)
        editBtn.height(self.view.frame.width * 0.3 * 0.4)
        editBtn.bottomToSuperview(usingSafeArea:true)
        editBtn.centerXToSuperview()
        let backBtnsize = self.view.frame.width * 0.13
    
        backBtn.frame = CGRect(x: self.view.frame.width * 0.8, y:scrollView.frame.maxY - (backBtnsize * 0.5) , width: backBtnsize, height: backBtnsize)
        backBtn.imageView?.contentMode = .scaleAspectFit
        
    }
    
    
    @objc func editProfile(sender : AnyObject) {
        let vc = EditProfileViewController()
        vc.state = self.state
        vc.doneButtonTapHandler = { [weak self] state in
            self!.state = state
            self!.loadDefaultData()
        }
        
        
        self.present(vc, animated: true)
        
    }
    
    @objc func back(sender : AnyObject) {
     
            self.dismiss(animated: true, completion: nil)
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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        return collectionView
    }()
    private lazy var collectionView2: UICollectionView = {
        let layout = MagazineLayout()
        let collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView2.register(Cell.self, forCellWithReuseIdentifier: Cell.description())
        collectionView2.register(
            Header.self,
            forSupplementaryViewOfKind: MagazineLayout.SupplementaryViewKind.sectionHeader,
            withReuseIdentifier: Header.description())
        collectionView2.isPrefetchingEnabled = false
        collectionView2.dataSource = dataSource2
        collectionView2.delegate = self
        collectionView2.backgroundColor = .white
        collectionView2.contentInsetAdjustmentBehavior = .always
        collectionView2.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 24, right: 1)
        return collectionView2
    }()
    
  
    
    private lazy var dataSource = DataSource()
    private lazy var dataSource2 = DataSource()
    
    private func removeAllData() {
        for sectionIndex in (0..<dataSource.numberOfSections).reversed() {
            dataSource.removeSection(atSectionIndex: sectionIndex)
        }

        collectionView.reloadData()
    }
    
    private func loadDefaultData() {
        removeAllData()
        
        let jobSec:ItemInfo!
        let distanceSec:ItemInfo!
        let ageSec:ItemInfo!
        let emptySec = ItemInfo( sizeMode: MagazineLayoutItemSizeMode(
            widthMode: .fullWidth(respectsHorizontalInsets: true),
            heightMode: .static(height: 0)),
                                 text: "",
                                 color: UIColor.white)
        if age == ""{
            ageSec = emptySec
        }else{
            
            ageSec = ItemInfo(
                sizeMode: MagazineLayoutItemSizeMode(
                    widthMode: .fullWidth(respectsHorizontalInsets: true),
                    heightMode: .dynamic),
                text: "age:\(age)",
                color: UIColor.white)
        }
        
        if job == ""{
            jobSec = emptySec
        }else{
            
           jobSec = ItemInfo(
                sizeMode: MagazineLayoutItemSizeMode(
                    widthMode: .fullWidth(respectsHorizontalInsets: true),
                    heightMode: .dynamic),
                text: "job:\(job)",
                color: UIColor.white)
        }
        
        if distance == ""{
            distanceSec = emptySec
        }else{
            
            distanceSec = ItemInfo(
                sizeMode: MagazineLayoutItemSizeMode(
                    widthMode: .fullWidth(respectsHorizontalInsets: true),
                    heightMode: .dynamic),
                text: "\(distance) kilometers away",
                color: UIColor.white)
        }
        
        let section = SectionInfo(
            headerInfo: HeaderInfo(
                visibilityMode: .visible(heightMode: .dynamic),
                title: "Micasa"),
            itemInfos: [
                ageSec,
                jobSec,
                distanceSec,
                ItemInfo(
                    sizeMode: MagazineLayoutItemSizeMode(
                        widthMode: .fullWidth(respectsHorizontalInsets: true),
                        heightMode: .static(height: 1)),
                        text: "",
                        color: UIColor.gray)
                ])
        let section2 = SectionInfo(
            headerInfo: HeaderInfo(
                visibilityMode: .visible(heightMode: .dynamic),
                title: ""),
            itemInfos: [
                ItemInfo(
                    sizeMode: MagazineLayoutItemSizeMode(
                        widthMode: .fullWidth(respectsHorizontalInsets: true),
                        heightMode: .dynamic),
                    text: state,
                    color: UIColor.white)
            ])

        
        dataSource.insert(section, atSectionIndex: 0)
        dataSource2.insert(section2, atSectionIndex: 0)
     
        
        collectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        
    }

    func resize(image: UIImage, width: Double) -> UIImage {
        
        // オリジナル画像のサイズからアスペクト比を計算
        let aspectScale = image.size.height / image.size.width
        
        // widthからアスペクト比を元にリサイズ後のサイズを取得
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
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
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetsForItemsInSectionAtIndex index: Int)
        -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension MyProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            if dataSource.numberOfItemsInSection(withIndex: indexPath.section) > 1 {
//                dataSource.removeItem(atItemIndex: indexPath.item, inSectionAtIndex: indexPath.section)
//                collectionView.deleteItems(at: [indexPath])
            } else {
//                dataSource.removeSection(atSectionIndex: indexPath.section)
//                collectionView.deleteSections(IndexSet(integer: indexPath.section))
            }
        }, completion: nil)
    }
    
}
