//
//  AlertView.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit


// holding array so the AlertView objects don't go out of scope
internal var alerts = [AlertView]()

// simple structure to hold button name and its closure
struct AlertViewButton {
    var title : String
    var action: () -> Void
}

// the alert view class
class AlertView: NSObject, UIAlertViewDelegate {
    
    var title : String!
    var message: String!
    var cancelButton : AlertViewButton!
    var otherButtons = [AlertViewButton]()
    var alertView : UIAlertView? = nil
    
    init(title: String, message: String, cancelButtonTitle: String, cancelButtonAction: @escaping () -> Void) {
        super.init()
        self.title = title
        self.message = message
        self.cancelButton = AlertViewButton(title: cancelButtonTitle, action: cancelButtonAction)
        
        self.alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelButtonTitle)
    }
    
    func addButtonWithTitle(_ title: String, action: @escaping () -> Void) -> Void {
        let button = AlertViewButton(title: title, action: action)
        self.otherButtons.append(button)
        self.alertView?.addButton(withTitle: button.title)
    }
    
    
    func show() {
        //removed because of memory leak
        /*let alertView = UIAlertView(title: self.title, message: self.message, delegate: self, cancelButtonTitle: self.cancelButton.title)
         for button in otherButtons {
         alertView.addButton(withTitle: button.title)
         }*/
        
        // add to holding array; otherwise the object is released & delegate method never gets called
        alerts.append(self)
        
        guard let alert = self.alertView else {return}
        alert.show()
    }
    
    
    // UIAlertViewDelegate
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            cancelButton.action()
            return
        }
        if otherButtons.count >= buttonIndex {
            let button = otherButtons[buttonIndex - 1]
            button.action()
        }
        
        // remove from holding array
        if let index = alerts.index(of: self) {
            alerts.remove(at: index)
        }
    }
    
}
