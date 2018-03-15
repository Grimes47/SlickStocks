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
    var tableViewLogoToPass: UIImage?
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var performanceData = [MainStockPerformanceData]()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshStockPrices(_:)), for: .valueChanged)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing Stock Prices...")
        
        return refresher
    }()
    
    //Used to refresh the stock prices from the refresh pull-down
    @objc private func refreshStockPrices(_ sender: Any) {
        downloadBatchStockData()
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
        tableView.separatorColor = .clear
        self.splitViewController?.delegate = self
        //Presents the master view controller on launch without having to swip-to-show
        self.splitViewController?.preferredDisplayMode = .allVisible
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadBatchStockData()
        // Forces un-highlight of selected row when coming back to the main VC from the detail VC
        let selectedRow = tableView.indexPathForSelectedRow
        if let rowIsSelected = selectedRow {
            tableView.deselectRow(at: rowIsSelected, animated: true)
        }
    }
    
    let defaultTickerSymbols = ["NKE","MSFT","AAPL","GOOG","ORCL","COST","AMZN","WMT","GE","XOM","CVX","GM","VLO","BA","WAG","AIG","PFE","DOW","UPS","DELL","LMT","BBY","DIS"]
    
    
    
    func downloadBatchStockData() {
        //downloadStockPerformanceData(forTickers: defaultTickerSymbols)
        NetworkCalls.shared.downloadBatchStockPerformanceData(forTickers: defaultTickerSymbols) { (completion) in
            if self.performanceData.isEmpty != true {
                self.performanceData.removeAll()
            }
            // Append parsed JSON data into global array for retrieval
            for index in completion.stockQuotes {
                self.performanceData.append(index)
            }
            // Delay reload/end refreshing for 3/4 second so user has chance to see refresher text
            let delayRefresh = DispatchTime.now() + .milliseconds(750)
            DispatchQueue.main.asyncAfter(deadline: delayRefresh) {
                self.tableView.reloadData()
                self.activitySpinner.stopAnimating()
                self.refresher.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performanceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stock = performanceData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainStockCell") as! StockCellTableViewCell
        
        // Forces the cell border set to edge-to-edge on the display
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        // Sets the separator color for the cells back to default. The color is .clear in viewDidLoad to give the tableView time to set up the appropriate cell size
        tableView.separatorColor = nil
        
        cell.setTickerLabels(ticker: stock, logo: UIImage.init(named: "\(performanceData[indexPath.row].symbol)")!)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        // Sets the stock ticker variable. This is passed to the detail VC via segue
        let stock = performanceData[indexPath.row]
        tableViewPriceToPass = stock.price
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let detailVC = segue.destination as? DetailViewController else { return }
        
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCell = tableView.cellForRow(at: indexPath) as! StockCellTableViewCell
                tableViewSymbolToPass = selectedCell.tickerSymbol.text
                tableViewLogoToPass = selectedCell.companyLogo.image
                if let symbol = tableViewSymbolToPass, let price = tableViewPriceToPass, let logo = tableViewLogoToPass {
                    detailVC.tickerSymbolFromSelectedRow = symbol
                    detailVC.priceFromSelectedRow = price
                    detailVC.logoFromSelectedRow = logo
                }
        }
    }
}





