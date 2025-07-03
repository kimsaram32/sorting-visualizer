import UIKit

class SortViewController: UIViewController {
    
    struct PlaybackSpeed {
        static let slow = Duration.milliseconds(200)
        static let normal = Duration.milliseconds(100)
        static let fast = Duration.milliseconds(50)
    }
    
    private let sizes = [10, 20, 50, 100]
    private let orders: [SortOrder] = [.ascending, .descending]
    
    let sortAlgorithm: SortAlgorithm

    init(sortAlgorithm: SortAlgorithm) {
        self.sortAlgorithm = sortAlgorithm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - state
    
    lazy var target = createTarget(withSize: size, order: order)
    
    func createTarget(withSize size: Int, order: SortOrder) -> SortTarget {
        let target = SortTarget(size: size, order: order)
        
        target.recordDiffHandler = { diff in
            for index in diff.dehighlighted {
                self.itemsView.dehighlight(index)
            }
            
            for index in diff.highlighted {
                self.itemsView.highlight(index, color: target.currentRecord.color)
            }
            
            self.itemsView.change(diff.changed.map { ($0, target.items[$0]) }, animated: true)
            
            self.updateNavButtons()
            self.updateActionLabel()
        }
        
        target.setRecords(with: sortAlgorithm.runner)
        
        return target
    }
    
    private var size = 10
    private var order: SortOrder = .ascending
    
    func updateTargetWithNewSettings() {
        target = createTarget(withSize: size, order: order)
        itemsView.setItems(items: target.items)
        
        target.setRecords(with: ShuffleRunner())
        if !isPlaying {
            isPlaying = true
            startPlayTask()
        }
    }
    
    private var isPlaying = false {
        didSet {
            guard oldValue != isPlaying else { return }
            
            togglePlayButton.setNeedsUpdateConfiguration()
            updateNavButtons()
            if isPlaying {
                startPlayTask()
            }
        }
    }
    
    private var playbackSpeed = PlaybackSpeed.normal
    
    func startPlayTask() {
        Task {
            guard target.nextAvailable else {
                isPlaying = false
                target.setRecords(with: sortAlgorithm.runner) // todo better than this...
                return
            }
            target.gotoNext()
            try? await Task.sleep(for: playbackSpeed)
            if isPlaying {
                startPlayTask()
            }
        }
    }
    
    // MARK: - UI - Elements
    
    private lazy var actionLabel: UILabel = .make {
        $0.text = " "
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    private lazy var itemsView: ItemsView = .make {
        $0.setItems(items: self.target.items)
    }
    
    private lazy var previousButton: UIButton = .make(nil) {
        UIButton(configuration: .filled(), primaryAction: UIAction(title: "Previous") { [unowned self] _ in
            target.gotoPrevious()
        })
    }
    
    private lazy var nextButton: UIButton = .make(nil) {
        UIButton(configuration: .filled(), primaryAction: UIAction(title: "Next") { [unowned self] _ in
            target.gotoNext()
        })
    }
    
    private lazy var togglePlayButton: UIButton = .make({
        var baseConfiguration = UIButton.Configuration.filled()
        baseConfiguration.imagePadding = 8
        
        var stopConfiguration = baseConfiguration
        stopConfiguration.title = "Stop"
        stopConfiguration.image = UIImage(systemName: "stop.fill")
        
        var playConfiguration = baseConfiguration
        playConfiguration.title = "Play"
        playConfiguration.image = UIImage(systemName: "play.fill")
        
        $0.configurationUpdateHandler = { [unowned self] in
            $0.configuration = isPlaying ? stopConfiguration : playConfiguration
        }
    }) {
        UIButton(primaryAction: UIAction { [unowned self] _ in
            isPlaying = !isPlaying
        })
    }
    
    typealias ComplexityCell = ComplexityTableViewCell
    
    private lazy var complexityTableView: UITableView = .make {
        $0.dataSource = self
        $0.register(ComplexityCell.self, forCellReuseIdentifier: ComplexityCell.reuseIdentifier)
        $0.bounces = false
        $0.allowsSelection = false
    }
    
    // MARK: - UI - Layout
    
    private lazy var controlsStackView: UIStackView = .make {
        $0.addArrangedSubview(self.previousButton)
        $0.addArrangedSubview(self.togglePlayButton)
        $0.addArrangedSubview(self.nextButton)
        $0.distribution = .equalSpacing
    }
    
    private lazy var playgroundStackView: UIStackView = .make {
        $0.addArrangedSubview(self.actionLabel)
        $0.addArrangedSubview(self.itemsView)
        $0.addArrangedSubview(self.controlsStackView)
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var layoutStackView: UIStackView = .make {
        $0.addArrangedSubview(self.playgroundStackView)
        $0.addArrangedSubview(self.complexityTableView)
        $0.distribution = .fillEqually
        $0.spacing = 30
    }
    
    // MARK: - UI - methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = sortAlgorithm.name
        
        view.backgroundColor = .systemBackground
        
        configureSubviews()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "chevron.forward.2"),
                menu: createSpeedMenu()
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "chart.bar.fill"),
                menu: createSizeMenu()
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                menu: createOrderMenu()
            ),
        ]
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLayoutStackAxis),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        updateLayoutStackAxis()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        target.setRecords(with: ShuffleRunner())
        isPlaying = true
        startPlayTask()
    }
    
    func createSpeedMenu() -> UIMenu {
        let slowSpeedAction = UIAction(title: "Slow") { _ in
            self.playbackSpeed = PlaybackSpeed.slow
        }
        
        let normalSpeedAction = UIAction(title: "Normal") { _ in
            self.playbackSpeed = PlaybackSpeed.normal
        }
        normalSpeedAction.state = .on
        
        let fastSpeedAction = UIAction(title: "Fast") { _ in
            self.playbackSpeed = PlaybackSpeed.fast
        }
        
        return UIMenu(
            title: "Speed",
            options: .singleSelection,
            children: [slowSpeedAction, normalSpeedAction, fastSpeedAction]
        )
    }
    
    func createSizeMenu() -> UIMenu {
        let sizeActions = sizes.map { size in
            UIAction(title: "\(size) Items") { [unowned self] _ in
                self.size = size
                self.updateTargetWithNewSettings()
            }
        }
        sizeActions.first?.state = .on
        return UIMenu(title: "Size", options: .singleSelection, children: sizeActions)
    }
    
    func createOrderMenu() -> UIMenu {
        let orderActions = orders.map { order in
            UIAction(title: order.label) { [unowned self] _ in
                self.order = order
                self.updateTargetWithNewSettings()
            }
        }
        orderActions.first?.state = .on
        return UIMenu(title: "Order", options: .singleSelection, children: orderActions)
    }
    
    func configureSubviews() {
        view.addSubview(layoutStackView)
        NSLayoutConstraint.activate([
            layoutStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            layoutStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            layoutStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            layoutStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    @objc func updateLayoutStackAxis() {
        let orientation = UIDevice.current.orientation
        
        if orientation.isLandscape {
            layoutStackView.axis = .horizontal
        } else if orientation.isPortrait {
            layoutStackView.axis = .vertical
        }
    }
    
    func updateActionLabel() {
        let record = target.currentRecord
        actionLabel.textColor = record.color
        actionLabel.text = "\(record.label)"
        if record.affectedIndices.count > 0 {
            actionLabel.text! += "(\(record.affectedIndices.map({ String($0) }).joined(separator: ", ")))"
        }
    }
    
    func updateNavButtons() {
        nextButton.isEnabled = !isPlaying && target.nextAvailable
        previousButton.isEnabled = !isPlaying && target.previousAvailable
    }

}

extension SortViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Complexity"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortAlgorithm.complexities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let complexity = sortAlgorithm.complexities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ComplexityCell.reuseIdentifier) as! ComplexityCell
        cell.name = complexity.name
        cell.value = complexity.expression
        return cell
    }
    
}
