//
//  DynamicHeightCollectionViewCell.swift
//  Appt
//
//  Created by Yurii Kozlov on 6/14/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class DynamicHeightCollectionViewCell: UICollectionViewCell {
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {

        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude

        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return size
    }
}
