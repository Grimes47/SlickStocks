//
//  ViewController.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/2/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let traits = UITraitCollection()
    var tableViewSymbolToPass: String?
    var tableViewPriceToPass: String?
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshStockPrices(_:)), for: .valueChanged)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing Stock Prices...")
        
        return refresher
    }()
    
    // Used to refresh the stock prices from the refresh pull-down
    @objc private func refreshStockPrices(_ sender: Any) {
        downloadStockPerformanceData(forTickers: defaultTickerSymbols)
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
     //Collapses the master view controller onto the details view controller if the horizontal size class (i.e. iPhone SE/6/7/8) of the user's device is compact
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        switch traits.horizontalSizeClass {
        case .compact:
            return true
        case .regular:
            return false
        case .unspecified:
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.splitViewController?.delegate = self
        //Presents the master view controller on launch without having to swip-to-show
        self.splitViewController?.preferredDisplayMode = .allVisible
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
    
    private var performanceData = [MainStockPerformanceData]()

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
                // Delay reload/end refreshing for 3/4 second so user has chance to see refresher text
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let detailVC = segue.destination as? DetailViewController else { return }
        
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCell = tableView.cellForRow(at: indexPath) as! StockCellTableViewCell
                tableViewSymbolToPass = selectedCell.tickerSymbol.text
                tableViewPriceToPass = selectedCell.price.text
                if let symbol = tableViewSymbolToPass, let price = tableViewPriceToPass {
                    detailVC.tickerSymbolFromSelectedRow = symbol
                    detailVC.priceFromSelectedRow = price
                }
        }
    }
}
