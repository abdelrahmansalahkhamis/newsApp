//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by abdrahman on 24/05/2021.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        subTitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subTitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let subTitleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemRed
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLbl)
        contentView.addSubview(subTitleLbl)
        contentView.addSubview(newsImageView)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        print("contentView.frame.size.height: \(contentView.frame.size.height)")
        newsTitleLbl.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 70, height: 70)
        subTitleLbl.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 70, height: contentView.frame.size.height / 2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 60, y: 5, width: 160, height: 140)
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsTitleLbl.text = viewModel.title
        subTitleLbl.text = viewModel.subtitle
        if let data = viewModel.imageData{
            newsImageView.image = UIImage(data: data)
        }else if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) { [weak self](data, _, error) in
                guard let data = data, error == nil else {return}
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
