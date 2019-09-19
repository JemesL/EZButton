//
//  String+Ex.swift
//  EZButton
//
//  Created by Jemesl on 2019/9/16.
//  Copyright © 2019 Jemesl. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getLabelWidth(font: UIFont, height: CGFloat) -> CGFloat {
        
        let labelText: NSString = self as NSString
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = labelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey: Any], context: nil).size
        return strSize.width
    }
    
    func getLabelHeight(font: UIFont, width: CGFloat) -> CGFloat {
        
        let labelText: NSString = self as NSString
        let size = CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = labelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
        return strSize.height
    }
}
