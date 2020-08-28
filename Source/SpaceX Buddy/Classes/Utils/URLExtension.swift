//
//  URLExtension.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 01..
//

import Foundation

extension URL {
    mutating func appendPathComponent<T : RawRepresentable>(_ pathComponent: T) where T.RawValue == String {
        appendPathComponent(pathComponent.rawValue)
    }
}
