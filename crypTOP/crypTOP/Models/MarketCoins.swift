////
////  MarketCoins.swift
////  crypTOP
////
////  Created by Ludovic FAVIER on 16/01/2021.
////
//
//import Foundation
//
//class MarketCoins {
//
//    var name: String //FROMSYMBOL
//    var price: [String: Double] = [:] //TOSYMBOL + PRICE
//    var srcImage: String //IMAGEURL
//
//
//    init(json: [String: Any]) {
//        guard let raw = json["RAW"] as? [String: Any],
//            //BTC
//            let btc = raw["BTC"] as? [String: Any],
//                //EUR
//                 let eur = btc["EUR"] as? [String: Any],
//                    let name = eur["FROMSYMBOL"] as? String,
//                        //self.name = name
//                    let price = eur["PRICE"] as? Double,
//                    let currency = eur["TOSYMBOL"] as? String,
//                        //self.price[currency] = price
//
//                    if let imageUrl = eur["IMAGEURL"] as? String,
//                        //self.srcImage = imageUrl
//                //USD
//                let usd = btc["USD"] as? [String: Any],
//                    let priceUSD = usd["PRICE"] as? Double, let currency = usd["TOSYMBOL"] as? String
//                        self.price[currency] = priceUSD
//
//            //ETH
//            let eth = raw["ETH"] as? [String: Any]
//                //EUR
//                let eurEth = eth["USD"] as? [String: Any],
//                    let nameEth = eurEth["FROMSYMBOL"] as? String,
//                        //self.name = name
//                    let price = eurEth["PRICE"] as? Double, let currency = eur["TOSYMBOL"] as? String
//                        self.price[currency] = price
//                    let imageUrl = eurEth["IMAGEURL"] as? String
//                        self.srcImage = imageUrl
//                //USD
//                if let usd = eth["USD"] as? [String: Any] {
//                    if let name = usd["FROMSYMBOL"] as? String{
//                        self.name = name
//                    }
//                    if let price = usd["PRICE"] as? Double, let currency = usd["TOSYMBOL"] as? String{
//                        self.price[currency] = price
//                    }
//                    if let imageUrl = usd["IMAGEURL"] as? String{
//                        self.srcImage = imageUrl
//                    }
//                }
//            }
//        }
//
//    }
//
//}
//
//extension MarketCoins{
//
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
//}
