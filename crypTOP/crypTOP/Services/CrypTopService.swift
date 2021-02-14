//
//  CrypTopService.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 13/02/2021.
//

import Foundation

class CrypTopService{
    //    public func delete(id: Int, completion: @escaping (Bool) -> Void) -> Void {
    //        guard let removeCoffeeURL = URL(string: "https://moc-3a.herokuapp.com/coffee/\(id)") else {
    //            completion(false)
    //            return
    //        }
    //        var request = URLRequest(url: removeCoffeeURL)
    //        request.httpMethod = "DELETE"
    //
    //        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
    //            guard let httpResponse = response as? HTTPURLResponse else {
    //                completion(false)
    //                return
    //            }
    //            completion(httpResponse.statusCode == 204)
    //        }
    //        task.resume()
    //    }
    public static func dictionaryFromMarket(_ market: MarketCoins) -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["NAME"] = market.getName()
        dict["PRICE_USD"] = market.getPriceUsd()
        dict["PRICE_EUR"] = market.getPriceEur()
        
        if let id = market.id {
            dict["ID"] = id
        }
        if let imageURL = market.imageUrl {
            dict["IMAGEURL"] = imageURL.absoluteString
        }
        if let comments = market.comments{
            dict["COMMENTS"] = comments
        }
        return dict
    }
    
    public static func marketFromDictionary(_ dict: [String: Any]) -> MarketCoins? {
        guard let name = dict["NAME"] as? String,
              let price_usd = dict["PRICE_USD"] as? Double,
              let price_eur = dict["PRICE_EUR"] as? Double else {
            return nil
        }
        let id = dict["ID"] as? Int
        let image = dict["IMAGEURL"] as? String
        let comments = dict["COMMENTS"] as? [String]
        let imageURL = image != nil ? URL(string: image!) : nil
        return MarketCoins(id: id, name: name, price_usd: price_usd, price_eur: price_eur, imageURL: imageURL, comments: comments)
    }
    
    public static func create(market: MarketCoins, completion: @escaping (Bool) -> Void) -> Void {
        guard let createMarketURL = URL(string: "https://api-cryptop.herokuapp.com/MarketsCoins/") else {
            completion(false)
            return
        }
        var request = Foundation.URLRequest(url: createMarketURL)
        request.httpMethod = "POST"
        
        let dict = self.dictionaryFromMarket(market)
        print("dict")
        print(dict)

        let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        print("data")
        print(data as Any)

        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            completion(httpResponse.statusCode == 201)
        }
        task.resume()
    }
    
    public static func URLRequest(urlString: String, completion: @escaping ([MarketCoins]) -> Void){
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard err == nil, let d = data else {
                completion([])
                return
            }
            
            // try? -> permet de renvoyer nil cas d'erreur de la fonction jsonObject
            let marketsJson = try? JSONSerialization.jsonObject(with: d, options: .allowFragments)
            guard let markets = marketsJson as? [ [String: Any] ] else {
                completion([])
                return
            }
            let res = markets.compactMap(self.marketFromDictionary(_:))
            completion(res)
        }
        task.resume() // Lance le telechargement
    }

}
