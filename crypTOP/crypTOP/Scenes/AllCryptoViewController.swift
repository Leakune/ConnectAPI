//
//  AllCryptoViewController.swift
//  crypTOP
//
//  Created by Ludovic FAVIER on 13/02/2021.
//

import UIKit

class AllCryptoViewController: UIViewController {
    public var marketsCompare: [MarketCompare] = []
    public var marketsCoins: [MarketCoins]!
    @IBOutlet var tableAllCryptos: UITableView!
    
    static func newInstance(marketsCoins: [MarketCoins]) -> AllCryptoViewController{
        let controller = AllCryptoViewController()
        controller.marketsCoins = marketsCoins
        return controller
    }
    
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
                self.marketsCompare = marketCompares
                print("CryptoCompare")
                self.tableAllCryptos.reloadData()
            }
        })
    }


}
extension AllCryptoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.marketsCompare.count
    }
    
    // indexPath.row -> n° de ligne
    // indexPath.section -> n° de la section (par def 1 section)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let market = self.marketsCompare[indexPath.row]
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
    func configLabel(cell: UITableViewCell, market: MarketCompare) -> Void{
        cell.textLabel?.text = market.getName()
        cell.textLabel?.font = UIFont(name: "Avenir", size: 20)
        var color = UIColor.clear
        color = UIColor.white
        cell.textLabel?.textColor = color
    }
    func configImage(cell: UITableViewCell, market: MarketCompare) -> Void{
        if let data = NSData(contentsOf: market.imageUrl!)
        {
            cell.imageView?.image = UIImage(data: data as Data)
        }
    }
}

extension AllCryptoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marketCompare = self.marketsCompare[indexPath.row] // recuperer le café à la bonne ligne
        guard let marketsCoins = self.marketsCoins else { return }
        if marketIsAlreadyInFavoris(marketCompare: marketCompare, marketsCoins: marketsCoins){
            //let marketCoins = findMarketCoinsByMarketCompare
            //goToUpdateMarketCoinsInFavoris(marketCompare: marketCompare, marketCoins: marketCoins)
        }else{
            goCreateMarketCoinsInFavoris(marketCompare: marketCompare)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let marketCompare = self.marketsCompare[sourceIndexPath.row]
        self.marketsCompare.remove(at: sourceIndexPath.row)
        self.marketsCompare.insert(marketCompare, at: destinationIndexPath.row)
    }
    
    func marketIsAlreadyInFavoris(marketCompare: MarketCompare, marketsCoins: [MarketCoins]) -> Bool{
        return (self.findMarketCoinsByMarketCompare(marketCompare: marketCompare, marketsCoins: marketsCoins) != nil)
    }
    func findMarketCoinsByMarketCompare(marketCompare: MarketCompare, marketsCoins: [MarketCoins]) -> MarketCoins?{
        for marketCoins in marketsCoins {
            if marketCompare.getName() == marketCoins.getName(){
                return marketCoins
            }
        }
        return nil
    }
    func goToUpdateMarketCoinsInFavoris(marketCompare: MarketCompare, marketCoins: MarketCoins){
        
    }
    func goCreateMarketCoinsInFavoris(marketCompare: MarketCompare){
        let alert = UIAlertController(title: "Add to favoris", message: "Do you want to add the market \(marketCompare.getName()) into your favoris?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            print("adding market \(marketCompare.getName()) ...")
            let marketCoins = self.prepareCreateMarketCoins(marketCompare: marketCompare)
            CrypTopService.create(market: marketCoins){ (success) in
                DispatchQueue.main.sync {
                    if(success) {
                        // alert OK
                        print("success")
                        //self.navigationController?.popViewController(animated: true)
                    } else {
                        let alert = UIAlertController(title: "Erreur", message: "Champs obligatoires", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func prepareCreateMarketCoins(marketCompare: MarketCompare) -> MarketCoins{
        return MarketCoins(id: nil, name: marketCompare.getName(), price_usd: marketCompare.getPrice()["USD"]!, price_eur: marketCompare.getPrice()["EUR"]!, imageURL: marketCompare.imageUrl, comments: [])
    }

}


