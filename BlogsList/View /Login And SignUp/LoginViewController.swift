
import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: Vars
    private let signUpBlock: ()->()
    private let loginBlock: ()->()

    //MARK: View components
    private lazy var stackViewContent: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = self.view.bounds.size.height*0.0455
        view.alignment = .leading
        
        let labelSignIn = UILabel()
        labelSignIn.translatesAutoresizingMaskIntoConstraints = false
        labelSignIn.text = "Sign In"
        labelSignIn.font = UIFont.montserratExtraBold.withAdjustableSize(29)
        labelSignIn.textColor = .white
        
        view.addArrangedSubview(labelSignIn)
        view.addArrangedSubview(textFieldEmail)
        view.addArrangedSubview(textFieldPassword)
        view.addArrangedSubview(stackViewLogin)
        
        return view
    }()
    
    private lazy var buttonLogin: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.71, green: 0.408, blue: 0.231, alpha: 1)
        view.setTitle("Login", for: .normal)
        view.titleLabel?.font = UIFont.montserratSemiBold.withAdjustableSize(17)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(submitHandler(sender:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackViewLogin: UIStackView = {
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
        buttonHelp.contentHorizontalAlignment = .trailing

        view.addArrangedSubview(buttonLogin)
        view.addArrangedSubview(buttonHelp)
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
    
    private lazy var stackViewSignUp: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 5
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        label.textColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        label.font = UIFont.montserratRegular.withAdjustableSize(14)
        
        let buttonSignUp = UIButton(type: .system)
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        buttonSignUp.setTitle("Sign Up", for: .normal)
        buttonSignUp.titleLabel?.font = UIFont.montserratRegular.withAdjustableSize(14)
        buttonSignUp.addTarget(self, action: #selector(signUpHandler(sender:)), for: .touchUpInside)
        buttonSignUp.setTitleColor(UIColor(red: 0 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        view.addArrangedSubview(label)
        view.addArrangedSubview(buttonSignUp)
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.color = .gray
        indicatorView.hidesWhenStopped = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    init(signUpBlock: @escaping()->(), loginBlock: @escaping()->()) {
        self.signUpBlock = signUpBlock
        self.loginBlock = loginBlock
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
        //enableLoginButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonLogin.layoutIfNeeded()
        buttonLogin.layer.cornerRadius = buttonLogin.bounds.size.height / 2
        buttonLogin.clipsToBounds = true
    }
    
    //MARK: Action
    
    @objc func submitHandler(sender: UIButton) {
        loginBlock()
    }

    @objc func signUpHandler(sender: UIButton) {
        signUpBlock()
    }
}

//MARK: Setup View

private extension LoginViewController {
    private func setupView() {
        view.backgroundColor = UIColor(red: 0.063, green: 0.063, blue: 0.063, alpha: 1)
        view.addSubview(stackViewContent)
        view.addSubview(stackViewSignUp)
        view.addSubview(loadingIndicator)
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            
            stackViewContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewContent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackViewContent.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            NSLayoutConstraint(item: stackViewContent, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 0.8, constant: 0),
            
            stackViewLogin.leadingAnchor.constraint(equalTo: stackViewContent.leadingAnchor),
            stackViewLogin.trailingAnchor.constraint(equalTo: stackViewContent.trailingAnchor),
            
            buttonLogin.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.049),
            buttonLogin.widthAnchor.constraint(equalTo: buttonLogin.heightAnchor, multiplier: 2.775),
            
            stackViewSignUp.leadingAnchor.constraint(equalTo: stackViewContent.leadingAnchor),
            stackViewSignUp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        for textField in [textFieldEmail, textFieldPassword] {
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: stackViewContent.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: stackViewContent.trailingAnchor),
                textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.0418),
            ])
        }
    }
}

//MARK: Helper

private extension LoginViewController {
    private func displayLoadingIndicator(_ loading: Bool) {
        view.isUserInteractionEnabled = !loading
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

//MARK: Combine
//
//private extension LoginViewController {
//    private func enableLoginButton() {
//
//        let isPasswordEntered = textFieldPassword.rx.text.orEmpty
//            .map{$0.count > 0}
//            .distinctUntilChanged()
//
//        let isEmailEntered = textFieldEmail.rx.text.orEmpty
//            .map{$0.count > 0}
//            .distinctUntilChanged()
//
//        Observable.combineLatest(isPasswordEntered, isEmailEntered) { $0 && $1 }
//            .bind(to: buttonLogin.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//    }
//}
