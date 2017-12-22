////
////  WrappedImage.swift
////  FindMe
////
////  Created by Алексей on 25.09.17.
////  Copyright © 2017 Medved-Studio. All rights reserved.
////

import Foundation
import IOSLibrary
import UIKit

public class ImageWrapper: ZeroCdnImageWrapper {

    public override func awakeFromNib() {
        super.awakeFromNib()

        super.setup(delegate: self)
    }
}
extension ZeroCdnImageWrapper: ZeroCdnImageWrapperDelegate {

    public var defaultImage: UIImage {
        return ThemeSettings.Images.default
    }
    public var cache: CacheImagesService {
        return CacheServices.images
    }
    public var sizes: [CGFloat: String] {
        return ImageWrapper.sizes
    }
    private static let sizes = [
        CGFloat(50): "t",
        CGFloat(150): "s",
        CGFloat(350): "m"
    ]
}