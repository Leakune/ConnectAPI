//
//  HomeViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 27/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
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

//        MarketCoins.initMarket(urlString: urlString){ markets in
//            self.markets = markets
//        }
    }()
    
    func URLRequest(urlString: String){
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data{
                do{
                    if let json =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let raw = json["RAW"] as? [String: Any] {
                            //BTC
                            print("In BTC:\n")
                            if let btc = raw["BTC"] as? [String: Any] {
                                //EUR
                                print("In Eur:\n")
                                if let eur = btc["EUR"] as? [String: Any] {
                                    if let name = eur["FROMSYMBOL"] as? String{
                                        print("name is:" + name)
                                    }
                                    if let price = eur["PRICE"] as? Double{
                                        print("Price is:\(price)")
                                    }
                                    if let currency = eur["TOSYMBOL"] as? String{
                                        print("Currency is:" + currency)
                                    }
                                    if let imageUrl = eur["IMAGEURL"] as? String{
                                        print("ImageUrl is:" + imageUrl)
                                    }
                                }
                                //USD
                                print("In usd:\n")
                                if let usd = btc["USD"] as? [String: Any] {
                                    if let name = usd["FROMSYMBOL"] as? String{
                                        print("name is:" + name)
                                    }
                                    if let price = usd["PRICE"] as? Double{
                                        print("Price is:\(price)")
                                    }
                                    if let currency = usd["TOSYMBOL"] as? String{
                                        print("Currency is:" + currency)
                                    }
                                    if let imageUrl = usd["IMAGEURL"] as? String{
                                        print("ImageUrl is:" + imageUrl)
                                    }
                                }
                            }
                            //ETH
                            print("\nIn ETH:\n")
                            if let eth = raw["ETH"] as? [String: Any] {
                                //EUR
                                print("In Eur:\n")
                                if let eur = eth["USD"] as? [String: Any] {
                                    if let name = eur["FROMSYMBOL"] as? String{
                                        print("name is:" + name)
                                    }
                                    if let price = eur["PRICE"] as? Double{
                                        print("Price is:\(price)")
                                    }
                                    if let currency = eur["TOSYMBOL"] as? String{
                                        print("Currency is:" + currency)
                                    }
                                    if let imageUrl = eur["IMAGEURL"] as? String{
                                        print("ImageUrl is:" + imageUrl)
                                    }
                                }
                                //USD
                                if let usd = eth["USD"] as? [String: Any] {
                                    if let name = usd["FROMSYMBOL"] as? String{
                                        print("name is:" + name)
                                    }
                                    if let price = usd["PRICE"] as? Double{
                                        print("Price is:\(price)")
                                    }
                                    if let currency = usd["TOSYMBOL"] as? String{
                                        print("Currency is:" + currency)
                                    }
                                    if let imageUrl = usd["IMAGEURL"] as? String{
                                        print("ImageUrl is:" + imageUrl)
                                    }
                                }
                            }
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
