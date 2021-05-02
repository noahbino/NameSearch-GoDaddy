import UIKit

protocol PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod(paymentMethod: PaymentMethod)
}

class PaymentMethodsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var delegate: PaymentMethodsViewControllerDelegate?
    var paymentMethods: [PaymentMethod]?

    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentMethods()
    }
    
    private var request: URLRequest {
        let request = URLRequest(url: URL(string: "https://gd.proxied.io/user/payment-methods")!)

        return request
    }
    
    func getPaymentMethods(){
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }

            self.paymentMethods = try!
                JSONDecoder().decode([PaymentMethod].self, from: data!)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    
}

extension PaymentMethodsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        let method = paymentMethods![indexPath.row]

        cell.textLabel!.text = method.name

        if let lastFour = method.lastFour {
            cell.detailTextLabel!.text = "Ending in \(lastFour)"
        } else {
            cell.detailTextLabel!.text = method.displayFormattedEmail!
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let method = paymentMethods![indexPath.row]
        dismiss(animated: true) {
            self.delegate?.didSelectPaymentMethod(paymentMethod: method)
        }
    }
}
