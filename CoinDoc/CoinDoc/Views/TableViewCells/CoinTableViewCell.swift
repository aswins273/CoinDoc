//
//  CoinTableViewCell.swift
//  CoinDoc
//
//  Created by Aswin S on 12/11/24.
//

import UIKit

/// TableViewCell for coin table
class CoinTableViewCell: UITableViewCell {
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinTypeImage: UIImageView!
    @IBOutlet weak var coinNewImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Configure cell with name and image
    /// - Parameter coinData: CryptoCoin  details
    func configure (coinData: CryptoCoin) {
        coinName.text = coinData.name
        coinSymbol.text = coinData.symbol
        coinNewImage.isHidden = true
        if !coinData.isActive {
            coinTypeImage.image = UIImage(named: "crypto_inactive")
        } else {
            if coinData.type == "coin" {
                coinTypeImage.image = UIImage(named: "crypto_type_coin")
            } else {
                coinTypeImage.image = UIImage(named: "crypto_type_token")
            }
        }
        if coinData.isNew {
            coinNewImage.isHidden = false
        }
    }
}
