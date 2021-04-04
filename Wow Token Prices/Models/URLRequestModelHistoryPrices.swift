//
//  URLRequestModelHistoryPrices.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 03/04/2021.
//

import Foundation

class HistoryResponse: Codable {
    var us, eu, china, korea, taiwan: [HistoryRegion]

    init() {
        self.us = [HistoryRegion()]
        self.eu = [HistoryRegion()]
        self.china = [HistoryRegion()]
        self.korea = [HistoryRegion()]
        self.taiwan = [HistoryRegion()]
    }
}

class HistoryRegion: Codable {
    var price: Int = 0
    var time: Int = 0

    init() {}
}
