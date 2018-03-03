//
//  ViewController.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/2/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        downloadStockPerformanceData(forTickers: defaultTickerSymbols)
    }
    
    let defaultTickerSymbols = ["NKE","MSFT","AAPL","GOOG","ORCL","COST","AMZN","WMT","GE","XOM","CVX","GM","VLO","BA","WAG","AIG","PFE","DOW","UPS","DELL","LMT","BBY","DIS"]
    var performanceData = [MainStockPerformanceData]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

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
                for index in jsonData.stockQuotes {
                    self.performanceData.append(index)
                }
                print(self.performanceData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
