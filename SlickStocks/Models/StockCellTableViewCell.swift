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
    @IBOutlet var price: UILabel!
    @IBOutlet var companyLogo: UIImageView!
    
    func setTickerLabels(ticker: MainStockPerformanceData, logo: UIImage) {
        tickerSymbol.text = ticker.symbol
        price.text = ("$\(ticker.price.convertToDecimal().roundDecimal())")
        companyLogo.image = logo
    }
}
