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
    
    var day: Int

    var body: some View {
        VStack {
            Picker("Pick your region", selection: $selectedRegion) {
                ForEach(regions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(30)
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
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Got data!")
                if let decodedResponse = try? JSONDecoder().decode(HistoryResponse.self, from: data) {
                    DispatchQueue.main.async {
                        print("Decoding data...")
                        uiUpdate = 1
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
                    }
                    return
                }
            }
            print("Fetch failed \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(day: 1)
    }
}
