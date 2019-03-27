//
//  PopupShowable.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import Foundation
import Cartography

protocol PopUpShowable:class {
    func showMessagePopup(_ message:String)
    func showMessagePopup(_ message:String, completionHandler:@escaping (() -> Void))
    
    func showRetryPopup(_ completionHandler:@escaping (() -> Void))
    func showRetryPopup(_ message:String,completionHandler:@escaping (() -> Void))
    
    func showOKCancelPopup(_ message:String, completionHandler:@escaping (() -> Void))
    
    func showForceRetryPopup(_ completionHandler:@escaping (() -> Void))
    func showForceRetryPopup(_ message:String, completionHandler:@escaping (() -> Void))
}

extension PopUpShowable where Self: UIViewController {
    
    /**
     OKボタンのみを含む確認用ポップアップを表示
     - parameter message: ポップアップに表示するメッセージ
     */
    func showMessagePopup(_ message:String) {
        PopupUtils.showMessagePopup(message)
    }
    
    func showMessagePopup(_ message:String, completionHandler:@escaping (() -> Void)) {
        PopupUtils.showMessagePopup(message, completionHandler:completionHandler)
    }
    
    /**
     * 再実行・キャンセルの2つの選択肢を含むポップアップをデフォルトメッセージで表示
     */
    func showRetryPopup(_ completionHandler:@escaping (() -> Void)) {
        PopupUtils.showRetryPopup("",completionHandler:completionHandler)
    }
    
    /**
     * 再実行・キャンセルの2つの選択肢を含むポップアップを表示
     */
    func showRetryPopup(_ message:String, completionHandler:@escaping (() -> Void)) {
 PopupUtils.showRetryPopup(message,completionHandler:completionHandler)
    }
    
    /**
     * OK・キャンセルの2つの選択肢を含むポップアップを表示
     */
    func showOKCancelPopup(_ message:String, completionHandler:@escaping (() -> Void)) {
 PopupUtils.showOKCancelPopup(message,completionHandler:completionHandler)
    }
    
    
    /**
     * 再実行の選択肢のみを含むポップアップをデフォルトメッセージで表示
     */
    func showForceRetryPopup(_ completionHandler:@escaping (() -> Void)) {
 PopupUtils.showForceRetryPopup("",completionHandler:completionHandler)
    }
    
    /**
     * 再実行の選択肢のみを含むポップアップを表示
     */
    func showForceRetryPopup(_ message:String, completionHandler:@escaping (() -> Void)) {
 PopupUtils.showForceRetryPopup(message,completionHandler:completionHandler)
    }
    
}
