//
//  PopupUtils.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
class PopupUtils {
    
    /**
     OKボタンのみを含む確認用ポップアップを表示
     - parameter message: ポップアップに表示するメッセージ
     */
    class func showMessagePopup(_ message:String) {
        
        dispatch_async_main {
            let alert = AlertView(
                title: "",
                message: message,
                cancelButtonTitle: NSLocalizedString("OKMessage",  tableName: "Common", comment: ""),
                cancelButtonAction: {
            })
            alert.show()
        }
    }
    
    class func showMessagePopup(_ message:String, completionHandler:@escaping (() -> Void)) {
        
        dispatch_async_main {
            let alert = AlertView(
                title: "",
                message: message,
                cancelButtonTitle: NSLocalizedString("OKMessage", tableName: "Common",  comment: ""),
                cancelButtonAction: completionHandler)
            alert.show()
        }
    }
    
    /**
     * 再実行・キャンセルの2つの選択肢を含むポップアップをデフォルトメッセージで表示
     */
    class func showRetryPopup(_ completionHandler:@escaping (() -> Void)) {
        
        showRetryPopup("",completionHandler:completionHandler)
    }
    
    /**
     * 再実行・キャンセルの2つの選択肢を含むポップアップを表示
     */
    class func showRetryPopup(_ message:String, completionHandler:@escaping (() -> Void)) {
        
        dispatch_async_main {
            let alert = AlertView(title: "", message: message, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelButtonAction: {})
            alert.addButtonWithTitle(NSLocalizedString("Retry", comment: ""), action: { () -> Void in
                completionHandler()
            })
            alert.show()
        }
    }
    
    /**
     * OK・キャンセルの2つの選択肢を含むポップアップを表示
     */
    class func showOKCancelPopup(_ message:String, completionHandler:@escaping (() -> Void)) {
        
        dispatch_async_main {
            let alert = AlertView(title: "", message: message, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelButtonAction: {})
            alert.addButtonWithTitle(NSLocalizedString("OKMessage", tableName: "Common",  comment: ""), action: { () -> Void in
                completionHandler()
            })
            alert.show()
        }
    }
    
    
    /**
     * OK・キャンセルの2つの選択肢と、テキストフィールドを含むポップアップを表示
     */
    class func showOKCancelTextPopup(presenter : UIViewController , title : String , message:String,placeholder:String , textFieldValue : String ,completionHandler:@escaping ((String?) -> Void)) {
        
        dispatch_async_main {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            //キャンセルボタン
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: {alert -> Void in}))
            
            //okボタン
            alert.addAction(UIAlertAction(title: NSLocalizedString("OKMessage", tableName: "Common",  comment: ""), style: .default, handler: {alertAction -> Void in
                guard let textField = alert.textFields?[0] else {return}
                completionHandler(textField.text)
            }))
            
            //テキストフィールド
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = placeholder
                textField.text = textFieldValue
            })
            
            //描画
            presenter.present(alert , animated:true , completion : nil)
        }
    }
    
    
    /**
     * 再実行の選択肢のみを含むポップアップをデフォルトメッセージで表示
     */
    class func showForceRetryPopup(_ completionHandler:@escaping (() -> Void)) {
        
        showForceRetryPopup("",completionHandler:completionHandler)
    }
    
    /**
     * 再実行の選択肢のみを含むポップアップを表示
     */
    class func showForceRetryPopup(_ message:String, completionHandler:@escaping (() -> Void)) {
        
        dispatch_async_main {
            let alert = AlertView(title: "", message: message, cancelButtonTitle: NSLocalizedString("Retry", comment: ""), cancelButtonAction: completionHandler)
            alert.show()
        }
    }
    
    class func showModalPopup(presentingVC : UIViewController , presentedVC : UIViewController , delegate : UIViewControllerTransitioningDelegate) {
        presentedVC.modalPresentationStyle = .custom
        presentedVC.transitioningDelegate = delegate
        presentingVC.present(presentedVC, animated: true, completion: nil)
    }
}
