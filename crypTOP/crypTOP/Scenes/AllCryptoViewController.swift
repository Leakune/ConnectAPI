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
        self.title = NSLocalizedString("AllCryptoViewController_Title", comment: "")
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        self.tableAllCryptos.dataSource = self
        self.tableAllCryptos.delegate = self
        
        let fsyms = "BTC,ETH,DOGE,XRP,XLM,LTC,ADA,DOT,LINK,EOS,BCH"
        let tsyms = "USD,EUR"
        let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
        CryptoCompareService.URLRequest(urlString: urlString,completion:{ marketCompares in
            DispatchQueue.main.async {
                self.marketsCompare = marketCompares
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
        let marketCompare = self.marketsCompare[indexPath.row]
        guard let marketsCoins = self.marketsCoins else { return }
        if marketIsAlreadyInFavorite(marketCompare: marketCompare, marketsCoins: marketsCoins){
            //si le marché CryptoCompare est déjà dans nos favoris, on ne l'ajoute pas et on met un message d'erreur
            displayErrorMessage(marketCompare: marketCompare)
        }else{ //sinon on l'ajoute dans nos favoris
            goCreateMarketCoinsInFavorite(marketCompare: marketCompare)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let marketCompare = self.marketsCompare[sourceIndexPath.row]
        self.marketsCompare.remove(at: sourceIndexPath.row)
        self.marketsCompare.insert(marketCompare, at: destinationIndexPath.row)
    }
    
    func marketIsAlreadyInFavorite(marketCompare: MarketCompare, marketsCoins: [MarketCoins]) -> Bool{
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
    func displayErrorMessage(marketCompare: MarketCompare){
        let alert = UIAlertController(title: NSLocalizedString("displayErrorMessage_Title", comment: ""), message: "\(NSLocalizedString("displayErrorMessage_Message_1", comment: "")) \(marketCompare.getName()) \(NSLocalizedString("displayErrorMessage_Message_2", comment: ""))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func goCreateMarketCoinsInFavorite(marketCompare: MarketCompare){
        let alert = UIAlertController(title: NSLocalizedString("addToFavorite_Title", comment: ""), message: "\(NSLocalizedString("addToFavorite_Message_1", comment: "")) \(marketCompare.getName()) \(NSLocalizedString("addToFavorite_Message_2", comment: ""))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let marketCoins = self.prepareCreateMarketCoins(marketCompare: marketCompare)
            CrypTopService.create(market: marketCoins){ (success) in
                DispatchQueue.main.sync {
                    if(success) {
                        let alert = UIAlertController(title: NSLocalizedString("success_Title", comment: ""), message: "\(NSLocalizedString("success_Message_1", comment: "")) \(marketCoins.getName()) \(NSLocalizedString("success_Message_2", comment: ""))", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("error_Title", comment: ""), message: NSLocalizedString("error_Message", comment: ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func prepareCreateMarketCoins(marketCompare: MarketCompare) -> MarketCoins{
        return MarketCoins(id: nil, name: marketCompare.getName(), price_usd: marketCompare.getPrice()["USD"]!, price_eur: marketCompare.getPrice()["EUR"]!, imageURL: marketCompare.imageUrl, comments: [])
    }

}


