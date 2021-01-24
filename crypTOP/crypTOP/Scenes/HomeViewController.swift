//
//  HomeViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 27/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    private let currency = ["USD", "EUR"]
    //private var markets: [MarketCoins]
    @IBOutlet var priceLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //appel unique de la fonction iniMarkets
        _ = initMarkets
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.URLRequest()

        // Do any additional setup after loading the view.
    }
    //Appeler qu'une seule fois la fonction pour initialiser des markets
    private lazy var initMarkets: Void = {
        let fsyms = "BTC,ETH"
        let tsyms = "USD,EUR"
        let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
        URLRequest(urlString: urlString)

    }()
    func createMarketCoins(jsonObject: Any, marketCoins: inout MarketCoins, parameters: [String]) {
        if let array = jsonObject as? [Any] {
            array.forEach {
                createMarketCoins(jsonObject: $0, marketCoins: &marketCoins, parameters: parameters)
            }
        }
        else if let dict = jsonObject as? [String : Any] {
            for key in dict.keys {
                if self.currency.contains(key) {
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
                        marketCoins.setSrcImage(srcImage: imageUrl)
                    }
                    print(key)
                }
                else {
                    createMarketCoins(jsonObject: dict[key]!, marketCoins: &marketCoins, parameters: parameters)
                }
            }
        }
    }
    func extractMarketsCoins(jsonObject: Any, marketsCoins: inout [MarketCoins], parameters: [String]) {
        if let array = jsonObject as? [Any] {
            array.forEach {
                extractMarketsCoins(jsonObject: $0, marketsCoins: &marketsCoins, parameters: parameters)
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
                    createMarketCoins(jsonObject: dict[key]!, marketCoins: &lastMarket, parameters: parameters)
                    print(key)
                }
                else {
                    extractMarketsCoins(jsonObject: dict[key]!, marketsCoins: &marketsCoins, parameters: parameters)
                }
            }
        }
    }
    func URLRequest(urlString: String){
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data{
                do{
                    if let json =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let raw = json["RAW"] as? [String: Any] {
                            var marketsCoins = [MarketCoins]()
                            let parameters = ["BTC", "ETH"]
                            self.extractMarketsCoins(jsonObject: raw, marketsCoins: &marketsCoins, parameters: parameters)
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    

}
