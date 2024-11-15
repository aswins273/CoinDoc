//
//  FilterTableViewCell.swift
//  CoinDoc
//
//  Created by Aswin S on 14/11/24.
//

import UIKit

/// TableViewCell  for filter view
class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterText: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Configure cell with filter option and selection image visibility
    /// - Parameters:
    ///   - text: Filter option
    ///   - isSelected: Filter option selection
    func configure(text: String, isSelected: Bool) {
        filterText.text = text
        selectionImage.isHidden = !isSelected
    }
    
    /// To toggle selection image visibility on selection toggle
    func toggleSelectionImageVisibility() {
        selectionImage.isHidden.toggle()
    }
}
