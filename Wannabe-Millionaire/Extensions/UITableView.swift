//
//  UITableView.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 02.02.2022.
//

import UIKit

extension UITableView {

	func scrollToBottom(isAnimated:Bool = true){

		DispatchQueue.main.async {
			let indexPath = IndexPath(
				row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
				section: self.numberOfSections - 1)
			if self.hasRowAtIndexPath(indexPath: indexPath) {
				self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
			}
		}
	}

	func scrollToTop(isAnimated:Bool = true) {

		DispatchQueue.main.async {
			let indexPath = IndexPath(row: 0, section: 0)
			if self.hasRowAtIndexPath(indexPath: indexPath) {
				self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
		   }
		}
	}

	func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
		return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
	}
}
