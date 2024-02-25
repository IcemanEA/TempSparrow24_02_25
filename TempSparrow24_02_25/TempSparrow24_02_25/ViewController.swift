//
//  ViewController.swift
//  TempSparrow24_02_25
//
//  Created by Egor Ledkov on 25.02.2024.
//

import UIKit

final class ViewController: UIViewController {
	
	// MARK: - Private properties
	
	private var collectionView: UICollectionView!
	private var dataSource: UICollectionViewDiffableDataSource<String, String>?
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		createDataSource()
		
		reloadData()
	}
	
	// MARK: - Private Methods
	
	private func setupUI() {
		title = "Collection"
		view.backgroundColor = .systemBackground
		
		// Поведение через нормальный инструмент, для этого предназначенный.. как реально в AppStore
//		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
		
		// поведение, "как просят" в задании.. !!оО --
		let flowLayout = CustomFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: view.frame.width / 1.5, height: view.frame.height / 2)
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
		// --
		
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .systemBackground
		collectionView.showsHorizontalScrollIndicator = false
		view.addSubview(collectionView)
		
		collectionView.register(
			CustomCollectionViewCell.self,
			forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
		)
	}
	
	private func createDataSource() {
		dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			self.configure(CustomCollectionViewCell.self, with: itemIdentifier, for: indexPath)
		}
	}
	
	private func configure<T: IConfiguringCell>(_ cellType: T.Type, with data: String, for indexPath: IndexPath) -> T {
		guard
			let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: cellType.reuseIdentifier,
				for: indexPath
			) as? T
		else {
			fatalError("Can't dequeue \(cellType)")
		}
		
		cell.configure(with: data)
		
		return cell
	}
	
	private func reloadData() {
		var snapshot = NSDiffableDataSourceSnapshot<String, String>()
		
		let section = "Feature"
		snapshot.appendSections([section])
		
		let data = Array(1...10).map { "\($0)" }
		snapshot.appendItems(data, toSection: section)
		
		dataSource?.apply(snapshot)
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: view.layoutMargins.left, bottom: 0, right: 10)
	}
}

// MARK: - CustomFlowLayout

final class CustomFlowLayout: UICollectionViewFlowLayout {

	override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
		guard let collectionView else {
			return super.targetContentOffset(
				forProposedContentOffset: proposedContentOffset,
				withScrollingVelocity: velocity
			)
		}
		
		let pageWidth = itemSize.width + minimumInteritemSpacing
		let approximatePage = collectionView.contentOffset.x / pageWidth
		let currentPage = velocity.x.isZero ? round(approximatePage) : (velocity.x < .zero ? floor(approximatePage) : ceil(approximatePage))
		let flickedPages = (abs(round(velocity.x)) <= 1) ? .zero : round(velocity.x)
		let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left

		return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
	}
}

// MARK: - UICollectionViewCompositionalLayout

private extension ViewController {
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			let section = "Feature"
			
			return self.createFeaturedSection(using: section)
		}
		
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 20
		layout.configuration = config
		
		return layout
	}
	
	func createFeaturedSection(using section: String) -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(1)
		)
		let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
		layoutItem.contentInsets = NSDirectionalEdgeInsets(
			top: 0,
			leading: 5,
			bottom: 0,
			trailing: 5
		)
		
		let layoutGroupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.95),
			heightDimension: .estimated(350)
		)
		let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
		
		let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
		layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
		return layoutSection
	}
}
