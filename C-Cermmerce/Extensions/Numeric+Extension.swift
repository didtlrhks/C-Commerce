//
//  Numeric+Extension.swift
//  C-Cermmerce
//
//  Created by 양시관 on 2/17/24.
//

import Foundation


extension Numeric  {
    var moneyString : String {
        let formatter : NumberFormatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return (formatter.string(for : self) ?? "") + "원"
    }
    
}
