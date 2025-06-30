import UIKit

class HomeViewController: UIViewController {
    
    typealias Cell = HomeCollectionViewCell
    
    private lazy var collectionView: UICollectionView = .make({
        $0.dataSource = self
        $0.delegate = self
        $0.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
    }) { [unowned self] in
        UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    }
    
    override func viewDidLoad() {
        title = "Sort Visualizer"
        view.backgroundColor = .systemBackground
        
        configureSubviews()
    }
    
    func configureSubviews() {
        view.addSubview(collectionView)
        collectionView.pin(to: view.safeAreaLayoutGuide)
    }
    
}

extension HomeViewController {
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Cell.height)),
            subitems: [item, item]
        )
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(4)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SortAlgorithm.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let sortAlgorithm = SortAlgorithm.items[indexPath.row]
        cell.title = sortAlgorithm.name
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sortAlgorithm = SortAlgorithm.items[indexPath.row]
        let viewController = SortViewController(sortAlgorithm: sortAlgorithm)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
