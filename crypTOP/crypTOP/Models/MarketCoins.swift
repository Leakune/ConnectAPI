//
//  MarketCoins.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 16/01/2021.
//

import Foundation

class MarketCoins {
    
    private var id: Int?
    private var name: String
    private var price_usd: Double
    private var price_eur: Double
    private var imageUrl: URL?
    var description: String {
        return "market [\(self.id ?? 0), \(self.name), \(self.price_usd), \(self.price_eur)€]"
    }
    
    init(id: Int?, name: String, price_usd: Double, price_eur: Double, imageURL: URL?) {
        self.id = id
        self.name = name
        self.price_usd = price_usd
        self.price_eur = price_eur
        self.imageUrl = imageURL
    }
    
    public func getId() -> Int{
        return self.id!
    }
    public func getName() -> String{
        return self.name
    }
    public func getPriceUsd() -> Double{
        return self.price_usd
    }
    public func getPriceEur() -> Double{
        return self.price_eur
    }
    public func getImageUrl() -> URL{
        return self.imageUrl!
    }

}

extension MarketCoins{
    
    public static func marketFromDictionary(_ dict: [String: Any]) -> MarketCoins? {
        guard let name = dict["NAME"] as? String,
              let price_usd = dict["PRICE_USD"] as? Double,
              let price_eur = dict["PRICE_EUR"] as? Double else {
            return nil
        }
        let id = dict["ID"] as? Int
        let image = dict["IMAGEURL"] as? String
        let imageURL = image != nil ? URL(string: image!) : nil
        return MarketCoins(id: id, name: name, price_usd: price_usd, price_eur: price_eur, imageURL: imageURL)
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
