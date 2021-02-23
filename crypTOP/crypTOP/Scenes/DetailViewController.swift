//
//  DetailViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 30/01/2021.
//

import UIKit
class DetailViewController: UIViewController, UINavigationControllerDelegate {
    var market: MarketCoins!

    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var priceEur: UILabel!
    @IBOutlet var priceUsd: UILabel!
    
    static func newInstance(market: MarketCoins) -> DetailViewController {
        let controller = DetailViewController()
        controller.market = market
        return controller
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("In Detail")
        dump(self.market)
        self.title = "Detail"
        if let data = NSData(contentsOf: self.market.imageUrl!)
        {
            self.icon.image = UIImage(data: data as Data)
        }
        self.name.text = self.market.getName()
        let priceUsd = String(format: "%.3f", self.market.getPriceUsd())
        let priceEur = String(format: "%.3f", self.market.getPriceEur())

        self.priceUsd.text = "$" + priceUsd
        self.priceEur.text = priceEur + "€"
    }
}
