//
//  DetailViewController.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/3/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var tickerSymbol: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var highPrice: UILabel!
    @IBOutlet var lowPrice: UILabel!
    @IBOutlet var percentChange: UILabel!
    @IBOutlet var volume: UILabel!
    
    var tickerSymbolFromSelectedRow: String?
    var priceFromSelectedRow: String?
    
    private var detailStockPerformanceData: DetailStockPerformanceData?
    
    private var currentDate: String = {
        let date = Date()
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
    
    func setLabels() {
        if let tickerSymbol = tickerSymbolFromSelectedRow, let price = priceFromSelectedRow {
            self.tickerSymbol.text = tickerSymbol
            self.price.text = ("$\(price)")
            }
        if let data = detailStockPerformanceData {
            if let open = data.timeSeriesDaily["2018-03-02"]?["1. open"], let high = data.timeSeriesDaily["2018-03-02"]?["2. high"], let low = data.timeSeriesDaily["2018-03-02"]?["3. low"], let close = data.timeSeriesDaily["2018-03-02"]?["4. close"], let volume = data.timeSeriesDaily["2018-03-02"]?["5. volume"] {
            highPrice.text = high
            lowPrice.text = low
            self.volume.text = volume
            }
    
        }
    }
}
