//
//  ProfileEditViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/11.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import TinyConstraints

final class EditProfileViewController: UIViewController, UITextViewDelegate {
    
    let textEditer = UITextView()
    let scrview = UIScrollView()
    let navBar = UINavigationBar()
    let navItem = UINavigationItem(title: "Edit Info")
    let navigationView = UIView()
    var state = ""
    var profimgs = [UIImageView]()
    var profimgBtns = [UIButton]()
    var tmp = false
    var doneButtonTapHandler: ((String) -> Void)?
    var selectedFrame:Int!
    let photos = UILabel()
    let name = UILabel()
    let nameField = UITextField()
    let abouMe = UILabel()
    let age = UILabel()
    let ageField = UITextField()
    let jobTilte = UILabel()
    let jobTitleField = UITextField()
    var charNumLabel = UILabel()
    var photoNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrview.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        self.view.addSubview(scrview)
        
        photos.text = "PHOTOS"
        scrview.addSubview(photos)
        
        abouMe.text = "ABOUT ME"
        scrview.addSubview(abouMe)
        
        name.text = "NAME"
        scrview.addSubview(name)
        
        age.text = "AGE"
        scrview.addSubview(age)
        
        jobTilte.text = "JOB TITLE"
        scrview.addSubview(jobTilte)
        
        for i in 0..<6{
            profimgs.append(UIImageView())
            profimgs[i].image = UIImage(named: "frame.png")
            scrview.addSubview(profimgs[i])
            profimgBtns.append(UIButton())
            profimgBtns[i].setImage(UIImage(named:"addimg.png"), for: UIControl.State.normal)
            scrview.addSubview(profimgBtns[i])
            profimgBtns[i].addTarget(self,
                                     action: #selector(photoPick(sender:)),
                                     for: .touchUpInside)
            profimgBtns[i].tag = i
        }
        
