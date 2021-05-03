import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    private let initialButtonConstraint:CGFloat = 20
    
    private let authService = AuthService()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private var request: URLRequest {
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/auth/login")!)
        request.httpMethod = "POST"
        
        let dict: [String: String] = [
            "username": usernameTextField.text!,
            "password": passwordTextField.text!
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        
        return request
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        authService.tryLogin(request: request, username: usernameTextField.text!, password: passwordTextField.text!) { [weak self] (error) in
            guard let self = self else {return}
            
            if let error = error {
                self.present(error)
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showDomainSearch", sender: self)
                }
            }
        }
    }
}


//MARK: Notification Extension
extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.loginButtonBottomConstraint.constant == self.initialButtonConstraint {
                self.loginButtonBottomConstraint.constant += keyboardSize.height
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
                    self.view.layoutIfNeeded()
                }, completion: {_ in
                    self.loginButton.isEnabled = true
                })
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.loginButtonBottomConstraint.constant = self.initialButtonConstraint
        }
    }
}

//MARK: UITextFieldDelegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

