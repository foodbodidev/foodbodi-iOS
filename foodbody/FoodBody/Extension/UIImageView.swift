//
//  UIImageView.swift
//  FoodBody
//
//  Created by Vuong Toan Chung on 7/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Kingfisher



extension UIImageView {
    
    
    func setImageWithUrl(url: String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: self.frame.size)
            >> RoundCornerImageProcessor(cornerRadius: 0)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeHoder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}




