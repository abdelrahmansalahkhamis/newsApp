//
//  ViewController.swift
//  NewsApp
//
//  Created by abdrahman on 23/05/2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private var viewModel = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    var searchVC = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        configSearchBar()
        fetchTopStroies()
    }
    
    func configSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }

    func fetchTopStroies(){
        APICaller.instanse.getTopStories { [weak self](result) in
            switch result{
            case .success(let articles):
                self?.articles = articles.articles
                self?.viewModel = articles.articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subTitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                print(error)
            }
        }
    }

}

//self?.viewModel = articles.articles.compactMap({
//        title: $0.title,
//        subtitle: $0.description,
//        imageURL: URL(string: $0.urlToImage ?? "")
//    })

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let  url = URL(string: article.url ?? "")else {
            return
        }
        let vc = SFSafariViewController(url: url)
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else{fatalError()}
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        APICaller.instanse.search(with: text) { [weak self](result) in
            switch result{
            case .success(let articles):
                self?.articles = articles.articles
                self?.viewModel = articles.articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subTitle: $0.description ?? "No Description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.searchVC.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                print(error)
            }
        }
    }
}

