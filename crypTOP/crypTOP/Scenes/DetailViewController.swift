//
//  DetailViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 30/01/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var market: MarketCoins!

    class func newInstance(market: MarketCoins) -> DetailViewController {
        let detail = DetailViewController()
        detail.market = market
        return detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Detail")
        dump(self.market)
    }


    

}
