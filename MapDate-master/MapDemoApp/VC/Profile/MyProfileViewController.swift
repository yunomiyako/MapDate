//
//  MyProfileViewController.swift
//  MapDemoApp
//
//  Created by 萬年　司 on 2019/03/10.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
   var Back:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        Back = UIButton(type: UIButton.ButtonType.system)
        Back.addTarget(self, action: #selector(backToMap(_:)), for: UIControl.Event.touchUpInside)
        Back.setTitle("Back", for: UIControl.State.normal)
        
        Back.frame = CGRect(x: 20.0, y: 30.0, width:100.0, height: 50.0)
        self.view.addSubview(Back)
    }
    @objc func backToMap(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
