//
//  ContentView.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 19/01/2021.
//

import SwiftUI

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
    var currentPrice: Int = 2137
    var lastChange: Int = 0
    var timeOfLastChangeUTCTimezone: String = ""
    var timeOfLastChangeUnixEpoch: Int = 0
    var the1_DayLow: String = ""
    var the1_DayHigh: String = ""
    var the7_DayLow: Int = 0
    var the7_DayHigh: Int = 0
    var the30_DayLow: Int = 0
    var the30_DayHigh: Int = 0
    var isFromAPI: String = ""
    
    init() {}
    
//    init(region: String, currentPrice: Int, lastChange: Int, timeOfLastChangeUTCTimezone: String, timeOfLastChangeUnixEpoch: Int, the1_DayLow: Int, the1_DayHigh: Int, the7_DayLow: Int, the7_DayHigh: Int, the30_DayLow: Int, the30_DayHigh: Int, isFromAPI: String) {
//            self.region = region
//            self.currentPrice = currentPrice
//            self.lastChange = lastChange
//            self.timeOfLastChangeUTCTimezone = timeOfLastChangeUTCTimezone
//            self.timeOfLastChangeUnixEpoch = timeOfLastChangeUnixEpoch
//            self.the1_DayLow = the1_DayLow
//            self.the1_DayHigh = the1_DayHigh
//            self.the7_DayLow = the7_DayLow
//            self.the7_DayHigh = the7_DayHigh
//            self.the30_DayLow = the30_DayLow
//            self.the30_DayHigh = the30_DayHigh
//            self.isFromAPI = isFromAPI
//        }

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

struct ContentView: View {
    @State var result: Response = Response()
    
    var regions = ["US", "EU", "China", "Korea", "Taiwan"]
    @State private var selectedRegion = "US"
    
    func loadData() {
        guard let url = URL(string: "https://wowtokenprices.com/current_prices.json") else {
            print("Invalid URL")
            return
        }
        print("Loading data...")
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Got data!")
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        print("Decoding data...")
                        result.us = decodedResponse.us
                        result.eu = decodedResponse.eu
                        result.china = decodedResponse.china
                        result.korea = decodedResponse.korea
                        result.taiwan = decodedResponse.taiwan
                        print("Decoded data!")
                    }
                    return
                }
            }
            print("Fetch failed \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    func selectedRegionToRegion(data: Response) -> Region {
        switch selectedRegion {
        case "US":
            return data.us
        case "EU":
            return data.eu
        case "China":
            return data.china
        case "Korea":
            return data.korea
        case "Taiwan":
            return data.taiwan
        default:
            return data.us
        }
    }
    var body: some View {
        NavigationView {
            Section {
                VStack {
                    Picker("Pick your region", selection: $selectedRegion) {
                        ForEach(regions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Current token price is: \(selectedRegionToRegion(data: result).currentPrice)")
                        .font(.title2)
                    HStack {
                        (selectedRegionToRegion(data: result).lastChange >= 0 ? Image(systemName: "arrow.up.right") : Image(systemName: "arrow.down.right"))
                        Text("\(selectedRegionToRegion(data: result).lastChange)")
                    }
                    .foregroundColor((selectedRegionToRegion(data: result).lastChange >= 0 ? Color.green : Color.red))
                        .font(.title2)
                    Button("Refresh data", action: loadData)
                    Text("Last update: \(selectedRegionToRegion(data: result).timeOfLastChangeUTCTimezone)")
                        .font(.subheadline)
                }
            }
            .navigationBarTitle("WoWTokenPrices")
            Spacer()
        }
        .onAppear(perform: loadData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
