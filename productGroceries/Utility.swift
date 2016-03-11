//
//  Utility.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/11/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    public var length: Int
        {
            return characters.count
    }
    
    public var urlEncoded: String
        {
            return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    public var base64Encoded: String
        {
            let step1:NSString      = self as NSString
            let step2:NSData        = step1.dataUsingEncoding(NSUTF8StringEncoding)!
            let options             = NSDataBase64EncodingOptions(rawValue: 0)
            let result:String       = step2.base64EncodedStringWithOptions(options)
            
            return result
    }
    
    public var empty: Bool
        {
            return length < 1
    }
    
    public func trimmed() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
}

extension Array
{
    public func subarray(index:Int = 0, length:Int) -> Array {
        if (length-index) < self.count {
            return Array(self[index..<length])
        }
        return self
    }
}

extension UIColor
{
    public convenience init(red:CGFloat,green:CGFloat,blue:CGFloat)
    {
        self.init(red:red,green:green,blue:blue,alpha:1)
    }
}


