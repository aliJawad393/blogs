
import Foundation
import UIKit
import SafariServices

final class SignUpViewController: UIViewController {
    
    //MARK: Vars
    private let builder: CredentialsBuilder
    private let signUpBlock: (UserCredentials)->()
    //MARK: View componentt
    private lazy var stackViewContent: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = self.view.bounds.size.height*0.0258
        view.alignment = .leading
        
        let labelSignUp = UILabel()
        labelSignUp.translatesAutoresizingMaskIntoConstraints = false
        labelSignUp.text = "Sign Up"
        labelSignUp.font = UIFont.montserratExtraBold.withAdjustableSize(29)
        labelSignUp.textColor = .white
        
        view.addArrangedSubview(labelSignUp)
        view.addArrangedSubview(textFieldName)
        view.addArrangedSubview(textFieldEmail)
        view.addArrangedSubview(textFieldPassword)
        view.addArrangedSubview(textFieldConfirmPassword)
        view.addArrangedSubview(stackViewTermsAndConditions)
        view.addArrangedSubview(stackViewSignUp)
        
        return view
    }()
    
    private lazy var buttonSignUp: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.71, green: 0.408, blue: 0.231, alpha: 1)
        view.setTitle("Sign Up", for: .normal)
        view.titleLabel?.font = UIFont.montserratSemiBold.withAdjustableSize(17)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(submitHandler(sender:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackViewSignUp: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        
        let buttonHelp = UIButton(type: .system)
        buttonHelp.translatesAutoresizingMaskIntoConstraints = false
        buttonHelp.setTitle("Need Help?", for: .normal)
        buttonHelp.setTitleColor(UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1), for: .normal)
        buttonHelp.titleLabel?.font = UIFont.montserratRegular.withAdjustableSize(14)
        buttonHelp.addTarget(self, action: #selector(helpHandler(sender:)), for: .touchUpInside)
        buttonHelp.contentHorizontalAlignment = .trailing
        
        view.addArrangedSubview(buttonSignUp)
        view.addArrangedSubview(buttonHelp)
        return view
    }()
    
    private lazy var textFieldName: UITextField = {
        let view = CustomTextField()
        view.autocapitalizationType = .words
        view.autocorrectionType = .no
        view.setPlaceholder(text: "Name")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textFieldEmail: UITextField = {
        let view = CustomTextField()
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.setPlaceholder(text: "Email Address")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textFieldPassword: UITextField = {
        let view = CustomTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setPlaceholder(text: "Password")
        view.isSecureTextEntry = true
        return view
    }()
    
    private lazy var textFieldConfirmPassword: UITextField = {
        let view = CustomTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setPlaceholder(text: "Confirm Password")
        view.isSecureTextEntry = true
        return view
    }()
    
    private lazy var stackViewSignIn: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 5
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account?"
        label.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        label.font = UIFont.montserratRegular.withAdjustableSize(14)
        
        let buttonSignIn = UIButton(type: .system)
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        buttonSignIn.setTitle("Sign In", for: .normal)
        buttonSignIn.titleLabel?.font = UIFont.montserratRegular.withAdjustableSize(14)
        buttonSignIn.addTarget(self, action: #selector(signInHandler(sender:)), for: .touchUpInside)
        buttonSignIn.setTitleColor(UIColor(red: 0 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        view.addArrangedSubview(label)
        view.addArrangedSubview(buttonSignIn)
        return view
    }()
        
    private lazy var stackViewTermsAndConditions: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        
        let buttonTnC = UIButton(type: .system)
        buttonTnC.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.montserratRegular.withAdjustableSize(9),
            .foregroundColor: UIColor(red: 0 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1),
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedTitle = NSMutableAttributedString(string: " Terms and Conditions*",
                                                        attributes: attributes)
        buttonTnC.setAttributedTitle(attributedTitle, for: .normal)
        buttonTnC.addTarget(self, action: #selector(termsHandler(sender:)), for: .touchUpInside)
        
        view.addArrangedSubview(termsConditionsCheckBox)
        view.addArrangedSubview(buttonTnC)
        return view
    }()
    
    private lazy var termsConditionsCheckBox: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.init(named: "iconCheckboxOutlined"), for: .normal)
        view.setImage(UIImage.init(named: "iconCheckboxFilled"), for: .selected)
        view.addTarget(self, action: #selector(toggleCheckboxSelection), for: .touchUpInside)
        view.setTitle("  I agree to the ", for: .normal)
        view.setTitleColor(UIColor(red: 0.329, green: 0.329, blue: 0.329, alpha: 1), for: .normal)
        view.titleLabel?.font = UIFont.montserratRegular.withAdjustableSize(9)
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .gray
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    //MARK: Init
    init(builder: CredentialsBuilder, signUpBlock: @escaping(UserCredentials)->()) {
        self.builder = builder
        self.signUpBlock = signUpBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonSignUp.layoutIfNeeded()
        buttonSignUp.layer.cornerRadius = buttonSignUp.bounds.size.height / 2
        buttonSignUp.clipsToBounds = true
    }
    
    //MARK: Action
    @objc func submitHandler(sender: UIButton) {
        do {
            let credentials = try builder.build()
            signUpBlock(credentials)
        } catch CredentialsError.validationFailed(let error) {
            alert("Error", message: error)
        } catch let error {
            alert("Error", message: error.localizedDescription)
        }
    }
    
    @objc func helpHandler(sender: UIButton) {
        
    }
    
    @objc func signInHandler(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toggleCheckboxSelection() {
        termsConditionsCheckBox.isSelected = !termsConditionsCheckBox.isSelected
    }
    
    @objc func termsHandler(sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/terms.php"){
            present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
    
    //MARK: Helpers
    
    @objc func keyboardWillShow(sender: NSNotification) {
        UIView.animate(withDuration: 0.1) {[weak self] in
            guard let stackView = self?.stackViewContent, let view = self?.view else {return}
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.65, constant: 0),
            ])
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.1) {[weak self] in
            guard let stackView = self?.stackViewContent, let view = self?.view else {return}
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.8, constant: 0),
            ])
            view.layoutIfNeeded()
        }
    }
}

