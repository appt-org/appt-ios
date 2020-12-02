//
//  _UICollectionView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // MARK: - Cells
    
    func registerNib(_ cellClass: UICollectionViewCell.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func cell<T: UICollectionViewCell>(_ type: T.Type, at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as! T
    }
}

