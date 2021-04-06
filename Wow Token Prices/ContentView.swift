//
//  ContentView.swift
//  Wow Token Prices
//
//  Created by Daniel Reszyński on 19/01/2021.
//

import SwiftUI

struct ContentView: View {
    @State var result: Response = Response()
    @State private var uiUpdate = 0
    
    var regions = ["US", "EU", "China", "Korea", "Taiwan"]
    @State private var selectedRegion = "US"
    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    Picker("Pick your region", selection: $selectedRegion) {
                        ForEach(regions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(30)
                    
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
                    
                    Text("\(uiUpdate)")
                        .foregroundColor(Color.gray.opacity(0))
                }
                .tabItem() {
                    Text("Current prices")
                    Image(systemName: "dollarsign.square.fill")
                }
                
                HistoryView()
                    .tabItem {
                        Text("History prices")
                        Image(systemName: "chart.bar.xaxis")
                    }
                
                AboutView()
                    .tabItem {
                        Text("About")
                        Image(systemName: "questionmark.circle.fill")
                    }
                
            }
            .navigationBarTitle("WoWTokenPrices")
        }
        .onAppear(perform: loadData)
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
    
    func loadData() {
        guard let url = URL(string: "https://wowtokenprices.com/current_prices.json") else {
            print("Invalid URL")
            return
        }
        print("Loading data...")
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Got data!")
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        print("Decoding data...")
                        self.uiUpdate = 1
                        result.us = decodedResponse.us
                        result.eu = decodedResponse.eu
                        result.china = decodedResponse.china
                        result.korea = decodedResponse.korea
                        result.taiwan = decodedResponse.taiwan
                        self.uiUpdate = 0
                        print("Decoded data!")
                    }
                    return
                }
            }
            print("Fetch failed \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
