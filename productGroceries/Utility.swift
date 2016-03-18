//
//  Utility.swift
//  productGroceries
//
//  Created by Andrzej Semeniuk on 3/11/16.
//  Copyright © 2016 Tiny Game Factory LLC. All rights reserved.
//

import Foundation
import UIKit


struct UITableViewTap
{
    let path:NSIndexPath
    let point:CGPoint
}

extension String
{
    public var length: Int {
        return characters.count
    }
    
    public var urlEncoded: String {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    
    public var base64Encoded: String {
        let step1:NSString      = self as NSString
        let step2:NSData        = step1.dataUsingEncoding(NSUTF8StringEncoding)!
        let options             = NSDataBase64EncodingOptions(rawValue: 0)
        let result:String       = step2.base64EncodedStringWithOptions(options)
        
        return result
    }
    
    public var empty: Bool {
        return length < 1
    }
    
    public func trimmed() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    public func substring(from:Int = 0, var to:Int = -1) -> String {
        if to < 0 {
            to = self.length + to
        }
        return self.substringWithRange(Range<String.Index>(
            start:self.startIndex.advancedBy(from),
            end:self.startIndex.advancedBy(to+1)))
    }
    
    public func substring(from:Int = 0, length:Int) -> String {
        return self.substringWithRange(Range<String.Index>(
            start:self.startIndex.advancedBy(from),
            end:self.startIndex.advancedBy(from+length)))
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

extension Float
{
    public func clamp(minimum:Float,_ maximum:Float) -> Float {
        return self < maximum ? (minimum < self ? self : minimum) : maximum
    }
    public func clamp01() -> Float {
        return clamp(0,1)
    }
    public func clamp0255() -> Float {
        return clamp(0,255)
    }
}

extension UIColor
{
    public convenience init(red:CGFloat,green:CGFloat,blue:CGFloat) {
        self.init(red:red,green:green,blue:blue,alpha:1)
    }
    
    public func components_RGBA_UInt8() -> (red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8) {
        let components      = RGBA()
        let maximum:Float   = 256
        
        let r = components.red*maximum
        let g = components.green*maximum
        let b = components.blue*maximum
        let a = components.alpha*maximum
        
        let result = (
            UInt8(r.clamp0255()),
            UInt8(g.clamp0255()),
            UInt8(b.clamp0255()),
            UInt8(a.clamp0255())
        )
        
        return result
    }
    
    public func components_RGBA_UInt8_equals(another:UIColor) -> Bool {
        let a = components_RGBA_UInt8()
        let b = another.components_RGBA_UInt8()
        
        return a.red==b.red && a.green==b.green && a.blue==b.blue && a.alpha==b.alpha
    }
    
    public func components_RGB_UInt8_equals(another:UIColor) -> Bool {
        let a = components_RGBA_UInt8()
        let b = another.components_RGBA_UInt8()
        
        return a.red==b.red && a.green==b.green && a.blue==b.blue
    }
    
    public func RGBA() -> (red:Float,green:Float,blue:Float,alpha:Float) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getRed(&r,green:&g,blue:&b,alpha:&a)
        
        return (Float(r),Float(g),Float(b),Float(a))
    }
    
    public func HSBA() -> (hue:Float,saturation:Float,brightness:Float,alpha:Float) {
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getHue(&h,saturation:&s,brightness:&b,alpha:&a)
        
        return (Float(h),Float(s),Float(b),Float(a))
    }
    
    public func alpha() -> Float {
        return RGBA().alpha
    }
    
    public class func GRAY(v:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(white:CGFloat(v),alpha:CGFloat(a))
    }
    
    public class func RGBA(r:Float, _ g:Float, _ b:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(red:CGFloat(r),green:CGFloat(g),blue:CGFloat(b),alpha:CGFloat(a))
    }
    
    public class func HSBA(h:Float, _ s:Float, _ b:Float, _ a:Float = 1.0) -> UIColor
    {
        return UIColor(hue:CGFloat(h),saturation:CGFloat(s),brightness:CGFloat(b),alpha:CGFloat(a))
    }

}


extension NSUserDefaults
{
    public class func clear()
    {
        let domain      = NSBundle.mainBundle().bundleIdentifier
        
        let defaults    = NSUserDefaults.standardUserDefaults()
        
        if let name = domain {
            defaults.removePersistentDomainForName(name)
        }
    }
}

