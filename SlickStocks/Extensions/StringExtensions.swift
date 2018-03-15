//
//  String+Extensions.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/6/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import Foundation

extension String {
    func convertToDecimal() -> Decimal {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: self) as! Decimal
    }
}

