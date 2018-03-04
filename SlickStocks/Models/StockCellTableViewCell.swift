//
//  StockCellTableViewCell.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/3/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import UIKit

class StockCellTableViewCell: UITableViewCell {

    @IBOutlet var tickerSymbol: UILabel!
    @IBOutlet var volume: UILabel!
    @IBOutlet var price: UILabel!
    
    func setTickerLabels(ticker: MainStockPerformanceData) {
        tickerSymbol.text = ticker.symbol
        volume.text = ticker.volume
        price.text = ticker.price
    }
}
