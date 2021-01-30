//
//  HomeViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 27/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    public var markets: [MarketCoins]? = nil

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //appel unique de la fonction iniMarkets
        print("ViewWillAppear")
        dump(self.markets)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        _ = initMarkets
        dump(self.markets)
        //self.priceLabel.text = self.markets?[0].getName()

        // Do any additional setup after loading the view.
    }
    //Appeler qu'une seule fois la fonction pour initialiser des markets
    private lazy var initMarkets: Void = {
        var markets = [MarketCoins]()
        let fsyms = "BTC,ETH"
        let tsyms = "USD,EUR"
        let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
        MarketCoins.URLRequest(urlString: urlString,completion:{ marketCoins in
            DispatchQueue.main.async {
                self.markets = marketCoins
                print("InitMarket")
                dump(self.markets)
                self.priceLabel.text = marketCoins[0].getName()
                self.imageLabel.prepareDownLoad(from: marketCoins[0].getImage())
            }
        })
        self.markets = markets


    }()
    

}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func prepareDownLoad(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
