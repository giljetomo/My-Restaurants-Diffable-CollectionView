//
//  CollectionViewController.swift
//  My Restaurants
//
//  Created by Gil Jetomo on 2021-02-04.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, FilterCollectionViewCellDelegate {
    //FilterCollectionViewCellDelegate function
    func filterSelected() {
        //first, reset the filtered items
        filteredItems = Restaurant.restaurants
        //then apply the filter
        filteredItems = filteredItems.filter { (restaurant) -> Bool in
            for type in Restaurant.selectedItems where restaurant.type.contains(type) {
                return true
            }
            return false
        }
        Restaurant.selectedItems.count == 0 ? filteredItems = Restaurant.restaurants : nil
        applySnapshot()
    }
    fileprivate func applySnapshot() {
        //a new snapshot needs to be created for the highlight-filter feature to take effect
        snapshot = Snapshot()
        DispatchQueue.main.async {[self] in
            snapshot.appendSections([.filter, .restaurants])
            snapshot.appendItems(filterItems, toSection: .filter)
            snapshot.appendItems(restaurantItems, toSection: .restaurants)
            snapshot.reloadItems(restaurantItems)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    let filters = Type.allCases
    var filterItems: [Item] {
        return filters.map { .filter($0) }
    }
    var filteredItems = Restaurant.restaurants
    var restaurantItems: [Item] {
        return filteredItems.map { .restaurant($0) }
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private var dataSource: DataSource!
    private var snapshot = Snapshot()
    
    lazy var layoutButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(changeLayout))
    private var layout: Layout = .row
    private var isItemMagnified = false
    
    @objc func changeLayout() {
        layout.toggle()
        isItemMagnified = false
        layoutButton.image = UIImage(named: layout.rawValue)
        navigationItem.setRightBarButton(layoutButton, animated: true)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.Theme1.black
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    //normal implementation - for reference
    //    private var restaurantSnapshot: Snapshot {
    //        var snapshot = Snapshot()
    //        snapshot.appendSections([.filter, .restaurants])
    //        snapshot.appendItems(filterItems, toSection: .filter)
    //        snapshot.appendItems(restaurantItems, toSection: .restaurants)
    //        return snapshot
    //    }
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            if case .restaurant(let restaurant) = item {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as! RestaurantCollectionViewCell
                cell.setup(with: restaurant)
                return cell
            }
            if case .filter(let filter) = item {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
                cell.delegate = self
                cell.button.setTitle(filter.rawValue.capitalized, for: .normal)
                //implement this if not setting the button as 'lazy var'; either way makes the button clickable
                //cell.button.addTarget(cell, action: #selector(FilterCollectionViewCell.buttonPressed(_:)), for: .touchUpInside)
                
                //color configuration should also be done here as collectionview 'pops' the cell when it disappears from the view. And so that when it is 'pushed' back to the view, it displays the proper color configuration. isSelected function has been overriden to do this
                guard let text = cell.button.titleLabel?.text,
                      let item = Type(rawValue: text.lowercased()) else { return cell }
                cell.button.isSelected = Restaurant.selectedItems.contains(item) ? true : false
                return cell
            }
            return UICollectionViewCell()
        })
        applySnapshot()
    }
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let spacing: CGFloat = 8
            return sectionIndex == 0 ? self.setupFilterSection(spacing) : self.setupRestaurantSection(spacing)
        }
        return layout
    }
    fileprivate func setupFilterSection(_ spacing: CGFloat) -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(100), //dynamic width configuration
                heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: item.layoutSize.widthDimension, //dynamic width configuration
                heightDimension: .estimated(25)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    fileprivate func setupRestaurantSection(_ spacing: CGFloat) -> NSCollectionLayoutSection {
        var group: NSCollectionLayoutGroup!
        
        switch layout {
        case .grid:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1.0)))
            
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.5)),
                subitem: item,
                count: 2)
            
            group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: 0, trailing: 0)
            group.interItemSpacing = .fixed(spacing)
            
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)))
            
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(9/10)),
                subitem: item,
                count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: 0, trailing: 0)
        }
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return section
    }
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Theme1.orange, NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 30)!]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Restaurants"
        changeLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.Theme1.yellow
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        // Register cell classes
        self.collectionView!.register(RestaurantCollectionViewCell.self, forCellWithReuseIdentifier: RestaurantCollectionViewCell.identifier)
        self.collectionView!.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        createDataSource()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isItemMagnified.toggle()
        if isItemMagnified {
            let layout = UICollectionViewCompositionalLayout {
                (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                let spacing: CGFloat = 8
                if sectionIndex == 0 {
                    return self.setupFilterSection(spacing)
                } else {
                    let bigItem = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalWidth(1.0)))
                    
                    bigItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: spacing, bottom: 0, trailing: spacing)
                    let bigGroup = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(9/10),
                            heightDimension: .fractionalWidth(9/10)),
                        subitem: bigItem,
                        count: 1)
                    
                    let section = NSCollectionLayoutSection(group: bigGroup)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
                    section.orthogonalScrollingBehavior = .groupPagingCentered
                    return section
                }
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
            
            if indexPath.section == 1 {
                let selected = restaurantItems[indexPath.row]
                let filtered = restaurantItems.filter {$0 != selected}
                snapshot.deleteItems(filtered)
                snapshot.appendItems(filtered, toSection: .restaurants)
                dataSource.apply(snapshot, animatingDifferences: true)
            }
        } else {
            collectionView.setCollectionViewLayout(generateLayout(), animated: true)
            applySnapshot()
        }
    }
}
