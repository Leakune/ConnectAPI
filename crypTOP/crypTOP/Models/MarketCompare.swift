//
//  MarketCompare.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 13/02/2021.
//

import Foundation

class MarketCompare{
    private var name: String //FROMSYMBOL
    private var price: [String: Double] = [:] //TOSYMBOL + PRICE
    private var imageUrl: URL? //IMAGEURL

    init(name: String) {
        self.name = name
    }
    public func addPrice(currency: String, price: Double){
        self.price[currency] = price
    }
    public func setSrcImage(srcImage: String){
        let imageURL = URL(string: srcImage)
        self.imageUrl = imageURL
    }
    
    public func getName() -> String{
        return self.name
    }
    public func getPrice() -> [String: Double]{
        return self.price
    }
    public func getImageUrl() -> URL{
        return self.imageUrl!
    }
}
