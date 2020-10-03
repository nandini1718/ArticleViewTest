//
//  ProjectUtils.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class ProjectUtils: NSObject {

    class func formatNumber(_ n: Int) -> String {
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n)"

        default:
            return "\(sign)\(n)"
        }
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame:CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    class func stringToDate(dateInStr:String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime,.withFullTime,.withFractionalSeconds]
        if let myDate = formatter.date(from: dateInStr){
            return myDate
        }
        
        return nil
    }
    
    
    class func showAlertTitleAndOkButton(withTitle strTitle:String, withMessage strMessage:String, okButtonTitle strOkTitle:String, action:@escaping ()->(), onController controller:UIViewController) {
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: strOkTitle, style:  .default, handler: { (alert) in
                action()
            })
            
            alertController.addAction(okAction)
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
    private static func documentsDirectoryURLs() -> [URL] {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    class func documentsURL(with fileName: String) -> URL? {
        guard let documentsDirectoryURL = ProjectUtils.documentsDirectoryURLs().last else { print("\(#function):Error - No URLs Found!"); return nil }
        return documentsDirectoryURL.appendingPathComponent(fileName)
    }
}
