import Foundation
import UIKit
protocol NibHelper {}

/**
 * XibファイルからViewを生成
 */
extension NibHelper where Self: UIView {    
    //テーブルビューなどのセルでは循環参照を防ぐためにこちらを使用することを推奨
    //To avoid memory leak, needs to hard code className
    static func instantiate(className : String) -> Self {
        let nib = UINib(nibName: className, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! Self
    }
}

extension UIView: NibHelper {}
