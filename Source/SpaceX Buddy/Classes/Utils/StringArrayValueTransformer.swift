//
//  StringArrayValueTransformer.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 10. 27..
//

import Foundation

@objc(StringArrayValueTransformer)
class StringArrayValueTransformer : ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else {
            return Optional.none
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
            return data
        }
        catch {
            assertionFailure("Failed to transform `UIColor` to `Data`")
            return Optional.none
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {
            return Optional.none
        }
                
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data as Data)
            return color
        }
        catch {
            assertionFailure("Failed to transform `Data` to `UIColor`")
            return nil
        }
    }
}
