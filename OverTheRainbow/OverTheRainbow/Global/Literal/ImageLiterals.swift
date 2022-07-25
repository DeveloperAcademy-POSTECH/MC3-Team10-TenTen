//
//  ImageLiterals.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/19.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - button
    
    static var btnBack: UIImage { .load(systemName: "chevron.backward") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }

        // UITest시 사용한다
        image.accessibilityIdentifier = name
        return image
    }
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image{ _ in draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
