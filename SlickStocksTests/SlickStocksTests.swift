//
//  SlickStocksTests.swift
//  SlickStocksTests
//
//  Created by Adam Hogan on 3/2/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import XCTest
@testable import SlickStocks

class SlickStocksTests: XCTestCase {
    
    func testDecimalConversion() {
        let string = "123.65"
        let decimal: Decimal = 123.65
        let convertedString = string.convertToDecimal()
        
        XCTAssertEqual(convertedString, decimal)
        
    }
    
    func testRoundDecimalCurrency() {
        let decimal: Decimal = 123.658
        let convertedToCurrency = "$123.66"
        let converted = decimal.roundDecimalCurrency()
        
        XCTAssertEqual(convertedToCurrency, converted)
    }
    
    func testDecimalNoFractions() {
        let decimal: Decimal = 123.56
        let string = "124"
        let converted = decimal.decimalNoFractions()
        
        XCTAssertEqual(converted, string)
    }
    
    func testRoundDecimal() {
        let decimal: Decimal = 123.56789
        let string = "123.57"
        let converted = decimal.roundDecimal()
        
        XCTAssertEqual(string, converted)
    }
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
}
