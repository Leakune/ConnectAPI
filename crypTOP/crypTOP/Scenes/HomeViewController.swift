//
//  HomeViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 27/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    public var markets: [MarketCoins] = [] //nos marchés favoris dont les données sont stockées dans notre API server
    public var marketsCompare: [MarketCompare] = [] //les marchés dont les données sont stockés dans l'API CryptoCompare
    @IBOutlet var tableCrypto: UITableView! //liste de nos marchés favoris
    @IBOutlet var marketButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableCrypto.dataSource = self
        self.tableCrypto.delegate = self
        self.initMarkets()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("HomeViewController_Title", comment: "")
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    //bouton redirection AllCryptoViewController
    @IBAction func goToMarket(_ sender: Any) {
        let controller = AllCryptoViewController.newInstance(marketsCoins: self.markets)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    //appel des urls request pour récupérer d'abord les données des marchés de notre API server et ensuite de l'API CryptoCompare
    public func initMarkets() -> Void{
        let urlString = "https://api-cryptop.herokuapp.com/MarketsCoins/"
        CrypTopService.URLRequest(urlString: urlString,completion:{ marketCoins in
            DispatchQueue.main.async {
                self.markets = marketCoins
                let fsyms = "BTC,ETH,DOGE,XRP,XLM,LTC,ADA,DOT,LINK,EOS,BCH"
                let tsyms = "USD,EUR"
                let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
                let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
                CryptoCompareService.URLRequest(urlString: urlString,completion:{ marketCompares in
                    DispatchQueue.main.async {
                        self.marketsCompare = marketCompares
                        self.tableCrypto.reloadData()
                    }
                })
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
        let marketsCompare = self.marketsCompare

        let marketCompareFound = findMarketCompareByMarketCoins(marketsCompare: marketsCompare, marketCoins: market)
        updateMarketCoin(marketCompare: marketCompareFound!, marketCoins: market)
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
    //trouver le marché du CryptoCompare qui correspond à notre marché favoris
    func findMarketCompareByMarketCoins(marketsCompare: [MarketCompare], marketCoins: MarketCoins) -> MarketCompare?{
        for marketCompare in marketsCompare {
            if marketCompare.getName() == marketCoins.getName(){
                return marketCompare
            }
        }
        return nil
    }
    //en cliquant sur un marché de la liste des favoris, on va automatiquement update les données du marché de notre API server sélectionné en utilisant les données du marché de l'API CrytoCompare
    func updateMarketCoin(marketCompare: MarketCompare, marketCoins: MarketCoins){
            let market = self.prepareUpdateMarketCoins(marketCompare: marketCompare, marketCoins: marketCoins)

            CrypTopService.update(id: market.id!, market: market){ (success) in
                DispatchQueue.main.sync {
                    if(success) {
                        let controller = DetailViewController.newInstance(market: market)
                        self.navigationController?.pushViewController(controller, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Erreur", message: "request did not worked", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }

    func prepareUpdateMarketCoins(marketCompare: MarketCompare, marketCoins: MarketCoins) -> MarketCoins{
        return MarketCoins(id: marketCoins.id, name: marketCoins.getName(), price_usd: marketCompare.getPrice()["USD"]!, price_eur: marketCompare.getPrice()["EUR"]!, imageURL: marketCompare.imageUrl, comments: marketCoins.comments)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let market = self.markets[sourceIndexPath.row]
        self.markets.remove(at: sourceIndexPath.row)
        self.markets.insert(market, at: destinationIndexPath.row)
    }
}
