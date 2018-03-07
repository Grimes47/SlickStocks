//
//  Network.swift
//  SlickStocks
//
//  Created by Adam Hogan on 3/6/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import Foundation

struct NetworkCalls {
    
    static let shared = NetworkCalls()
    static let baseURL = "https://www.alphavantage.co"
    
    private let batchStock = baseURL + "/query?function=BATCH_STOCK_QUOTES&symbols="
    private let singleStock = baseURL + "/query?function=TIME_SERIES_DAILY&symbol="
    private let apiKey = "&apikey=MPXXRDLBCJO7Y2KK"
    
    func downloadBatchStockPerformanceData(forTickers ticker: [String], completion: @escaping (StockQuotes) -> Void) {
        
        // Converts the ticker of type Array into type String for use in URL request with multiple tickers
        let tickerString = ticker.joined(separator: ",")
        
        let urlString = "\(batchStock)\(tickerString)\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let jsonData = try JSONDecoder().decode(StockQuotes.self, from: data)
                completion(jsonData)
                }
         catch let error {
                print("Error serializing JSON data:", error)
            }
        }.resume()
    }
    
    func downloadSingleStockPerformanceData(forTicker ticker: String, completion: @escaping (DetailStockPerformanceData) -> Void) {
        
        
        let urlString = "\(singleStock)\(ticker)\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let jsonData = try JSONDecoder().decode(DetailStockPerformanceData.self, from: data)
                completion(jsonData)
            }
            catch let error {
                print("Error serializing JSON data:", error)
            }
        }.resume()
    }
}
