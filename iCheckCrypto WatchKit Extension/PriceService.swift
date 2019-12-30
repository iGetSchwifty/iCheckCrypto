//
//  PriceService.swift
//  iCheckCrypto WatchKit Extension
//
//  Created by Tacenda on 12/15/19.
//  Copyright © 2019 Tacenda. All rights reserved.
//

import RxSwift

public class PriceService {
    private static let semaphore = DispatchSemaphore(value: 1)
    private static var currentlySending = false
    
    public static var cachedPrice: String?
    
    public static func getPrice() -> Single<String>? {
        semaphore.wait()
        guard currentlySending == false else { return nil }
        currentlySending = true
        semaphore.signal()
        
        return fetchResources(url: URL(string: "https://www.cryptocompare.com/coins/omg/overview/USD")!)
            .map { response in
                semaphore.wait()
                currentlySending = false
                semaphore.signal()
                if let responseStr = String(data: response ?? Data(), encoding: .utf8),
                let range = responseStr.range(of: "~OMG~USD~") {
                    let endIndex = responseStr.index(range.lowerBound, offsetBy: 42)
                    let priceChunks = responseStr[range.upperBound...endIndex].split(separator: "~")
                    if priceChunks.count >= 2 {
                        let newPrice = String("$" + priceChunks[1])
                        cachedPrice = newPrice
                        return newPrice
                    }
                }
                return "Invalid Price Fetch"
            }
    }
    
    private static func fetchResources(url: URL) -> Single<Data?> {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return .just(nil)
        }

        guard let url = urlComponents.url else {
            return .just(nil)
        }
        
        return Single.create { observer -> Disposable in
            DispatchQueue.global(qos: .background).async {
                URLSession.shared.dataTask(with: url) { result, _, error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    
                    guard let result = result else {
                        observer(.success(nil))
                        return
                    }
                        
                    observer(.success(result))
                 }.resume()
            }
            
            return Disposables.create()
        }
    }
}
