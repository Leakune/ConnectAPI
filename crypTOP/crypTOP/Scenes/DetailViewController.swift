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
    
    class func newInstance(market: MarketCoins) -> DetailViewController {
        let detail = DetailViewController()
        detail.market = market
        return detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Detail")
        dump(self.market)
        
        self.icon.downloaded(from: self.market.getImage())
        self.name.text = self.market.getName()
        self.priceEur.text = "$" + String(self.market.getPrice()["EUR"]!)
        self.priceUsd.text = String(self.market.getPrice()["USD"]!) + "€"
    }


    @IBAction func onDelete(_ sender: UIButton) {
        //delegate?.didSelectTag(tags: self.market.getName())
        self.navigationController?.popViewController(animated: true)
    }
    

}
