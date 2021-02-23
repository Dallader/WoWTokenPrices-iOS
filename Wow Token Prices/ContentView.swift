//
//  ContentView.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 19/01/2021.
//

import SwiftUI

struct Response: Codable {
    let us, eu, china, korea, taiwan: Region
}

struct Region: Codable {
    var region: String = ""
    var currentPrice: Int = 2137
    var lastChange: Int = 0
    var timeOfLastChangeUTCTimezone: String = ""
    var timeOfLastChangeUnixEpoch: Double = 0
    var the1_DayLow: Int = 0
    var the1_DayHigh: Int = 0
    var the7_DayLow: Int = 0
    var the7_DayHigh: Int = 0
    var the30_DayLow: Int = 0
    var the30_DayHigh: Int = 0
    var isFromAPI: String = ""

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
    @State private var result: Response = Response(us: Region(), eu: Region(), china: Region(), korea: Region(), taiwan: Region())
    
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
                        self.result = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Picker("Pick your region", selection: $selectedRegion) {
                        ForEach(regions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("Current token price is: \(result.eu.currentPrice)")
                        .font(.title2)
                    Text("Last update: \(result.eu.timeOfLastChangeUTCTimezone)")
                        .font(.subheadline)
                }
            }
            .navigationBarTitle("WoWTokenPrices")
        }
        .onAppear(perform: loadData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
