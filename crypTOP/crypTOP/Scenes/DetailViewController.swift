//
//  DetailViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 30/01/2021.
//

import UIKit
//protocol SelectTagDelegate : class {
//    func didSelectTag(tags: String)
//}
class DetailViewController: UIViewController, UINavigationControllerDelegate {
    //weak var delegate: SelectTagDelegate?
    var market: MarketCoins!

    @IBOutlet var delete: UIButton!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var priceEur: UILabel!
    @IBOutlet var priceUsd: UILabel!
    
    static func newInstance(market: MarketCoins) -> DetailViewController {
        let controller = DetailViewController()
        controller.market = market
        return controller
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

        self.priceEur.text = "$" + priceUsd
        self.priceUsd.text = priceEur + "€"
    }


    @IBAction func onDelete(_ sender: UIButton) {
        //delegate?.didSelectTag(tags: self.market.getName())
        self.navigationController?.popViewController(animated: true)
    }
    

}
