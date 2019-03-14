//
//  DiscoverySettingViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/14.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit

class DiscoverySettingViewController: UIViewController {

    lazy var tableView : UITableView = self.createTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutTableView()
    }
    
    
    private func createTableView() -> UITableView {
        let view = UITableView()
        view.delegate = self
        return view
    }
    
    
    private func layoutTableView()  {
        tableView.frame = CGRect(x : 0 , y : 0 , width : self.view.frame.width , height : self.view.frame.height )
    }

}

extension DiscoverySettingViewController : UITableViewDelegate {
    
}

extension DiscoverySettingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
