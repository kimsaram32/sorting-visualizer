import UIKit

class HomeViewController: UIViewController {
    
    typealias Cell = HomeCollectionViewCell
    
    private var sortAlgorithms: [SortAlgorithm]?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = .make {
        $0.style = .large
    }
    
    private lazy var collectionView: UICollectionView = .make({
        $0.dataSource = self
        $0.delegate = self
        $0.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
    }) { [unowned self] in
        UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    }
    
    private func errorLabel(message: String) -> UILabel {
        .make {
            $0.text = message
            $0.font = .preferredFont(forTextStyle: .headline)
            $0.textAlignment = .center
        }
    }
    
    override func viewDidLoad() {
        title = "Sort Visualizer"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.isHidden = true
        
        do {
            sortAlgorithms = try SortAlgorithmStore.shared.algorithms()
            loadingIndicator.stopAnimating()
            
            collectionView.isHidden = false
            collectionView.reloadData()
        } catch {
            loadingIndicator.stopAnimating()
            showErrorMessage("Failed to load sort algorithms")
        }
    }
    
    func configureSubviews() {
        view.addSubview(loadingIndicator)
        loadingIndicator.pin(to: view.safeAreaLayoutGuide)
        
        view.addSubview(collectionView)
        collectionView.pin(to: view.safeAreaLayoutGuide)
    }
    
    func showErrorMessage(_ message: String) {
        let label = errorLabel(message: message)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(12)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sortAlgorithms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let sortAlgorithm = sortAlgorithms![indexPath.row]
        cell.title = sortAlgorithm.name
        cell.icon = sortAlgorithm.icon
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sortAlgorithm = sortAlgorithms![indexPath.row]
        let viewController = SortViewController(sortAlgorithm: sortAlgorithm)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
