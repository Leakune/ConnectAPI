//
//  HomeViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 27/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    public var markets: [MarketCoins]? = nil
    var marketToDelete: String?

    @IBOutlet var btc: UIImageView!
    @IBOutlet var eth: UIImageView!
    @IBOutlet var doge: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        print("ViewWillAppear")
//        let marketToDelete = storyboard?.instantiateViewControllerWithIdentifier("childView") as DetailViewController
//        marketToDelete.delegate = self
        dump(self.markets)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        //appel unique de la fonction iniMarkets
        _ = initMarkets
        dump(self.markets)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.btc.isUserInteractionEnabled = true
        self.btc.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.eth.isUserInteractionEnabled = true
        self.eth.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.doge.isUserInteractionEnabled = true
        self.doge.addGestureRecognizer(tapGestureRecognizer3)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        var marketToGo: MarketCoins!
        switch tappedImage.tag {
        case 0:
            marketToGo = self.markets![1]
            break
        case 1:
            marketToGo = self.markets![0]
            break
        case 2:
            marketToGo = self.markets![2]
            break
        default:
            return
        }
        self.navigationController?.pushViewController(DetailViewController.newInstance(market: marketToGo), animated: true)
    }
    
    //Appeler qu'une seule fois la fonction pour initialiser des markets
    private lazy var initMarkets: Void = {
        var markets = [MarketCoins]()
        let fsyms = "BTC,ETH,DOGE"
        let tsyms = "USD,EUR"
        let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
        MarketCoins.URLRequest(urlString: urlString,completion:{ marketCoins in
            DispatchQueue.main.async {
                self.markets = marketCoins
                print("InitMarket")
                dump(self.markets)
                //self.priceLabel.text = marketCoins[0].getName()
                print(marketCoins[0].getImage())
                self.btc.downloaded(from: marketCoins[1].getImage())
                self.eth.downloaded(from: marketCoins[0].getImage())
                self.doge.downloaded(from: marketCoins[2].getImage())
            }
        })
    }()
    

}
//extension HomeViewController: SelectTagDelegate {
//    func didSelectTag(tags: String) {
//        marketToDelete = tags
//    }
//}
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
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
//class CustomUIImageView: UIImageView {
//    var imageValue: String?
//    func customAddGestureRecognizer(tap: UITapGestureRecognizer, imageValue: String){
//        print("here2")
//        self.addGestureRecognizer(tap)
//        self.imageValue = imageValue
//    }
//}
