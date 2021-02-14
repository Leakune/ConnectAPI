//
//  HomeViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 27/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    public var markets: [MarketCoins] = []
    var marketToDelete: String?
    @IBOutlet var tableCrypto: UITableView!
    
//    @IBOutlet var btc: UIImageView!
//    @IBOutlet var eth: UIImageView!
//    @IBOutlet var doge: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        //appel unique de la fonction iniMarkets
        self.tableCrypto.dataSource = self
        self.tableCrypto.delegate = self
        self.initMarkets()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        //self.addTapGestureRecognizer()
        
        self.title = "Home"
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
    }
    
    @objc func handleAddProduct() {
        let controller = AllCryptoViewController.newInstance(marketsCoins: self.markets)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //Appeler qu'une seule fois la fonction pour initialiser des markets
    public func initMarkets() -> Void{
        let urlString = "https://api-cryptop.herokuapp.com/MarketsCoins/"
        CrypTopService.URLRequest(urlString: urlString,completion:{ marketCoins in
            DispatchQueue.main.async {
                self.markets = marketCoins
                print("InitMarket")
                dump(self.markets)
                self.tableCrypto.reloadData()
//                let fsyms = "BTC,ETH,DOGE,XRP,XLM,LTC,ADA,DOT,LINK,EOS,BCH"
//                let tsyms = "USD,EUR"
//                let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
//                let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
//                CryptoCompareService.URLRequest(urlString: urlString,completion:{ marketCompares in
//                    DispatchQueue.main.async {
//                        self.marketsCompare = marketCompares
//                        print("CryptoCompare")
//                        self.tableAllCryptos.reloadData()
//                    }
//                })
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.handleAddProduct))
             }
        })
    }
    

    

}



extension HomeViewController: UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "market_identifier") else {
            return UITableViewCell(style: .default, reuseIdentifier: "market_identifier")
        }
        return cell
    }
    func configLabel(cell: UITableViewCell, market: MarketCoins) -> Void{
        cell.textLabel?.text = market.getName()
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
        var color = UIColor.clear
        color = UIColor.white
        cell.textLabel?.textColor = color
    }
    func configImage(cell: UITableViewCell, market: MarketCoins) -> Void{
        if let data = NSData(contentsOf: market.imageUrl!)
        {
            cell.imageView?.image = UIImage(data: data as Data)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let market = self.markets[indexPath.row] // recuperer le café à la bonne ligne
//        let marketCoins = findMarketCoinsByMarketCompare(marketCompare: marketCompare, marketsCoins: marketsCoins)
//        goToUpdateMarketCoinsInFavoris(marketCompare: marketCompare, marketCoins: marketCoins!)
        let controller = DetailViewController.newInstance(market: market)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let market = self.markets[indexPath.row]
        guard let id = market.id else {
            return
        }
        CrypTopService.delete(id: id) { (success) in
            if success {
                DispatchQueue.main.sync {
                    self.markets.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
//    func prepareUpdateMarketCoins(marketCompare: MarketCompare, marketCoins: MarketCoins) -> MarketCoins{
//        return MarketCoins(id: marketCoins.id, name: marketCoins.getName(), price_usd: marketCompare.getPrice()["USD"]!, price_eur: marketCompare.getPrice()["EUR"]!, imageURL: marketCompare.imageUrl, comments: marketCoins.comments)
//    }
//    func findMarketCoinsByMarketCompare(marketCompare: MarketCompare, marketsCoins: [MarketCoins]) -> MarketCoins?{
//        for marketCoins in marketsCoins {
//            if marketCompare.getName() == marketCoins.getName(){
//                return marketCoins
//            }
//        }
//        return nil
//    }
//    func goToUpdateMarketCoinsInFavoris(marketCompare: MarketCompare, marketCoins: MarketCoins){
//        let alert = UIAlertController(title: "Update market", message: "Do you want to update data of the market \(marketCompare.getName()) ?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//            print("updating market \(marketCompare.getName()) ...")
//            let market = self.prepareUpdateMarketCoins(marketCompare: marketCompare, marketCoins: marketCoins)
//            dump(market)
//
//            CrypTopService.update(id: market.id!, market: market){ (success) in
//                DispatchQueue.main.sync {
//                    if(success) {
//                        let alert = UIAlertController(title: "Success", message: "Market \(marketCoins.getName()) is updated!", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    } else {
//                        let alert = UIAlertController(title: "Erreur", message: "request did not worked", preferredStyle: .alert)
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let market = self.markets[sourceIndexPath.row]
//        self.markets.remove(at: sourceIndexPath.row)
//        self.markets.insert(market, at: destinationIndexPath.row)
//    }
}

//class CustomUIImageView: UIImageView {
//    var imageValue: String?
//    func customAddGestureRecognizer(tap: UITapGestureRecognizer, imageValue: String){
//        print("here2")
//        self.addGestureRecognizer(tap)
//        self.imageValue = imageValue
//    }
//}
