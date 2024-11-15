//
//  FilterPopoverViewController.swift
//  CoinDoc
//
//  Created by Aswin S on 13/11/24.
//

import UIKit

/// Filter options
enum FilterOption: String, CaseIterable {
    case activeCoins = "Active Coins"
    case inactiveCoins = "Inactive Coins"
    case onlyTokens = "Only Tokens"
    case onlyCoins = "Only Coins"
    case newCoins = "New Coins"
}

/// Filter option selection callback
protocol FilterOptionsDelegate: AnyObject {
    func didSelectFilterOption(_ option: FilterOption)
}

/// Filter popover view controller
class FilterPopoverViewController: UIViewController {
    weak var delegate: FilterOptionsDelegate?
    @IBOutlet weak var filterTableView: UITableView!
    var selectedOptions: Set<FilterOption> = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Tableview Datasource Methods
extension FilterPopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterOption.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionCell", for: indexPath) as! FilterTableViewCell
        let option = FilterOption.allCases[indexPath.row]
        cell.configure(text: option.rawValue, isSelected: selectedOptions.contains(option))
        return cell
    }
}

// MARK: Tableview Delegate Method
extension FilterPopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = FilterOption.allCases[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        cell.toggleSelectionImageVisibility()
        delegate?.didSelectFilterOption(selectedOption)
    }
}
