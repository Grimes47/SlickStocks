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
    
    let mainVC = MainViewController()
    var stockQuotes: StockQuotes?
    var detailStockData: DetailStockPerformanceData?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
    
    func testBatchStockDownloads() {
        let tickers = mainVC.defaultTickerSymbols
        let expectation = XCTestExpectation(description: "Download batch stock data")
        NetworkCalls.shared.downloadBatchStockPerformanceData(forTickers: tickers) { (completion) in
            self.stockQuotes = completion
            XCTAssertNotNil(self.stockQuotes, "Data not downloaded properly")
            expectation.fulfill()
        }
        let res = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        if res == .completed {
            XCTAssertNotNil(stockQuotes, "Failed to download batch stock data")
        } else {
            XCTAssert(false, "The call to get the URL ran into some other error")
        }
    }
    
    func testSingleStockDownloads() {
        let ticker = "NKE"
        let expectation = XCTestExpectation(description: "Download single stock data")
        NetworkCalls.shared.downloadSingleStockPerformanceData(forTicker: ticker) { (completion) in
            self.detailStockData = completion
            XCTAssertNotNil(self.detailStockData, "Data not downloaded properly")
            expectation.fulfill()
        }
        let res = XCTWaiter.wait(for: [expectation], timeout: 5.0)
        if res == .completed {
            XCTAssertNotNil(detailStockData, "Failed to download single stock data")
        } else {
            XCTAssert(false, "The call to get the URL ran into some other error")
        }
    }
    
}
