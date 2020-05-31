//
//  OtherUtilities.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-31.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

func sortImageListByIndexOrID(_ images: [Image]) -> [Image] {
    let sortedImages = images.sorted { (left, right) -> Bool in
        if
            let leftIndex = left.index,
            let rightIndex = right.index {
            return leftIndex < rightIndex
        }
        
        return left.id.compare(right.id, options: .numeric) == .orderedAscending
    }
    return sortedImages
}
