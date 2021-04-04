//
//  URLRequestModel.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 03/04/2021.
//

import Foundation

class Response: ObservableObject, Codable {
    var us: Region
    var eu: Region
    var china: Region
    var korea: Region
    var taiwan: Region
    
    init() {
        self.us = Region()
        self.eu = Region()
        self.china = Region()
        self.korea = Region()
        self.taiwan = Region()
    }
}

class Region: ObservableObject, Codable {
    var region: String = ""
    var currentPrice: Int = 0
    var lastChange: Int = 0
    var timeOfLastChangeUTCTimezone: String = ""
    var timeOfLastChangeUnixEpoch: Int = 0
    var the1_DayLow: Int = 0
    var the1_DayHigh: Int = 0
    var the7_DayLow: Int = 0
    var the7_DayHigh: Int = 0
    var the30_DayLow: Int = 0
    var the30_DayHigh: Int = 0
    var isFromAPI: String = ""
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case region
        case currentPrice = "current_price"
        case lastChange = "last_change"
        case timeOfLastChangeUTCTimezone = "time_of_last_change_utc_timezone"
        case timeOfLastChangeUnixEpoch = "time_of_last_change_unix_epoch"
        case the1_DayLow = "1_day_low"
        case the1_DayHigh = "1_day_high"
        case the7_DayLow = "7_day_low"
        case the7_DayHigh = "7_day_high"
        case the30_DayLow = "30_day_low"
        case the30_DayHigh = "30_day_high"
        case isFromAPI = "is_from_api"
    }
}
