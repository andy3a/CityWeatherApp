//
//  SearchViewController.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 6.04.22.
//

import UIKit
import MapKit
import RxSwift
// import Combine

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchViewModel(viewController: self)
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    func setUp() {
        setUpSearch()
        setUpTableView()
        setUpTableViewFooter()
        loadDataFromUserDefaults()
    }
    
    
    
//    func setUpCombine() {
//        Publishers.Zip(Networking.shared.currentWeatherSubject, Networking.shared.forecastWeatherSubject)
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                print("something2")
//            } receiveValue: { current, forecast in
//                guard let current = current,
//                      let forecast = forecast else {return}
//                self.navigateToDetails(currentWeather: current, forecastWeather: forecast)
//            }
//            .store(in: &cancellable)
//
//        Networking.shared.passErrorSubject
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                print(completion)
//            } receiveValue: { error in
//                self.showAlert(error: error)
//            }
//            .store(in: &cancellable)
//    }
    
    func setUpSearch() {
        viewModel.searchCompleter.delegate = self
        searchBar?.delegate = self
        
        if #available(iOS 13.0, *) {
            viewModel.searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        resultsTableView.addGestureRecognizer(tapRecognizer)
    }
    
    func setUpTableView() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        self.resultsTableView.register(
            UINib(nibName: "ResultTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ResultTableViewCell"
        )
    }
    
    func setUpTableViewFooter() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        let button = UIButton(type: .system)
        button.setTitle("Clear results", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size.height = customView.frame.height / 2
        button.frame.size.width = view.frame.width / 2
        button.layer.cornerRadius = button.frame.height / 2
        button.center = customView.center
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(clearResultsPressed), for: .touchUpInside)
        customView.addSubview(button)
        resultsTableView.tableFooterView = customView
        resultsTableView.tableFooterView?.isHidden = true
        
    }
    
    func loadDataFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "data") as? Data {
            if let decodedData = try? decoder.decode([SavedSearchResult].self, from: savedData) {
                viewModel.savedSearchResults = decodedData
            }
        }
    }
                    
    func navigateToDetails(currentWeather: CurrentWeather, forecastWeather: ForecastWeather, backgroundImage: UIImage) {
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailsViewController.title = viewModel.selectedCell?.textLabel?.text
        detailsViewController.viewModel.currentWeather = currentWeather
        detailsViewController.viewModel.dailyWeatherArray = forecastWeather.daily ?? []
        detailsViewController.viewModel.hourlyWeatherArray = forecastWeather.hourly ?? []
        detailsViewController.viewModel.providedBackgroundImage = backgroundImage
        setRowToDefault()
        
        if self.viewModel.searchResults.isEmpty {
            self.resultsTableView.reloadData()
        }
        navigationController?.pushViewController(detailsViewController, animated: true)
        resultsTableView.reloadData()
    }
    
    func setRowToDefault() {
        resultsTableView.visibleCells.forEach { cell in
            guard let cell = cell as? ResultTableViewCell else {return}
            cell.spinner.stopAnimating()
            cell.shevron.isHidden = false
        }
    }
    
    func showAlert(error: Error) {
        let alert = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.setRowToDefault()
            }
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func clearResultsPressed() {
        viewModel.savedSearchResults = []
        resultsTableView.reloadData()
        resultsTableView.tableFooterView?.isHidden = true
    }
    @objc func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResults.isEmpty ? viewModel.savedSearchResults.count : viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.searchResults.isEmpty {
            if !viewModel.savedSearchResults.isEmpty {
                tableView.tableFooterView?.isHidden = false
            }
            let searchResult = viewModel.savedSearchResults[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ResultTableViewCell",
                for: indexPath
            ) as? ResultTableViewCell else {
                return UITableViewCell()
            }
            cell.textLabel?.text = searchResult.title
            cell.savedLabel.isHidden = false
            return cell
        } else {
            tableView.tableFooterView?.isHidden = true
            let searchResult = viewModel.searchResults[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ResultTableViewCell",
                for: indexPath
            ) as? ResultTableViewCell else {
                return UITableViewCell()
            }
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            cell.savedLabel.isHidden = true
            viewModel.savedSearchResults.forEach { savedResult in
                guard savedResult.title == searchResult.title else {return}
                cell.savedLabel.isHidden = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.searchResults.isEmpty {
            let cell = tableView.cellForRow(at: indexPath) as? ResultTableViewCell
            tableView.visibleCells.forEach { cell in
                guard let cell = cell as? ResultTableViewCell else {return}
                cell.spinner.stopAnimating()
            }
            cell?.spinner.startAnimating()
            cell?.shevron.isHidden = true
            self.viewModel.selectedCell = cell
            viewModel.requestData(lat: "\(viewModel.savedSearchResults[indexPath.row].lat)", lon: "\(viewModel.savedSearchResults[indexPath.row].lon)")
            let element = self.viewModel.savedSearchResults[indexPath.row]
            self.viewModel.savedSearchResults.remove(at: indexPath.row)
            self.viewModel.savedSearchResults.insert(element, at: 0)
        } else {
            let result = viewModel.searchResults[indexPath.row]
            let searchRequest = MKLocalSearch.Request(completion: result)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                if let error = error {
                    self.showAlert(error: error)
                } else {
                    
                    guard let coordinate = response?.mapItems[0].placemark.coordinate else {return}
                    let lat = coordinate.latitude
                    let lon = coordinate.longitude
                    let cell = tableView.cellForRow(at: indexPath) as? ResultTableViewCell
                    tableView.visibleCells.forEach { cell in
                        guard let cell = cell as? ResultTableViewCell else {return}
                        cell.spinner.stopAnimating()
                    }
                    cell?.spinner.startAnimating()
                    cell?.shevron.isHidden = true
                    self.viewModel.selectedCell = cell
                    self.viewModel.requestData(lat: "\(lat)", lon: "\(lon)")
                    let newSearch = SavedSearchResult(
                        title: self.viewModel.searchResults[indexPath.row].title,
                        lat: lat,
                        lon: lon
                    )
                    self.viewModel.savedSearchResults.insert(newSearch, at: 0)
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.searchResults = []
            self.resultsTableView.reloadData()
        }
        viewModel.searchCompleter.queryFragment = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        viewModel.searchResults = completer.results
        resultsTableView.reloadData()
    }
}
