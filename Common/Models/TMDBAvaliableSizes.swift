//
//  AvaliableSizes.swift
//  TMDBKit
//
//  Created by Siyuan Cao on 2017/10/24.
//  Copyright © 2017年 Siyuan Cao. All rights reserved.
//

import Foundation

public struct TMDBAvaliableSizes {
    
    internal(set) public var rawSizes: [String] = []
    
    /// Avaliable widths. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `heights` property and "original" size avaliable.
    public var widths: [Int] {
        return self.rawSizes.flatMap({ size in size.sizeFormatted(wOrH: "w") })
    }
    
    /// Avaliable heights. Use this method to get this value:
    /// ```
    /// TMDBManager.shared.configuration.getAPIConfiguration()
    /// ```
    ///
    /// There is also a `widths` property and "original" size avaliable.
    public var heights: [Int] {
        return self.rawSizes.flatMap({ size in size.sizeFormatted(wOrH: "h") })
    }
    
    init(_ rawSizes: [String]) {
        self.rawSizes = rawSizes
    }
}
