//
//  UserTypeSection.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/12/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

enum UserType: Int, CaseIterable {
    case user
    case professional

    var title: String {
        switch self {
        case .user:
            return "account_creation_user_type_section0_title_text".localized
        case .professional:
            return "account_creation_user_type_section1_title_text".localized
        }
    }

    var dataSource: [String] {
        switch self {
        case .user:
            return [
                "account_creation_user_type_section0_row0_title_text".localized,
                "account_creation_user_type_section0_row1_title_text".localized,
                "account_creation_user_type_section0_row2_title_text".localized
            ]
        case .professional:
            return [
                "account_creation_user_type_section1_row0_title_text".localized,
                "account_creation_user_type_section1_row1_title_text".localized,
                "account_creation_user_type_section1_row2_title_text".localized,
                "account_creation_user_type_section1_row3_title_text".localized,
                "account_creation_user_type_section1_row4_title_text".localized,
                "account_creation_user_type_section1_row5_title_text".localized
            ]
        }
    }
}
