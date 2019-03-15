//
//  DiscoverySettingViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/14.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

protocol DiscoverySettingViewControllerDelegate : class {
    func willDismiss()
}

class DiscoverySettingViewController: UIViewController {

    lazy var tableView : UITableView = self.createTableView()
    weak var delegate : DiscoverySettingViewControllerDelegate? = nil
    let userDefaultsUseCase = UserDefaultsUseCase.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        
        let closeButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.clickCloseButton))
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setRightBarButton(closeButton, animated: false)
    }
    
    @objc private func clickCloseButton() {
        self.dismiss(animated: true) {
            self.delegate?.willDismiss()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutTableView()
    }
    
    
    private func createTableView() -> UITableView {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.backgroundColor = UIColor.groupTableViewBackground
        view.delegate = self
        view.dataSource = self
        view.register(UINib(nibName: "SliderCellTableViewCell", bundle: nil), forCellReuseIdentifier: "SliderCellTableViewCell")
        return view
    }
    
    
    private func layoutTableView()  {
        tableView.frame = CGRect(x : 0 , y : 0 , width : self.view.frame.width , height : self.view.frame.height )
    }

}

extension DiscoverySettingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension DiscoverySettingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch(row) {
        case 0 :
            let radius = userDefaultsUseCase.get(forKey: userDefaultsUseCase.discoveryDistanceKey) as? CGFloat ?? 3000
            let cell = tableView.dequeueReusableCell(withIdentifier:"SliderCellTableViewCell" , for: indexPath as IndexPath) as! SliderCellTableViewCell
            cell.setSliderConfig(min: 2, max: 50, by: 2 , key : userDefaultsUseCase.discoveryDistanceKey)
            cell.setValue(value: [radius])
            cell.setText(leftText: "Search Distance:", rightTextUnit: "km")
            cell.selectionStyle = .none
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier:"SliderCellTableViewCell" , for: indexPath as IndexPath) as! SliderCellTableViewCell
            cell.setSliderConfig(min: 18, max: 50, by: 1, key : userDefaultsUseCase.discoveryAgeKey)
            cell.setValue(value: [20 , 30])
            cell.setText(leftText: "Show Ages:", rightTextUnit: "-")
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
