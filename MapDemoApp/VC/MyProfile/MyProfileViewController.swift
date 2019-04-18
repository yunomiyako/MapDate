//
//  MyProfileViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//
import UIKit
import FlexiblePageControl
//import MagazineLayout
import TinyConstraints
import SwiftIcons


class MyProfileViewController: UIViewController , UIScrollViewDelegate{
    var editBtn:UIButton!
    var backBtn:UIButton!
    let scrollView = UIScrollView()
    let textView = UITextView()
    let numberOfPage: Int = 9
    let pageControl = FlexiblePageControl()
    let baceScrview = UIScrollView()
    let alphaView = UIView()
    let user = FirebaseUseCase().getCurrentUser()
    let cfuncs = CommonFuncs()
    let nameAgeLabel = UILabel()
    let jobLabel = UILabel()
    let rangeLabel = UILabel()
    let line = UILabel()
    var state = "No Info"
    var job = "No Info"
    var distance = "5"
    var age = "24"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        baceScrview.backgroundColor = UIColor.white
        baceScrview.scrollIndicatorInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        baceScrview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/* - self.view.frame.height * 0.1*/)
        
        self.view.addSubview(baceScrview)
        
        editBtn = UIButton()
        editBtn.setTitle("EDIT INFO", for:UIControl.State.normal)
        editBtn.setShadow()
        editBtn.setRound(cornerRadius: 20.0)
        editBtn.layer.borderWidth = 0.3 // 枠線の幅
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
        
        scrollView.isPagingEnabled = true
        scrollView.indicatorStyle = .white
        pageControl.pageIndicatorTintColor = UIColor.clear
        pageControl.currentPageIndicatorTintColor = UIColor.clear
        pageControl.numberOfPages = numberOfPage
        
        
        baceScrview.addSubview(scrollView)
        
        baceScrview.addSubview(pageControl)
        
        baceScrview.addSubview(nameAgeLabel)
        baceScrview.addSubview(jobLabel)
        baceScrview.addSubview(rangeLabel)
        baceScrview.addSubview(line)
        baceScrview.addSubview(textView)
        
        backBtn = UIButton()
        backBtn.setImage(UIImage(named:"back.png"), for: UIControl.State.normal)
        backBtn.addTarget(self,
                          action: #selector(back(sender:)),
                          for: .touchUpInside)
        baceScrview.addSubview(backBtn)
        
        nameAgeLabel.backgroundColor = .white
        nameAgeLabel.textColor = .black
        jobLabel.backgroundColor = .white
        jobLabel.textColor = .gray
        rangeLabel.backgroundColor = .white
        rangeLabel.textColor = .gray
        line.backgroundColor = UIColor(white:0.8, alpha:1.0)
        
        
        textView.backgroundColor = UIColor.white
        
        textView.text = state
        textView.textColor = UIColor.gray
        textView.font = textView.font?.withSize(20)
        textView.isEditable = false
        
        
        loadData()
    }
    
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        var scrollY:CGFloat!
        for index in  0..<numberOfPage {
            let _index = index % 10
            let imageNamed = NSString(format: "image%02d.jpg", _index)
            var img = UIImage(named: imageNamed as String)
            img = cfuncs.resize(image: img!, width: Double(self.view.frame.width))
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * (self.view.frame.width), y: 0, width: self.view.frame.width, height: (img?.size.height)!))
            view.isUserInteractionEnabled = true
            view.image = img
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(imageViewTapped(_:)))
            view.addGestureRecognizer(tap)
            scrollY = img?.size.height
            scrollView.addSubview(view)
        }
        
        scrollView.frame = CGRect(x: 0, y: 0, width:self.view.frame.width, height: scrollY)
        scrollView.contentSize = CGSize(width:self.view.frame.width * CGFloat(numberOfPage), height: scrollY)
        
        let marginY = (self.view.frame.height * 0.18)/12
        
        nameAgeLabel.frame = CGRect(x: 0, y: scrollView.frame.maxY + marginY, width: self.view.frame.width, height: (self.view.frame.height * 0.18)/3)
        nameAgeLabel.sizeToFit()
        jobLabel.frame = CGRect(x: 0, y: nameAgeLabel.frame.maxY + marginY, width: self.view.frame.width, height: (self.view.frame.height * 0.18)/6)
        jobLabel.sizeToFit()
        rangeLabel.frame = CGRect(x: 0, y: jobLabel.frame.maxY + marginY, width: self.view.frame.width, height: (self.view.frame.height * 0.18)/6)
        rangeLabel.sizeToFit()
        line.frame = CGRect(x: 0, y: rangeLabel.frame.maxY + marginY, width: self.view.frame.width, height: 0.5)
        
        
        textView.frame = CGRect(x:view.frame.width*0.025, y: line.frame.maxY + marginY , width: view.frame.width*0.95, height: textView.contentSize.height)
        
        let baceInfoH = nameAgeLabel.frame.height + jobLabel.frame.height + rangeLabel.frame.height
        
        editBtn.width(125)
        editBtn.height(45)
        editBtn.bottomToSuperview(offset:-5 ,usingSafeArea:true)
        editBtn.centerXToSuperview()
        let backBtnsize = self.view.frame.width * 0.13
        
        backBtn.frame = CGRect(x: self.view.frame.width * 0.8, y:scrollView.frame.maxY - (backBtnsize * 0.5) , width: backBtnsize, height: backBtnsize)
        backBtn.imageView?.contentMode = .scaleAspectFit
        
        let baceHeight = scrollY + baceInfoH + textView.frame.height*1.5
        baceScrview.contentSize = CGSize(width:0, height: baceHeight)
    }
    
    
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer){
        
        
    }
    @objc func editProfile(sender : AnyObject) {
        let vc = EditProfileViewController()
        vc.state = self.state
        vc.nameField.text = user.displayName ?? "NO NAME"
        vc.ageField.text = age
        vc.jobTitleField.text = job
        vc.doneButtonTapHandler = { [weak self] state in
            self!.state = state
            self!.loadData()
            self!.textView.frame = CGRect(x:self!.view.frame.width*0.025, y: self!.scrollView.frame.maxY+self!.view.frame.height * 0.18, width: self!.view.frame.width*0.95, height: self!.textView.contentSize.height)
            let baceInfoH = self!.nameAgeLabel.frame.height + self!.jobLabel.frame.height + self!.rangeLabel.frame.height
            let baceHeight = self!.scrollView.frame.height + baceInfoH + self!.textView.frame.height*1.5
            self!.baceScrview.contentSize = CGSize(width:0, height: baceHeight)
        }
        
        self.present(vc, animated: true)
    }
    
    @objc func back(sender : AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    private func loadData() {
        
        let nameStr = "  \(user.displayName ?? "NO NAME")"
        let ageStr = "  \(age)"
        let strs = nameStr + ageStr
        let attrText = NSMutableAttributedString(string: strs)
        
        //サイズ
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        //5SとSEのとき
        if myBoundSize.width == 320.0 && myBoundSize.height == 568.0{
            nameAgeLabel.font = UIFont.boldSystemFont(ofSize: 25)
            attrText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 31)], range: NSMakeRange(0, nameStr.count))
        }else{
            nameAgeLabel.font = UIFont.boldSystemFont(ofSize: 37)
            attrText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 39)], range: NSMakeRange(0, nameStr.count))
        }
        
        
        nameAgeLabel.attributedText = attrText
        
        
        jobLabel.setIcon(prefixText: "   ", prefixTextColor: .gray, icon: .icofont(.bagAlt), iconColor: .gray, postfixText: "  \(job)", postfixTextColor: .gray, size: nil, iconSize: 15)
        rangeLabel.setIcon(prefixText: "   ", prefixTextColor: .gray, icon: .icofont(.locationPin), iconColor: .gray, postfixText: "  \(distance) kilometers away", postfixTextColor: .gray, size: nil, iconSize: 15)
        
        
        textView.text = state
        let TVheight = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        textView.frame.size.height = TVheight
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        
    }
    
    
    
}
