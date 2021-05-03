import UIKit

class CartViewController: UIViewController {

    @IBOutlet var payButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var paymentMethod: PaymentMethod?
    
    let paymentService = PaymentService()

    @IBAction func payButtonTapped(_ sender: UIButton) {
        if let paymentMethod = self.paymentMethod {
            performPayment(paymentMethod: paymentMethod)
        } else {
            self.performSegue(withIdentifier: "showPaymentMethods", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CartItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartItemCell")
        updatePayButton(paymentMethod: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func updatePayButton(paymentMethod: PaymentMethod?) {
        
        if paymentMethod != nil {
            var totalPayment = 0.00

            ShoppingCart.shared.domains.forEach {
                let priceDouble = Double($0.price.replacingOccurrences(of: "$", with: ""))!
                totalPayment += priceDouble
            }

            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency

            payButton.setTitle("Pay \(currencyFormatter.string(from: NSNumber(value: totalPayment))!) Now", for: .normal)
        } else {
            payButton.setTitle("Select a Payment Method", for: .normal)

        }
    
    }
    
    

    func performPayment(paymentMethod: PaymentMethod) {
        payButton.isEnabled = false
        
        paymentService.tryPurchase(request: getRequest(paymentMethod: paymentMethod), paymentMethod: paymentMethod) { [weak self] (error) in
            guard let self = self else {return}
            
            if let error = error {
                let controller = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self.payButton.isEnabled = true
                }

                controller.addAction(action)

                DispatchQueue.main.async { 
                    self.present(controller, animated: true)
                }
            } else {
                ShoppingCart.shared.domains.removeAll()
                let controller = UIAlertController(title: "All done!", message: "Your purchase is complete!", preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }

                controller.addAction(action)

                DispatchQueue.main.async {
                    self.present(controller, animated: true)
                }
            }
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentMethodsViewController
        vc.delegate = self
    }
}

//MARK: Logic for purchasing request
extension CartViewController {

    func getRequest(paymentMethod: PaymentMethod) -> URLRequest {
        let dict: [String: String] = [
            "auth": AuthManager.shared.token!,
            "token": paymentMethod.token
        ]
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/payments/process")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        
        return request
    }
}

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCart.shared.domains.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell
        cell.delegate = self
        let item = ShoppingCart.shared.domains[indexPath.row]
        cell.setupCell(name: item.name, price: item.price)

        return cell
    }
}

extension CartViewController: CartItemTableViewCellDelegate {
    func didRemoveFromCart() {
        updatePayButton(paymentMethod: self.paymentMethod)
        tableView.reloadData()
    }
}

extension CartViewController: PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod(paymentMethod: PaymentMethod) {
        self.paymentMethod = paymentMethod
        updatePayButton(paymentMethod: paymentMethod)
    }
}
