//
//  AllCryptoViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 13/02/2021.
//

import UIKit

class AllCryptoViewController: UIViewController {
    public var markets: [MarketCompare] = []
    @IBOutlet var tableAllCryptos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All markets"
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear

       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableAllCryptos.dataSource = self
        self.tableAllCryptos.delegate = self
        
        let fsyms = "BTC,ETH,DOGE,XRP,XLM,LTC,ADA,DOT,LINK,EOS,BCH"
        let tsyms = "USD,EUR"
        let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
        CryptoCompareService.URLRequest(urlString: urlString,completion:{ marketCompares in
            DispatchQueue.main.async {
                self.markets = marketCompares
                print("CryptoCompare")
                dump(self.markets)
                self.tableAllCryptos.reloadData()
            }
        })
    }


}
extension AllCryptoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.markets.count
    }
    
    // indexPath.row -> n° de ligne
    // indexPath.section -> n° de la section (par def 1 section)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let market = self.markets[indexPath.row]
        let cell = self.getMarketCell(tableView: tableView)
        self.configLabel(cell: cell, market: market)
        self.configImage(cell: cell, market: market)
        return cell
    }
    
    func getMarketCell(tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coffee_identifier") else {
            return UITableViewCell(style: .default, reuseIdentifier: "coffee_identifier")
        }
        return cell
    }
    func configLabel(cell: UITableViewCell, market: MarketCompare) -> Void{
        cell.textLabel?.text = market.getName()
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
        var color = UIColor.clear
        color = UIColor.white
        cell.textLabel?.textColor = color
    }
    func configImage(cell: UITableViewCell, market: MarketCompare) -> Void{
        if let data = NSData(contentsOf: market.getImageUrl())
        {
            cell.imageView?.image = UIImage(data: data as Data)
        }
    }
}

extension AllCryptoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let market = self.markets[indexPath.row] // recuperer le café à la bonne ligne
        let alert = UIAlertController(title: "Add to favoris", message: "Do you want to add the market \(market.getName()) into your favoris?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            print("adding market \(market.getName()) ...")
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let market = self.markets[sourceIndexPath.row]
        self.markets.remove(at: sourceIndexPath.row)
        self.markets.insert(market, at: destinationIndexPath.row)
    }
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
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