//MARK: Helper

private extension SignUpViewController {
    private func displayLoadingIndicator(_ loading: Bool) {
        view.isUserInteractionEnabled = !loading
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

//MARK: Setup View

private extension SignUpViewController {
    private func setupView() {
        view.backgroundColor = UIColor(red: 0.063, green: 0.063, blue: 0.063, alpha: 1)
        view.addSubview(stackViewContent)
        view.addSubview(stackViewSignIn)
        view.addSubview(loadingIndicator)
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            stackViewContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewContent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackViewContent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            NSLayoutConstraint(item: stackViewContent, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.8, constant: 0),
            
            stackViewSignUp.leadingAnchor.constraint(equalTo: stackViewContent.leadingAnchor),
            stackViewSignUp.trailingAnchor.constraint(equalTo: stackViewContent.trailingAnchor),
            
            buttonSignUp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.049),
            buttonSignUp.widthAnchor.constraint(equalTo: buttonSignUp.heightAnchor, multiplier: 2.775),
            
            stackViewSignIn.leadingAnchor.constraint(equalTo: stackViewContent.leadingAnchor),
            stackViewSignIn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        for textField in [textFieldEmail, textFieldPassword, textFieldName, textFieldConfirmPassword] {
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: stackViewContent.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: stackViewContent.trailingAnchor),
                textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.0418),
            ])
        }
    }
}

enum CredentialsError: Equatable, Error {
    case validationFailed(String)
}

public struct UserCredentials {
    let name: String
    let email: String
    let password: String
}

protocol CredentialsBuilder {
    mutating func setName(name: String)
    mutating func setEmail(email: String) throws
    mutating func setPassword(password: String) throws
    mutating func setConfirmPassword(password: String) throws
    mutating func setTicked(isTicked: Bool)
    func build() throws -> UserCredentials
}

struct UserCrendentialsBuilder: CredentialsBuilder {
    private var name: String = ""
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    private var isTicked: Bool = false
    
    mutating func setName(name: String) {
        self.name = name
    }
    
    mutating func setEmail(email: String) throws {
        if email.isValidEmail() {
            self.email = email
        } else {
            throw CredentialsError.validationFailed("Invalid email")
        }
    }
    
    mutating func setPassword(password: String) throws {
        if password.count > 6 {
            self.password = password
        } else {
            throw CredentialsError.validationFailed("Password length shorter than required")
        }
    }
    
    mutating func setConfirmPassword(password: String) throws {
        if password.count > 0 && password == self.password {
            self.confirmPassword = password
        } else {
            throw CredentialsError.validationFailed("Passwords mismatch")
        }
    }
    
    mutating func setTicked(isTicked: Bool) {
        self.isTicked = isTicked
    }
    
    func build() throws -> UserCredentials{
        guard  email.count > 0 else {
            throw CredentialsError.validationFailed("Email is mandatory")
        }
        
        guard password.count > 0 else {
            throw CredentialsError.validationFailed("Password is missing")
        }
        
        guard confirmPassword.count > 0 else {
            throw CredentialsError.validationFailed("Confirm password")
        }
        
        return UserCredentials(name: name, email: email, password: password)
    }
}
