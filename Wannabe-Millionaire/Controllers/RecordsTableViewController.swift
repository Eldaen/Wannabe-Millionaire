//
//  RecordsTableViewController.swift
//  Wannabe-Millionaire
//
//  Created by Денис Сизов on 26.01.2022.
//

import UIKit

/// Контроллер для отображения таблицы рекордов
final class RecordsTableViewController: UITableViewController {
	
	/// Кол-во секций
	let sectionsCount = 1
	
	/// ID ячейки
	let cellId = "RecordCell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Game.shared.records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		let record = Game.shared.records[indexPath.row]
		cell.textLabel?.text = "\(record.score)"
		cell.detailTextLabel?.text = record.getDate()
		return cell
    }
}
