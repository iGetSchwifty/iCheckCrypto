//
//  ContentView.swift
//  iCheckCrypto WatchKit Extension
//
//  Created by Tacenda on 12/14/19.
//  Copyright © 2019 Tacenda. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var display: String = "Loading..."
    
    let timer = Timer.publish(every: 15, on: .current, in: .common).autoconnect()
    
    var body: some View {
        Text(display)
            .onAppear(perform: {
                self.getPrice()
            })
            .onReceive(timer, perform: { _ in
                self.getPrice()
            })
            .foregroundColor(.white)
    }
    
    
    private func getPrice() {
        DispatchQueue.global(qos: .background).async {
            self.fetchResources(url: URL(string: "https://www.cryptocompare.com/coins/omg/overview/USD")!) { response in
                if let responseStr = String(data: response ?? Data(), encoding: .utf8),
                let range = responseStr.range(of: "~OMG~USD~") {
                    let endIndex = responseStr.index(range.lowerBound, offsetBy: 42)
                    let priceChunks = responseStr[range.upperBound...endIndex].split(separator: "~")
                    if priceChunks.count >= 2 {
                        DispatchQueue.main.async {
                            self.display = String("OMG: $" + priceChunks[1])
                        }
                    }
                }
            }
        }
    }
    
    private func fetchResources(url: URL, completion: @escaping (Data?) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(nil)
            return
        }

        guard let url = urlComponents.url else {
            completion(nil)
            return
        }
     
        URLSession.shared.dataTask(with: url) { result, _, _ in
            guard let result = result else {
                completion(nil)
                return
            }
                
            completion(result)
         }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
