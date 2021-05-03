import Foundation
import UIKit

struct Domain {
    let name: String
    let price: String
    let productId: Int
}

class DomainSearchViewController: UIViewController {

    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!
    
    let domainService = DomainService()

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTermsTextField.resignFirstResponder()
        loadData()
    }

    @IBAction func cartButtonTapped(_ sender: UIButton) {

    }

    var data: [Domain]?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCartButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    var request:URLRequest? {
        guard let searchTerms = searchTermsTextField.text else {return nil}
        var urlComponents = URLComponents(string: "https://gd.proxied.io/search/exact")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerms)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        return request
    }
    
    var suggestionsRequest:URLRequest {
        let searchTerms = searchTermsTextField.text!
        var suggestionsComponents = URLComponents(string: "https://gd.proxied.io/search/spins")!
        suggestionsComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerms)
        ]

        var suggestionsRequest = URLRequest(url: suggestionsComponents.url!)
        suggestionsRequest.httpMethod = "GET"
        return suggestionsRequest
    }
    
    func loadData(){
        
        if searchTermsTextField.text == "" {return}
        domainService.loadDomains(request: request!, suggestionRequest: suggestionsRequest) { [weak self] (domains) in
            guard let self = self else {return}
            
            if let domains = domains {
                self.data = domains
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func configureCartButton() {
        cartButton.isEnabled = !ShoppingCart.shared.domains.isEmpty
        cartButton.backgroundColor = cartButton.isEnabled ? .black : .lightGray
    }
}

extension DomainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        cell.textLabel!.text = data![indexPath.row].name
        cell.detailTextLabel!.text = data![indexPath.row].price

        let selected = ShoppingCart.shared.domains.contains(where: { $0.name == data![indexPath.row].name })

        DispatchQueue.main.async {
            cell.setSelected(selected, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DomainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let domain = data![indexPath.row]
        ShoppingCart.shared.domains.append(domain)

        configureCartButton()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = data![indexPath.row]
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != domain.name }

        configureCartButton()
    }
}
