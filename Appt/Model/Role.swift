//
//  Role.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/12/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

struct Role: Hashable {
    enum UserType: Int, CaseIterable {
        case user
        case professional

        var segmentedControlTitle: String {
            switch self {
            case .user:
                return "segmented_control_user_type_user_title_text".localized
            case .professional:
                return "segmented_control_user_type_professional_title_text".localized
            }
        }
    }
    
    var type: UserType
    var title: String
    var id: String
    
    init?(withId id: String) {
        self.id = id
        
        switch id {
        case "ervaringsdeskundige":
            type = .user
            title = "account_creation_user_type_section0_row0_title_text".localized
        case "geinteresseerde":
            type = .user
            title = "account_creation_user_type_section0_row1_title_text".localized
        case "ambassadeur":
            type = .user
            title = "account_creation_user_type_section0_row2_title_text".localized
            
        case "designer":
            type = .professional
            title = "account_creation_user_type_section1_row0_title_text".localized
        case "tester":
            type = .professional
            title = "account_creation_user_type_section1_row1_title_text".localized
        case "ontwikkelaar":
            type = .professional
            title = "account_creation_user_type_section1_row2_title_text".localized
        case "manager":
            type = .professional
            title = "account_creation_user_type_section1_row3_title_text".localized
        case "toegankelijkheidsexpert":
            type = .professional
            title = "account_creation_user_type_section1_row4_title_text".localized
        case "auditor":
            type = .professional
            title = "account_creation_user_type_section1_row5_title_text".localized
            
        default:
            return nil
        }
    }
}
