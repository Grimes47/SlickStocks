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
        if let ticker = tickerSymbolFromSelectedRow {
            downloadDetailStockPerformanceData(forTicker: ticker)
        }
        setLabels()
    }
    
   

    func downloadDetailStockPerformanceData(forTicker ticker: String) {
        
        activitySpinner.startAnimating()
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(ticker)&apikey=MPXXRDLBCJO7Y2KK"
        guard let url = URL(string: urlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let jsonData = try JSONDecoder().decode(DetailStockPerformanceData.self, from: data)
                self.detailStockPerformanceData = jsonData
                //Delay reload/end refreshing for 3/4 second so user has chance to see refresher text
                let delayRefresh = DispatchTime.now() + .milliseconds(750)
                DispatchQueue.main.asyncAfter(deadline: delayRefresh) {
                    self.setLabels()
                }
            } catch let error {
                print("Error serializing JSON data:", error)
            }
            
            }.resume()
    }
    
    // Determines the current value of the stock price against its opening price for the day
    func calculateChangeInStockPrice(forToday today: String) {
        if let data = detailStockPerformanceData {
            if let currentPrice = priceFromSelectedRow?.convertToDecimal(), let todayOpen = data.timeSeriesDaily[today]?["1. open"]?.convertToDecimal() {

                let stockPriceChange = (todayOpen - currentPrice)
                let result = stockPriceChange.roundDecimalCurrency()
                
                if stockPriceChange >= 0 {
                    priceChange.textColor = .green
                } else if stockPriceChange < 0 {
                    priceChange.textColor = .red
                }
                priceChange.text = result
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

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}

