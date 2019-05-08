//
//  commonFuncs.swift
//
//
//  Created by 萬年司 on 2019/03/13.
//
import Foundation
import UIKit

class CommonFuncs {
    
     let userDefaultRep = UserDefaultsRepository.sharedInstance
    
    func resize(image: UIImage, width: Double) -> UIImage {
        
        // オリジナル画像のサイズからアスペクト比を計算
        let aspectScale = image.size.height / image.size.width
        
        // widthからアスペクト比を元にリサイズ後のサイズを取得
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    //UIImageをデータベースに格納できるStringに変換する
    func Image2String(image:UIImage) -> String? {
        
        //画像をDataに変換
        let data:Data? = image.pngData()
        
        //NSDataへの変換が成功していたら
        if let pngData = data {
            
            //BASE64のStringに変換する
            let encodeString:String =
                pngData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
            
            return encodeString
            
        }
        
        return nil
        
    }
    
    //StringをUIImageに変換する
    func String2Image(imageString:String) -> UIImage?{
        
        //空白を+に変換する
        let base64String = imageString.replacingOccurrences(of: " ", with: "+")
        
        //BASE64の文字列をデコードしてNSDataを生成
        let decodeBase64:Data? = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        
        //Dataの生成が成功していたら
        if let decodeSuccess = decodeBase64 {
            
            //NSDataからUIImageを生成
            let img = UIImage(data: decodeSuccess)
            
            //結果を返却
            return img
        }
        
        return nil
        
    }
    
    
    func encoder (data: profData,key: String){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaultRep.set(encoded, forKey: key)
        }
    }
    
    
    func decoder (key: String)->profData?{
        let decoder = JSONDecoder()
        var ret:profData?
        
        
        if let encoded = userDefaultRep.get(forKey: key),
            let data = try? decoder.decode(profData.self, from: encoded as! Data) {
            
            ret = data
        }
        
        
        return ret
    }

    
    
}

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
    }
}

extension UIColor {
    public func dark() -> UIColor {
        let ratio: CGFloat = 0.8
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * ratio, alpha: alpha)
    }
}

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    var dataList = [String]()
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(dataList: [String]) {
        self.dataList = dataList
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:  #selector(self.done))
        // let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Progress.cancel))
        toolbar.setItems([/*cancelItem, */doneItem], animated: true)
        
        self.inputView = picker
        self.inputAccessoryView = toolbar
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = dataList[row]
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool{
        return false
    }
  
   
    
//   @objc func cancel() {
//        self.endEditing(true)
//    }
    
    
    
    //   @objc func cancel() {
    //        self.endEditing(true)
    //    }
    
    @objc func done() {
        self.endEditing(true)
    }
}
