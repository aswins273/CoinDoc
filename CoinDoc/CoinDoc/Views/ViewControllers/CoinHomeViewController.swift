//
//  CoinHomeViewController.swift
//  CoinDoc
//
//  Created by Aswin S on 11/11/24.
//

import UIKit

/// ViewController for coin home
class CoinHomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var coinTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var noCoinLabel: UILabel!

    var viewModel = CoinHomeViewModel(searchUrl: APIConstants.searchUrl)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setHandlers()
        setupPullToRefresh()
    }
    
    /// Search button  tap action
    /// - Parameter sender: search button
    @IBAction func searchTapped(_ sender: UIButton) {
        if searchBar.isHidden {
            searchBar.isHidden.toggle()
            searchBar.becomeFirstResponder()
        }
    }
    
    /// Filter button tap action
    /// - Parameter sender: filter button
    @IBAction func filterTapped(_ sender: UIButton) {
        // Instantiate and present the popover view controller
        guard let popoverVC = storyboard?.instantiateViewController(withIdentifier: "FilterPopoverViewController") as? FilterPopoverViewController else { return }
        popoverVC.delegate = self
        popoverVC.selectedOptions = viewModel.selectedOptions
        PresentationManager.presentPopover(
            from: self, popoverVC: popoverVC,
            sourceView: sender,
            preferredContentSize: CGSize(width: 200, height: 225))
    }
    
    /// Ensures popover displays correctly on iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: View Datasource Methods
extension CoinHomeViewController {
    /// Initial setup for populating the view
    func setupView() {
        viewModel.fetchCoins()
        coinTableView.showsVerticalScrollIndicator = false
        coinTableView.accessibilityIdentifier = "coinTableView"
        activityIndicator.accessibilityIdentifier = "loadingIndicator"
        searchBar.accessibilityIdentifier = "searchBar"
    }
    
    /// View model handlers
    func setHandlers() {
        viewModel.tableReloadsHandler = {[weak self] in
            guard let vc = self else {return}
            vc.activityIndicator.stopAnimating()
            vc.refreshControl.endRefreshing()
            vc.coinTableView.reloadData()
            vc.noCoinLabel.isHidden = vc.viewModel.filteredCoins.count == 0 ? false : true
        }
        viewModel.errorHandler = { [weak self] errorMessage in
            guard let vc = self else {return}
            vc.activityIndicator.stopAnimating()
            vc.refreshControl.endRefreshing()
            vc.showAlert(message: errorMessage)
        }
    }
    
    /// Alert on api call error
    /// - Parameter message: error message to be shown
    func showAlert(message: String) {
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.viewModel.fetchCoins()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        PresentationManager.presentAlert(from: self,
                                         title: "Alert",
                                         message: message,
                                         actions: [retryAction, cancelAction])
    }
    
    /// Adding pull to refresh option
    func setupPullToRefresh() {
        refreshControl.accessibilityIdentifier = "pullToRefresh"
        refreshControl.tintColor = .white  // Set the spinner color to white
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Latest Data ...",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.addTarget(self, action: #selector(refreshCoinsData(_:)), for: .valueChanged)
        coinTableView.refreshControl = refreshControl
    }
    
    /// Pull to refresh action
    /// - Parameter sender: sender description
    @objc private func refreshCoinsData(_ sender: Any) {
        viewModel.refreshCoinsData()
    }
}

// MARK: Tableview Datasource Methods
extension CoinHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = coinTableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as? CoinTableViewCell
        let coin = viewModel.filteredCoins[indexPath.row]
        cell?.configure(coinData: coin)
        return cell!
    }
}

// MARK: SearchBar Delegate Methods
extension CoinHomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchAndFilter(withText: searchText, withOption: nil)
    }
    
    /// Searchbar cancel button action
    /// - Parameter searchBar: searchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchAndFilter(withText: "", withOption: nil)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.isHidden.toggle()
    }
    
    /// Return button click action
    /// - Parameter searchBar: searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: FilterOptions Delegate Methods
extension CoinHomeViewController: FilterOptionsDelegate {
    /// Filter option selection delegate callback
    /// - Parameter option: filter option selected
    func didSelectFilterOption(_ option: FilterOption) {
        viewModel.searchAndFilter(withText: searchBar.text ?? "", withOption: option)
    }
}
