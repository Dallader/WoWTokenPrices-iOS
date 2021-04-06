//
//  HistoryView.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 03/04/2021.
//

import SwiftUI
import SwiftUICharts

struct HistoryView: View {
    @State private var historyResponse: HistoryResponse = HistoryResponse()
    
    var regions = ["US", "EU", "China", "Korea", "Taiwan"]
    @State private var selectedRegion = "US"
    
    @State private var uiUpdate = 0
    @State private var pricesUS: [Double] = [Double]()
    @State private var pricesEU: [Double] = [Double]()
    @State private var pricesChina: [Double] = [Double]()
    @State private var pricesKorea: [Double] = [Double]()
    @State private var pricesTaiwan: [Double] = [Double]()
    
    @State private var day: Int = 1
    var dayOptions = ["1 Day", "7 Days", "30 Days"]
    @State private var selectedDay = "1 Day"
    
    var body: some View {
        VStack {
            Picker("Pick your region", selection: $selectedRegion) {
                ForEach(regions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(30)
            Picker("Pick day range", selection: $selectedDay) {
                ForEach(dayOptions, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: selectedDay) { newDay in
                print("day changed to \(newDay)")
                switch self.selectedDay {
                case "1 Day":
                    self.day = 1
                case "7 Days":
                    self.day = 7
                case "30 Days":
                    self.day = 30
                default:
                    self.day = 1
                }
                loadData()
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            LineView(data: selectedRegionToPrices(region: selectedRegion), title: "\(day) Day history", legend: "\(selectedRegion)")
                .padding()
                .onAppear(perform: { pricesUS.isEmpty ? loadData() : nil })
        }
    }
    func selectedRegionToPrices(region: String) -> [Double] {
        switch region {
        case "US":
            return pricesUS
        case "EU":
            return pricesEU
        case "China":
            return pricesChina
        case "Korea":
            return pricesKorea
        case "Taiwan":
            return pricesTaiwan
        default:
            return pricesUS
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://wowtokenprices.com/history_prices_\(day)_day.json") else {
            print("Invalid URL")
            return
        }
        print("Loading data...")
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Got data!")
                if let decodedResponse = try? JSONDecoder().decode(HistoryResponse.self, from: data) {
                    DispatchQueue.main.async {
                        print("Decoding data...")
                        uiUpdate = 1
                        pricesUS.removeAll()
                        pricesEU.removeAll()
                        pricesChina.removeAll()
                        pricesKorea.removeAll()
                        pricesTaiwan.removeAll()
                        historyResponse.us = decodedResponse.us
                        for index in historyResponse.us {
                            let indexPrices = Double(index.price)
                            pricesUS.append(round(indexPrices))
                        }
                        historyResponse.eu = decodedResponse.eu
                        for index in historyResponse.eu {
                            let indexPrices = Double(index.price)
                            pricesEU.append(indexPrices)
                        }
                        historyResponse.china = decodedResponse.china
                        for index in historyResponse.china {
                            let indexPrices = Double(index.price)
                            pricesChina.append(indexPrices)
                        }
                        historyResponse.korea = decodedResponse.korea
                        for index in historyResponse.korea {
                            let indexPrices = Double(index.price)
                            pricesKorea.append(indexPrices)
                        }
                        historyResponse.taiwan = decodedResponse.taiwan
                        for index in historyResponse.taiwan {
                            let indexPrices = Double(index.price)
                            pricesTaiwan.append(indexPrices)
                        }
                        print("Decoded data!")
                        uiUpdate = 0
                        
                        filterArrays(rate: { () -> Int in 
                            switch day {
                            case 1:
                                return 1
                            case 7:
                                return 7
                            case 30:
                                return 30
                            default:
                                return 1
                            }
                        }(), us: pricesUS, eu: pricesEU, china: pricesChina, korea: pricesKorea, taiwan: pricesTaiwan)
                    }
                    return
                }
            }
            print("Fetch failed \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func filterArrays(rate: Int, us: [Double], eu: [Double], china: [Double], korea: [Double], taiwan: [Double]) {
        let arr: [[Double]] = [us, eu, china, korea, taiwan]
        var filteredPrices = [[Double]]()
        
        for table in arr {
            var filteredArray = [Double]()
            for (index, item) in table.enumerated() {
                if index.isMultiple(of: rate) {
                    filteredArray.append(item)
                }
            }
            filteredPrices.append(filteredArray)
        }
        self.pricesUS = filteredPrices[0]
        self.pricesEU = filteredPrices[1]
        self.pricesChina = filteredPrices[2]
        self.pricesKorea = filteredPrices[3]
        self.pricesTaiwan = filteredPrices[4]
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
