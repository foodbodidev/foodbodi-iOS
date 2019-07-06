//
//  LoadingView.swift
//  FoodBody
//
//  Created by Phuoc on 6/23/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    fileprivate let spinner = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spinner.transform = CGAffineTransform(scaleX: 2.75, y: 2.75);
        spinner.startAnimating()
        addSubview(spinner)
        backgroundColor = UIColor.clear
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        spinner.center = center
    }
}

