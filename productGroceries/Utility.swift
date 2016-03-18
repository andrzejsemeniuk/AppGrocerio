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

extension Int
{
    public var isEven:Bool {
        return self % 2 == 0
    }
    public var isOdd:Bool {
        return self % 2 == 1
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
    public func lerp(from:Float, _ to:Float) -> Float {
        return (1.0-self)*from + self*to
//        return from + (to - from) * self
    }
    public static func lerp(from:Float, _ to:Float, _ with:Float) -> Float {
        return with.lerp(from,to)
    }
    public func lerp01(from:Float, _ to:Float) -> Float {
        return min(1.0,max(0.0,self.lerp(from,to)))
    }
    public static func lerp01(from:Float, _ to:Float, _ with:Float) -> Float {
        return with.lerp01(from,to)
    }
}

extension CGFloat
{
    public func clamp(minimum:CGFloat,_ maximum:CGFloat) -> CGFloat {
        return self < maximum ? (minimum < self ? self : minimum) : maximum
    }
    public func clamp01() -> CGFloat {
        return clamp(0,1)
    }
    public func clamp0255() -> CGFloat {
        return clamp(0,255)
    }
    public func lerp(from:CGFloat, _ to:CGFloat) -> CGFloat {
        return (1.0-self)*from + self*to
//        return from + (to - from) * self
    }
    public static func lerp(from:CGFloat, _ to:CGFloat, _ with:CGFloat) -> CGFloat {
        return with.lerp(from,to)
    }
    public func lerp01(from:CGFloat, _ to:CGFloat) -> CGFloat {
        return CGFloat(Float(self.lerp(from,to)).clamp01())
    }
    public static func lerp01(from:CGFloat, _ to:CGFloat, _ with:CGFloat) -> CGFloat {
        return with.lerp01(from,to)
    }
}

extension UIColor
{
    public convenience init(red:CGFloat,green:CGFloat,blue:CGFloat) {
        self.init(red:red,green:green,blue:blue,alpha:1)
    }
    
    public func components_RGBA_UInt8() -> (red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8) {
        let components      = RGBA()
        let maximum:CGFloat   = 256
        
        let r = Float(components.red*maximum).clamp0255()
        let g = Float(components.green*maximum).clamp0255()
        let b = Float(components.blue*maximum).clamp0255()
        let a = Float(components.alpha*maximum).clamp0255()
        
        let result = (
            UInt8(r),
            UInt8(g),
            UInt8(b),
            UInt8(a)
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
    
    public func RGBA() -> (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getRed(&r,green:&g,blue:&b,alpha:&a)
        
        return (r,g,b,a)
    }
    
    public func HSBA() -> (hue:CGFloat,saturation:CGFloat,brightness:CGFloat,alpha:CGFloat) {
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 1
        
        self.getHue(&h,saturation:&s,brightness:&b,alpha:&a)
        
        return (h,s,b,a)
    }
    
    public func alpha() -> CGFloat {
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

