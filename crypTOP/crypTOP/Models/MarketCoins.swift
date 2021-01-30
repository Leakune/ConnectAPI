//
//  MarketCoins.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 16/01/2021.
//

import Foundation

class MarketCoins {
    private var name: String //FROMSYMBOL
    private var price: [String: Double] = [:] //TOSYMBOL + PRICE
    private var srcImage: String? //IMAGEURL


    init(name: String) {
        self.name = name
    }
    public func addPrice(currency: String, price: Double){
        self.price[currency] = price
    }
    public func setSrcImage(srcImage: String){
        self.srcImage = srcImage
    }
    public func getName() -> String{
        return self.name
    }
    public func getImage() -> String{
        return self.srcImage!
    }

}

extension MarketCoins{
    public static func createMarketCoins(jsonObject: Any, marketCoins: inout MarketCoins, parameters: [String], currencies: [String]) {
        if let array = jsonObject as? [Any] {
            array.forEach {
                createMarketCoins(jsonObject: $0, marketCoins: &marketCoins, parameters: parameters, currencies: currencies)
            }
        }
        else if let dict = jsonObject as? [String : Any] {
            for key in dict.keys {
                if currencies.contains(key) {
                    //marketsCoins.append(dict[key] as! String)
                    if let currency = dict[key] as? [String: Any] {
                        guard let price = currency["PRICE"] as? Double, let cur = currency["TOSYMBOL"] as? String else{
                            print("Error in searching price or cur in currency:" + key)
                            return
                        }
                        guard let imageUrl = currency["IMAGEURL"] as? String else{
                            print("Error in searching imageUrl in currency:" + key)
                            return
                        }
                        marketCoins.addPrice(currency: cur, price: price)
                        marketCoins.setSrcImage(srcImage: "cryptocompare.com" + imageUrl)
                    }
                    print(key)
                }
                else {
                    createMarketCoins(jsonObject: dict[key]!, marketCoins: &marketCoins, parameters: parameters, currencies: currencies)
                }
            }
        }
    }
    public static func extractMarketsCoins(jsonObject: Any, marketsCoins: inout [MarketCoins], parameters: [String], currencies: [String]) {
        if let array = jsonObject as? [Any] {
            array.forEach {
                extractMarketsCoins(jsonObject: $0, marketsCoins: &marketsCoins, parameters: parameters, currencies: currencies)
            }
        }
        else if let dict = jsonObject as? [String : Any] {
            for key in dict.keys {
                if parameters.contains(key) {
                    //marketsCoins.append(dict[key] as! String)
                    marketsCoins.append(MarketCoins(name: key))
                    guard var lastMarket = marketsCoins.last else{
                        print("Error in creating a marketCoins")
                        return
                    }
                    createMarketCoins(jsonObject: dict[key]!, marketCoins: &lastMarket, parameters: parameters, currencies: currencies)
                    print(key)
                }
                else {
                    extractMarketsCoins(jsonObject: dict[key]!, marketsCoins: &marketsCoins, parameters: parameters, currencies: currencies)
                }
            }
        }
    }
    public static func URLRequest(urlString: String, completion: @escaping ([MarketCoins]) -> Void){
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            if let data = data{
                do{
                    if let json =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let raw = json["RAW"] as? [String: Any] {
                            var marketsCoins = [MarketCoins]()
                            let parameters = ["BTC", "ETH"]
                            let currencies = ["USD", "EUR"]
                            self.extractMarketsCoins(jsonObject: raw, marketsCoins: &marketsCoins, parameters: parameters, currencies: currencies)
                            completion(marketsCoins)
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        .resume()
    }

}
