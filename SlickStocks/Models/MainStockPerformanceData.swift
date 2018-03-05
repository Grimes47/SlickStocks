//
//  StockPerformanceData.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/2/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import Foundation


// These structs represent the JSON dictionary data structure for the ticker pricing on the main page (dictionary with an array of dictionaries as the value)

struct StockQuotes: Decodable {
    
    let stockQuotes: [MainStockPerformanceData]
    
    private enum CodingKeys: String, CodingKey {
        case stockQuotes = "Stock Quotes"
    }
}

struct MainStockPerformanceData: Decodable {
    
    let symbol: String
    let price: String
    let volume: String
    let timeStamp: String
    
    private enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case price = "2. price"
        case volume = "3. volume"
        case timeStamp = "4. timestamp"
    }
}
