//
//  MarketCoins.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 16/01/2021.
//

import Foundation

class MarketCoins {

    var name: String //FROMSYMBOL
    var price: [String: Double] = [:] //TOSYMBOL + PRICE
    var srcImage: String? //IMAGEURL


    init(name: String) {
        self.name = name
    }
    public func addPrice(currency: String, price: Double){
        self.price[currency] = price
    }
    public func setSrcImage(srcImage: String){
        self.srcImage = srcImage
    }

}

extension MarketCoins{

//    static func initMarket(urlString: String, completion: ([MarketCoins]) -> Void) {
//        // Create a URLRequest for API Cryptocompare (BTC as coin, USD and EUR as cryptocurrencies)
//        let url = URL(string: urlString)!
//        let task = URLSession.shared.dataTask(with: url, ) { data, response, error in
//            if let data = data{
//                do{
//                    if let json =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
//                    //if let root = json as? [String: Any] {
//
//                    }
//
//                    //print(json)
//
////                    DispatchQueue.main.async {
////                        self.priceLabel.text = json
////                    }
//                } catch{
//                    print(error)
//                }
//            }
////            if let error = error {
////                return
////            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                (200...299).contains(httpResponse.statusCode) else {
//                return
//            }
//        }
//        task.resume()
//    }
}
