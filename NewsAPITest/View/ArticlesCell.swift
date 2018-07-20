//
//  ArticlesCell.swift
//  NewsAPITest
//
//  Created by Martin Grincevschi on 19.07.2018.
//  Copyright © 2018 Martin Grincevschi. All rights reserved.
//

import Foundation
import UIKit


class ArticlesCell: UITableViewCell {
    
    
    let photoImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //label.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        //label.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = false
        
        addSubview(photoImageview)
        addSubview(authorLabel)
        addSubview(titleLabel)
        addSubview(dividerLineView)
        
        photoImageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageview.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageview.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        authorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        authorLabel.topAnchor.constraint(equalTo: photoImageview.bottomAnchor).isActive = true
        
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        dividerLineView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
        
        titleLabel.heightAnchor.constraint(equalToConstant: 69).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        titleLabel.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setArticlesCellWith(photo: Article) {
        
        DispatchQueue.main.async {
            self.authorLabel.text = photo.author
            self.titleLabel.text = photo.title
            if let url = photo.mediaURL {
                self.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
}
