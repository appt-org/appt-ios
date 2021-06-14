//
//  _UITableView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 27/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

extension UITableView {
    
    // MARK: - Cells
   
    func registerNib(_ cellClass: UITableViewCell.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func registerNib(_ headerFooterClass: UITableViewHeaderFooterView.Type) {
        let nib = UINib(nibName: String(describing: headerFooterClass), bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: headerFooterClass.identifier)
    }
    
    func cell<T: UITableViewCell>(_ type: T.Type, at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! T
    }
    
    func headerFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: type.identifier) as! T
    }
}
