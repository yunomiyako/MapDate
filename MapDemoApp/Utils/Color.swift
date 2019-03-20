import UIKit


//色はhttps://flatuicolors.com/palette/usから
extension UIColor {
    static func mainRed() -> UIColor {
        return UIColor.colorWithHexString("d63031")
    }
    
    static func mainGreen() -> UIColor {
        return UIColor.colorWithHexString("00b894")
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.colorWithHexString("0984e3")
    }
    
    static func mainPink() -> UIColor {
        return UIColor.colorWithHexString("fab1a0")
    }
    
    
    static func colorWithHexString (_ hex:String) -> UIColor {
        
        let cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if ((cString as String).characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(with: NSRange(location: 0, length: 2))
        let gString = (cString as NSString).substring(with: NSRange(location: 2, length: 2))
        let bString = (cString as NSString).substring(with: NSRange(location: 4, length: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(
            red: CGFloat(Float(r) / 255.0),
            green: CGFloat(Float(g) / 255.0),
            blue: CGFloat(Float(b) / 255.0),
            alpha: CGFloat(Float(1.0))
        )
    }
    
}
