//
//  Decimal+Extensions.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/6/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import Foundation

struct DecimalExtensions {
    
}
    
    extension Decimal {
        func roundDecimalCurrency() -> String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            return formatter.string(from: self as NSDecimalNumber)!
        }
    }
    
    extension Decimal {
        func roundDecimal() -> String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.numberStyle = .decimal
            return formatter.string(from: self as NSDecimalNumber)!
        }
    }
    
    extension Decimal {
        func decimalNoFractions() -> String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            formatter.numberStyle = .decimal
            return formatter.string(from: self as NSDecimalNumber)!
        }
    }

