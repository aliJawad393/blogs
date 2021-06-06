//
//  ViewController.swift
//  BlogsList
//
//  Created by Ali Jawad on 28/05/2021.
//

import UIKit
import Combine
import DataModel

final class BlogPostsListViewController: UIViewController {
    
    //MARK: Vars
    private let selection: ItemSelection
    private var viewModel: BlogPostsListViewModel
    private var subscriptions = [AnyCancellable]()
    private var dataSource: DataSource!

    //MARK: UIView Components
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
        view.addArrangedSubview(searchBar)
        view.addArrangedSubview(tableView)
        return view
    }()
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchBarStyle = .minimal
        view.searchTextField.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        view.searchTextField.font = UIFont.montserratRegular.withSize(14)
        view.searchTextField.textColor = UIColor(red: 0.067, green: 0.14, blue: 0.239, alpha: 1)
        view.setImage(UIImage(named: "icon-search"), for: .search, state: .normal)
        view.setPositionAdjustment(.init(horizontal: 5, vertical: 0), for: .search)
        view.delegate = self
        return view
    }()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableFooterView = UIView()
        view.register(BlogPostsListTableViewCell.self, forCellReuseIdentifier: "cell")
        view.separatorInset = .zero
        view.delegate = self
        return view
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    //MARK: Init
    init(viewModel: BlogPostsListViewModel, selection:@escaping ItemSelection) {
        self.viewModel = viewModel
        self.selection = selection
        super.init(nibName: nil, bundle: nil)
        searchBar.placeholder = viewModel.searchPlaceholder
    }
    
    private init() {
        fatalError("Can't be initialised without required parameters")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Setup View
    private func setupView() {
        view.addSubview(stackView)
        view.addSubview(loadingIndicator)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension BlogPostsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row > 0 && indexPath.row == viewModel.dataItems.value[indexPath.section].dataItems.count - 1) {
            viewModel.loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection(viewModel.dataItems.value[indexPath.section].dataItems[indexPath.row].id)
    }
}

//MARK: Binding ViewModel
private extension BlogPostsListViewController {
    private func bindViewModel() {

       dataSource = DataSource(tableView: tableView) {[weak self] tableView, indexPath, itemIdentifier in
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? BlogPostsListTableViewCell {
            cell.setData(data: itemIdentifier)
            
            cell.setImage(url: URL(string: itemIdentifier.imageUrl), imageSource: self?.viewModel.imageSource)
        }
         return cell
       }
        
        viewModel.dataItems
            .sink {[weak self] items in
                var snapshot = NSDiffableDataSourceSnapshot<String, PostsListPresenter.DataItem>()
                for item in items {
                    snapshot.appendSections([item.title])
                    snapshot.appendItems(item.dataItems, toSection: item.title)
                }
                DispatchQueue.main.async {
                    self?.dataSource.apply(snapshot)
                }
            }.store(in: &subscriptions)
    }
}

//MARK: View Protocol
extension BlogPostsListViewController {
    override func loadingActivity(loading: Bool) {
        DispatchQueue.main.async {[unowned self] in
            loading ? self.loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            self.tableView.isUserInteractionEnabled = !loading
        }
    }
    
    override func showError(title: String, message: String) {
        DispatchQueue.main.async {[unowned self] in
            self.loadingIndicator.stopAnimating()
        }
        super.showError(title: title, message: message)
    }
}

//MARK: Tableview Datasource
fileprivate class DataSource: UITableViewDiffableDataSource<String, PostsListPresenter.DataItem> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "  \(self.snapshot().sectionIdentifiers[section])"
    }
    
}

//MARK: Searchbar Delegate
extension BlogPostsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText.send(searchText)
    }
}
