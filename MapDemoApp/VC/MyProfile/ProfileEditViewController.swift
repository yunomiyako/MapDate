//
//  ProfileEditViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import TinyConstraints

final class EditProfileViewController: UIViewController {
    
    let textEditer = UITextView()
    let scrview = UIScrollView()
    let navBar = UINavigationBar()
    let navItem = UINavigationItem(title: "プロフィール編集")
    let navigationView = UIView()
    var state = ""
    var profimgs = [UIImageView]()
    var profimgBtns = [UIButton]()
    var tmp = false
    var doneButtonTapHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrview.indicatorStyle = .black
        scrview.backgroundColor = UIColor.white.dark()
        self.view.addSubview(scrview)
        
        for i in 0..<6{
            profimgs.append(UIImageView())
            profimgs[i].image = UIImage(named: "frame.png")
            scrview.addSubview(profimgs[i])
            profimgBtns.append(UIButton())
            profimgBtns[i].setImage(UIImage(named:"addimg.png"), for: UIControl.State.normal)
            scrview.addSubview(profimgBtns[i])
        }

        
        textEditer.backgroundColor = UIColor.white
        textEditer.text = state
        self.scrview.addSubview(textEditer)
      
        

    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

        scrview.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrview.contentSize = CGSize(width:0, height: scrview.frame.height * 1.5)
        let scrhalfY = self.scrview.frame.height * 0.5
        let scrhalfX = self.scrview.frame.width * 0.5
        let prfpos1 = scrhalfY * 0.25
        
        for i in 0..<6{
            
            if i < 3{
                profimgs[i].frame = CGRect(x: 0, y: prfpos1, width: self.scrview.frame.width * 0.22, height: scrhalfY * 0.3)
                profimgBtns[i].frame = CGRect(x: 0, y: prfpos1 * 2, width: profimgs[i].frame.width * 0.3, height: profimgs[i].frame.width * 0.3)
            }else{
                profimgs[i].frame = CGRect(x: 0, y: prfpos1 + (scrview.frame.width * 0.22)+prfpos1 * 0.5, width: self.scrview.frame.width * 0.22, height: scrhalfY * 0.3)
                profimgBtns[i].frame = CGRect(x: 0, y:prfpos1 * 2 + scrhalfY * 0.35, width: profimgs[i].frame.width * 0.3, height: profimgs[i].frame.width * 0.3)
            }
            switch (i+1)%3{
            case 1:
                profimgs[i].frame.origin.x = scrhalfX * 0.2
            case 2:
                profimgs[i].frame.origin.x = scrhalfX * 0.8
            case 0:
                profimgs[i].frame.origin.x = scrhalfX * 1.4
            default: print("err")
            }
            profimgBtns[i].frame.origin.x = profimgs[i].frame.minX + profimgs[i].frame.width * 0.75
        }
        
        
        textEditer.frame = CGRect(x: 0, y: self.scrview.frame.height - (scrhalfY), width: self.view.frame.width, height: (scrhalfY))

        addNavBackView()
        addNavigationBar()
    }
    
    
    @objc private func doneButtonTapped() {
        doneButtonTapHandler?(textEditer.text)
        dismiss(animated: true, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addNavigationBar(){
      
        self.view.addSubview(navBar)
        //navigationBarの色を透明にする
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .done,
                    target: self,
                    action: #selector(doneButtonTapped))
        navItem.hidesBackButton = true
        
        navBar.pushItem(navItem, animated: true)
        //navigationBarのサイズと位置を調整
        if #available(iOS 11.0, *) {
            //iOS11よりも上だったら(iPhoneXだろうがiPhone8だろうがiOSが11より上ならこっちでまとめて対応できる)
            navBar.frame.origin = self.view.safeAreaLayoutGuide.layoutFrame.origin
            navBar.frame.size = CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: 44)
        }else{
            //もしもiOS11よりも下だったら
            navBar.frame.origin = self.view.frame.origin
            navBar.frame.size = CGSize(width: self.view.frame.width, height: 44)
        }
    }
    func addNavBackView(){
        
        self.view.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.white
        //navigationBarの背景のサイズと位置を調整
        if #available(iOS 11.0, *) {
            navigationView.frame.origin = self.view.safeAreaLayoutGuide.owningView!.frame.origin
            navigationView.frame.size = CGSize(width: self.view.safeAreaLayoutGuide.owningView!.frame.width, height: navBar.frame.origin.y + navBar.frame.height)
        }else{
            navigationView.frame.origin = self.view.frame.origin
            navigationView.frame.size = CGSize(width: self.view.frame.width, height: navBar.frame.origin.y + navBar.frame.height)
        }
    }
}
