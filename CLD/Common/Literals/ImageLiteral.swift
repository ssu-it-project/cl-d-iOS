//
//  ImageLiteral.swift
//  CLD
//
//  Created by 김규철 on 2023/07/19.
//

import UIKit

enum ImageLiteral {
    
    // MARK: - tab bar icon
    
    // static var exIcon: UIImage { .load(name: "tabBarIcon") }
    
    //MARK: - logo icon

}

extension UIImage {
    
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
}
