//
//  MapSearchBarView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/23.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import SHSearchBar
import SwiftIcons

class MapSearchBarView: UIView {
    lazy private var searchBar : SHSearchBar = self.createSearchBar()
    
    // MARK: - Life cycle events -
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.childInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.childInit()
    }
    
    private func childInit() {
        self.searchBar.backgroundColor = UIColor.clear
        self.addSubview(searchBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutSearchBar()
    }
    
    
    private func createSearchBar() -> SHSearchBar {
        let searchIconImage = UIImage.init(icon: .fontAwesomeSolid(.search), size: CGSize(width: 25, height: 25))
        let searchIconImageView = UIImageView(image: searchIconImage)

        var config = SHSearchBarConfig()
        config.useCancelButton = false
        config.leftView = searchIconImageView
        config.leftViewMode = .always
        
        let bar = SHSearchBar(config: config)
        bar.placeholder = "Search Place"
        bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 3)
        bar.layer.shadowRadius = 5
        bar.layer.shadowOpacity = 0.25
        return bar
    }
    
    func setSize(width : CGFloat , height : CGFloat) {
        searchBar.width(width)
        searchBar.height(height)
    }

    private func layoutSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
}
