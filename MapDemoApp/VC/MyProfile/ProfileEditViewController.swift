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
    
    var doneButtonTapHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        
        scrview.contentSize = CGSize(width: 300, height: 1400)
        scrview.indicatorStyle = .black
        scrview.backgroundColor = UIColor.white.dark()
        self.view.addSubview(scrview)
        
        for i in 0..<1{
            profimgs.append(UIImageView(frame: CGRect(x:30 , y: 30, width: 60, height: 100)))
            profimgs[i].image = UIImage(named: "frame.png")
            scrview.addSubview(profimgs[i])
        }
        
        textEditer.backgroundColor = UIColor.white
        textEditer.text = state
        self.scrview.addSubview(textEditer)
      
        
        
        
 
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
  
        scrview.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        textEditer.frame = CGRect(x: 0, y: self.scrview.frame.height - 500, width: self.view.frame.width, height: 500)
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
