//
//  ProfileEditViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import TinyConstraints

final class EditProfileViewController: UIViewController,UITextViewDelegate {
    
    let textEditer = UITextView()
    let scrview = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrview.contentSize = CGSize(width: 300, height: 1400)
        // スクロールバーの見た目と余白
        scrview.indicatorStyle = .black
        scrview.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        view.backgroundColor = UIColor.gray
        
        textEditer.delegate = self
        textEditer.backgroundColor = UIColor.white
        self.view.addSubview(scrview)
        self.scrview.addSubview(textEditer)
        
        
 
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        //scrview.edgesToSuperview(insets: TinyEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        scrview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        //textEditer.center = self.scrview.center
        //textEditer.edgesToSuperview(insets: TinyEdgeInsets(top: 400, left: 10, bottom: 30, right: 10))
        textEditer.frame = CGRect(x: 0, y: self.view.frame.height - 500, width: self.view.frame.width, height: 500)
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
