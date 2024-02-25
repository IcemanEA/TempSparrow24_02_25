//
//  CustomCollectionViewCell.swift
//  TempSparrow24_02_25
//
//  Created by Egor Ledkov on 25.02.2024.
//

import UIKit

protocol IConfiguringCell {
	static var reuseIdentifier: String { get }
	func configure(with text: String)
}

final class CustomCollectionViewCell: UICollectionViewCell, IConfiguringCell {
	static let reuseIdentifier = "FeaturedCell"
	
	private let label = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("No created cell")
	}
	
	func configure(with text: String) {
		label.text = text
	}
	
	private func setupUI() {
		backgroundColor = .systemGray5
		layer.cornerRadius = 10
		layer.cornerCurve = .continuous
		
		label.font = .systemFont(ofSize: 12)
		label.textColor = .white
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: contentView.topAnchor),
			label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
}
