//
//  ViewController.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/2/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshStockPrices(_:)), for: .valueChanged)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing Stock Prices...")
        
        return refresher
    }()
    
    @objc private func refreshStockPrices(_ sender: Any) {
        downloadStockPerformanceData(forTickers: defaultTickerSymbols)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadStockPerformanceData(forTickers: defaultTickerSymbols)
    }
    
    let defaultTickerSymbols = ["NKE","MSFT","AAPL","GOOG","ORCL","COST","AMZN","WMT","GE","XOM","CVX","GM","VLO","BA","WAG","AIG","PFE","DOW","UPS","DELL","LMT","BBY","DIS"]
    var performanceData = [MainStockPerformanceData]()

    func downloadStockPerformanceData(forTickers ticker: [String]) {
        
        // Converts the ticker of type Array into type String for use in URL request with multiple tickers
        let tickerString = ticker.joined(separator: ",")
        
        let urlString = "https://www.alphavantage.co/query?function=BATCH_STOCK_QUOTES&symbols=\(tickerString)&apikey=MPXXRDLBCJO7Y2KK"
        guard let url = URL(string: urlString) else
            { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let jsonData = try JSONDecoder().decode(StockQuotes.self, from: data)
                // Append parsed JSON data into global array for retrieval
                for index in jsonData.stockQuotes {
                    self.performanceData.append(index)
                }
                print(self.performanceData)
                // Delay reload/end refreshing for 3/4 second until so user has chance to see refresher text
                let delayRefresh = DispatchTime.now() + .milliseconds(750)
                DispatchQueue.main.asyncAfter(deadline: delayRefresh) {
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
                
            } catch let error {
                print("Error serializing JSON data:", error)
            }
    
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performanceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stock = performanceData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainStockCell") as! StockCellTableViewCell
        
        cell.setTickerLabels(ticker: stock)
        
        return cell
    }

}
