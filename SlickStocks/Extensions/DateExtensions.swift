//
//  DateExtension.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/6/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}

