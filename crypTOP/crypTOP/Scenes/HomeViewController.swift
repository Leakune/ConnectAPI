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
        dump(self.markets)
        //appel unique de la fonction iniMarkets
        self.tableCrypto.dataSource = self
        self.tableCrypto.delegate = self
        _ = initMarkets
        dump(self.markets)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        //self.addTapGestureRecognizer()
        
        self.title = "Home"
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProduct)),
            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditList))
        ]
    }
    
    @objc func handleEditList() {
        self.tableCrypto.isEditing = !self.tableCrypto.isEditing
    }
    
    @objc func handleAddProduct() {
        let controller = AllCryptoViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        var marketToGo: MarketCoins!
//        switch tappedImage.tag {
//        case 0:
//            marketToGo = self.markets![1]
//            break
//        case 1:
//            marketToGo = self.markets![0]
//            break
//        case 2:
//            marketToGo = self.markets![2]
//            break
//        default:
//            return
//        }
//        self.navigationController?.pushViewController(DetailViewController.newInstance(market: marketToGo), animated: true)
//    }
    
    //Appeler qu'une seule fois la fonction pour initialiser des markets
    private lazy var initMarkets: Void = {
//        let fsyms = "BTC,ETH,DOGE"
//        let tsyms = "USD,EUR"
//        let apiKey = "8cf7e8afc81e05ac24dff8fde7c369a53cfb6820fd77245245dffb9762fd9c90"
//        let urlString = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + fsyms + "&tsyms=" + tsyms + "&api_key=" + apiKey
        let urlString = "https://api-cryptop.herokuapp.com/MarketsCoins/"
        CrypTopService.URLRequest(urlString: urlString,completion:{ marketCoins in
            DispatchQueue.main.async {
                self.markets = marketCoins
                print("InitMarket")
                dump(self.markets)
                self.tableCrypto.reloadData() // force à la table de recharger les données
                //self.priceLabel.text = marketCoins[0].getName()
//                print(marketCoins[0].getImage())
//                self.btc.downloaded(from: marketCoins[1].getImage())
//                self.eth.downloaded(from: marketCoins[0].getImage())
//                self.doge.downloaded(from: marketCoins[2].getImage())
            }
        })
    }()
    
//    public func addTapGestureRecognizer(){
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        self.btc.isUserInteractionEnabled = true
//        self.btc.addGestureRecognizer(tapGestureRecognizer)
//        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        self.eth.isUserInteractionEnabled = true
//        self.eth.addGestureRecognizer(tapGestureRecognizer2)
//        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        self.doge.isUserInteractionEnabled = true
//        self.doge.addGestureRecognizer(tapGestureRecognizer3)
//    }
    

}
//extension HomeViewController: SelectTagDelegate {
//    func didSelectTag(tags: String) {
//        marketToDelete = tags
//    }
//}


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
        if let data = NSData(contentsOf: market.getImageUrl())
        {
            cell.imageView?.image = UIImage(data: data as Data)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let market = self.markets[indexPath.row] // recuperer le café à la bonne ligne
        let controller = DetailViewController.newInstance(market: market)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //let market = self.markets[indexPath.row]
//        guard let id = market.id else {
//            return
//        }
//        MarketCoins.delete(id: id) { (success) in
//            if success {
//                DispatchQueue.main.sync {
//                    self.markets.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let market = self.markets[sourceIndexPath.row]
        self.markets.remove(at: sourceIndexPath.row)
        self.markets.insert(market, at: destinationIndexPath.row)
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
