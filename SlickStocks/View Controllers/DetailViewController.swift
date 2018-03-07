//
//  DetailViewController.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/3/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    
    @IBOutlet var tickerSymbol: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var highPrice: UILabel!
    @IBOutlet var lowPrice: UILabel!
    @IBOutlet var priceChange: UILabel!
    @IBOutlet var volume: UILabel!
    
    @IBOutlet var detailCompanyLogo: UIImageView!
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var tickerSymbolFromSelectedRow: String?
    var priceFromSelectedRow: String?
    var logoFromSelectedRow: UIImage?
    
    private var detailStockPerformanceData: DetailStockPerformanceData?
    
    private var currentDate: String = {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }()
    
    private var yesterdayDate: String = {
        let date = Date().yesterday
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Use the ticker symbol received from the main VC tableView cell to launch the detailed VC JSON download
        downloadSingleStockData()
        setLabels()
    }
    
    func downloadSingleStockData() {
        if let ticker = tickerSymbolFromSelectedRow {
            NetworkCalls.shared.downloadSingleStockPerformanceData(forTicker: ticker) { (completion) in
                self.detailStockPerformanceData = completion
                DispatchQueue.main.async {
                    self.setLabels()
                }
            }
        }
    }
    
    // Determines the current value of the stock price against its opening price for the day
    func calculateChangeInStockPrice(forToday today: String) {
        if let data = detailStockPerformanceData {
            if let currentPrice = priceFromSelectedRow?.convertToDecimal(), let todayOpen = data.timeSeriesDaily[today]?["1. open"]?.convertToDecimal() {

                let stockPriceChange = (todayOpen - currentPrice)
                let result = stockPriceChange.roundDecimalCurrency()
                
                if stockPriceChange >= 0 {
                    priceChange.textColor = .green
                    priceChange.text = ("(+\(result))")
                } else if stockPriceChange < 0 {
                    priceChange.textColor = .red
                    priceChange.text = ("(\(result))")
                    }
                }
            }
        }
    
    func setLabels() {
        if let tickerSymbol = tickerSymbolFromSelectedRow, let price = priceFromSelectedRow, let logo = logoFromSelectedRow {
            self.tickerSymbol.text = tickerSymbol
            self.price.text = ("$\(price.convertToDecimal().roundDecimal())")
            self.detailCompanyLogo.image = logo
            }
        if let data = detailStockPerformanceData {
            if let high = data.timeSeriesDaily[currentDate]?["2. high"], let low = data.timeSeriesDaily[currentDate]?["3. low"], let volume = data.timeSeriesDaily[currentDate]?["5. volume"] {
            highPrice.text = ("$\(high.convertToDecimal().roundDecimal())")
            lowPrice.text = ("$\(low.convertToDecimal().roundDecimal())")
            self.volume.text = volume.convertToDecimal().decimalNoFractions()
            calculateChangeInStockPrice(forToday: currentDate)
            activitySpinner.stopAnimating()
            }
        }
    }
}

