import UIKit

protocol CartItemTableViewCellDelegate {
    func didRemoveFromCart()
}

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var removeButton: UIButton!

    @IBAction func removeFromCartButtonTapped(_ sender: UIButton) {
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != nameLabel.text! }

        delegate.didRemoveFromCart()
    }
    
    func setupCell(name: String, price: String){
        self.nameLabel.text = name
        self.priceLabel.text = price
    }

    var delegate: CartItemTableViewCellDelegate!
}
