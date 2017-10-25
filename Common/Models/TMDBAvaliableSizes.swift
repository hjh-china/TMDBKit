//
//  AvaliableSizes.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public class TMDBAvaliableSizes: NSObject, NSCoding {
    
    internal(set) public var rawSizes: [String] = []
    
    /// Avaliable widths. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `heights` property and "original" size avaliable.
    public lazy var widths: [Int] = {
        return self.rawSizes.flatMap({ size in size.sizeFormatted(wOrH: "w") })
    }()
    
    /// Avaliable heights. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `widths` property and "original" size avaliable.
    public lazy var heights: [Int] = {
        return self.rawSizes.flatMap({ size in size.sizeFormatted(wOrH: "h") })
    }()
    
    convenience public init(_ rawSizes: [String]) {
        self.init()
        self.rawSizes = rawSizes
    }
    
    override public init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(rawSizes, forKey: "rawSizes")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.rawSizes = aDecoder.decodeObject(forKey: "rawSizes") as? [String] ?? []
    }
}