        nameField.backgroundColor = .white
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.05, height: 0))
        nameField.leftViewMode = UITextField.ViewMode.always
        scrview.addSubview(nameField)
        
        ageField.backgroundColor = .white
        ageField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.05, height: 0))
        ageField.leftViewMode = UITextField.ViewMode.always
        ageField.keyboardType = UIKeyboardType.numberPad
        scrview.addSubview(ageField)
        
        jobTitleField.backgroundColor = .white
        jobTitleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.05, height: 0))
        jobTitleField.leftViewMode = UITextField.ViewMode.always
        scrview.addSubview(jobTitleField)
        
        textEditer.backgroundColor = .white
        textEditer.text = "@" //※ダミーテキストでフォントを設定させる
        textEditer.text = ""
        textEditer.text = state
        textEditer.textColor = UIColor.gray
        textEditer.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 20, right: 10)
        textEditer.font = textEditer.font?.withSize(20)
        textEditer.delegate = self
        self.scrview.addSubview(textEditer)
        charNumLabel.text = String(500-state.count)
        charNumLabel.textColor = UIColor.gray
        self.textEditer.addSubview(charNumLabel)
      
        

    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()

        scrview.scrollIndicatorInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        scrview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrview.contentSize = CGSize(width:0, height: scrview.frame.height * 1.8)
    
        
        let scrhalfY = self.scrview.frame.height * 0.5
        let scrhalfX = self.scrview.frame.width * 0.5
        let prfpos1 = scrhalfY * 0.3
        
        photos.frame = CGRect(x: scrhalfX * 0.1, y: prfpos1 * 0.81, width: scrview.frame.width * 0.22 * 0.8, height: prfpos1*0.45)
        photos.sizeToFit()
        
        for i in 0..<6{
            
            if i < 3{
                profimgs[i].frame = CGRect(x: 0, y: prfpos1, width: self.scrview.frame.width * 0.22, height: scrhalfY * 0.3)
                profimgBtns[i].frame = CGRect(x: 0, y: prfpos1 * 1.85, width: profimgs[i].frame.width * 0.3, height: profimgs[i].frame.width * 0.3)
            }else{
                profimgs[i].frame = CGRect(x: 0, y: prfpos1 + (scrview.frame.width * 0.22)+prfpos1 * 0.5, width: self.scrview.frame.width * 0.22, height: scrhalfY * 0.3)
                profimgBtns[i].frame = CGRect(x: 0, y:prfpos1 * 1.88 + scrhalfY * 0.35, width: profimgs[i].frame.width * 0.3, height: profimgs[i].frame.width * 0.3)
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
        
        let nameFieldY = self.scrview.frame.height - (scrhalfY * 0.9)
        
        name.frame = CGRect(x: scrhalfX * 0.1, y: nameFieldY*0.94 , width: scrview.frame.width * 0.22 * 0.8, height: prfpos1*0.45)
        name.sizeToFit()
        
        nameField.frame = CGRect(x: 0, y: nameFieldY, width: self.view.frame.width, height: scrhalfY*0.1)
        
        let ageFieldY = (nameFieldY + scrhalfY*0.1)*1.1
        
        age.frame = CGRect(x: scrhalfX * 0.1, y: ageFieldY*0.95 , width: scrview.frame.width * 0.22 * 0.8, height: prfpos1*0.45)
        age.sizeToFit()
        
        ageField.frame = CGRect(x: 0, y: ageFieldY, width: self.view.frame.width, height: scrhalfY*0.1)
        
        let textEditerY = (ageFieldY + scrhalfY*0.1)*1.1
        
        abouMe.frame = CGRect(x: scrhalfX * 0.1, y: textEditerY*0.96 , width: scrview.frame.width * 0.22 * 0.8, height: prfpos1*0.45)
        abouMe.sizeToFit()
        
        textEditerSet()
        addNavBackView()
        addNavigationBar()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let charNum = textEditer.text.count
        charNumLabel.text = String(500 - charNum)
        textEditerSet()
        let beforeStr = textEditer.text
        if textEditer.text.count > 500 { // 500字を超えた時
            // 以下，範囲指定する
            let zero = beforeStr!.startIndex
            let start = beforeStr!.index(zero, offsetBy: 0)
            let end = beforeStr?.index(zero, offsetBy: 499)
            textEditer.text = String(beforeStr![start..<end!])
        }
    }
    
    func textEditerSet(){
        let scrhalfX = self.scrview.frame.width * 0.5
        let scrhalfY = self.scrview.frame.height * 0.5
        let prfpos1 = scrhalfY * 0.3
        let nameFieldY = self.scrview.frame.height - (scrhalfY * 0.9)
        let ageFieldY = (nameFieldY + scrhalfY*0.1)*1.1
        let textEditerY = (ageFieldY + scrhalfY*0.1)*1.1
        let TEheight = textEditer.sizeThatFits(CGSize(width: textEditer.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        textEditer.frame = CGRect(x: 0, y: textEditerY, width: self.view.frame.width, height: TEheight*1.2)
        charNumLabel.frame = CGRect(x: textEditer.frame.width*0.9, y: TEheight*0.9, width: textEditer.frame.width*0.1, height: TEheight*0.2)
        charNumLabel.sizeToFit()
        
        let jobTitleY = (textEditerY + TEheight*1.2)*1.08
        
        jobTilte.frame = CGRect(x: scrhalfX * 0.1, y: jobTitleY*0.97 , width: scrview.frame.width * 0.22 * 0.8, height: prfpos1*0.45)
        jobTilte.sizeToFit()
        
        jobTitleField.frame = CGRect(x: 0, y: jobTitleY, width: self.view.frame.width, height: scrhalfY*0.1)

        
    }
    
    @objc private func doneButtonTapped() {
        doneButtonTapHandler?(textEditer.text)
        dismiss(animated: true, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func photoPick(sender : UIButton) {
        let imgpicker = UIImagePickerController()
        imgpicker.delegate = self
        present(imgpicker, animated: true)
    }
    
    @objc func deleteimg(sender : UIButton) {
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle:  .actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler:{
            
            (action: UIAlertAction!) -> Void in
            
            self.selectedFrame = sender.tag
            
            for i in self.selectedFrame ..< self.photoNum{
                self.profimgs[i].image = self.profimgs[i+1].image
            }
            
            self.profimgs[self.photoNum-1].image = UIImage(named: "frame.png")
            self.profimgBtns[self.photoNum-1].setImage(UIImage(named:"addimg.png"), for: UIControl.State.normal)
            self.profimgBtns[self.photoNum-1].removeTarget(self,
                                                      action: #selector(self.deleteimg(sender:)),
                                                 for: .touchUpInside)
            
            self.profimgBtns[self.photoNum-1].addTarget(self,
                                              action: #selector(self.photoPick(sender:)),
                                              for: .touchUpInside)
            
            self.photoNum -= 1
        })
       
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
            
            (action: UIAlertAction!) -> Void in
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
  
        present(alert, animated: true, completion: nil)
       

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
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // キャンセルボタンを押された時に呼ばれる
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 写真が選択された時に呼ばれる
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        self.profimgs[photoNum].image = image
        self.dismiss(animated: true)
        profimgBtns[photoNum].setImage(UIImage(named:"delete.png"), for: UIControl.State.normal)
        profimgBtns[photoNum].removeTarget(self,
                                                action: #selector(photoPick(sender:)),
                                                for: .touchUpInside)

        profimgBtns[photoNum].addTarget(self,
                       action: #selector(deleteimg(sender:)),
                       for: .touchUpInside)
        
        photoNum += 1
        
    }
}
