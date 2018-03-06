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
        let string = "123"
        let decimal: Decimal = 123
        let convertedString = string.convertToDecimal()
        
        XCTAssertEqual(convertedString, decimal)
        
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
