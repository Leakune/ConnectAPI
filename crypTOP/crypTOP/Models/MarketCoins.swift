//
//  MarketCoins.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 16/01/2021.
//

import Foundation

class MarketCoins {
    
    var id: Int?
    private var name: String
    private var price_usd: Double
    private var price_eur: Double
    var imageUrl: URL?
    var comments: [String]? //ajout nom de l'utilisateur?
    
    var description: String {
        return "market [\(self.id ?? 0), \(self.name), \(self.price_usd), \(self.price_eur)€]"
    }
    
    init(id: Int?, name: String, price_usd: Double, price_eur: Double, imageURL: URL?, comments: [String]?) {
        self.id = id
        self.name = name
        self.price_usd = price_usd
        self.price_eur = price_eur
        self.imageUrl = imageURL
        self.comments = comments
    }
    
//    public func getId() -> Int{ // What the fuck!!! (de la part de Mathieu)
//        return self.id!
//    }
    public func getName() -> String{
        return self.name
    }
    public func getPriceUsd() -> Double{
        return self.price_usd
    }
    public func getPriceEur() -> Double{
        return self.price_eur
    }
//    public func getImageUrl() -> URL{
//        return self.imageUrl!
//    }
//    public func getComments() -> [String]{
//        return self.comments ?? []
//    }

}

