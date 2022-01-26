//
//  UIViewOutline.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//
import UIKit

@IBDesignable extension UIView {
	@IBInspectable var borderColor: UIColor? {
		get {
			guard let cgColor = layer.borderColor else {
				return nil
			}
			return UIColor(cgColor: cgColor)
		}
		set { layer.borderColor = newValue?.cgColor }
	}

	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
}
