//
//  ContentView.swift
//  iCheckCrypto WatchKit Extension
//
//  Created by Tacenda on 12/14/19.
//  Copyright © 2019 Tacenda. All rights reserved.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    @State private var display: String = "Loading..."
    
    private let disposeBag = DisposeBag()
    
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
        PriceService.getPrice().subscribe(onSuccess: { price in
            self.display = "OMG: \(price)"
        }) { _ in
            self.display = "Error Fetching Price"
        }.disposed(by: self.disposeBag)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
