import UIKit

class SortViewController: UIViewController {
    
    let sortAlgorithm: SortAlgorithm
    var targetArray = Array(1...10).shuffled()
    
    private var actions = [SortAction]()
    
    init(sortAlgorithm: SortAlgorithm) {
        self.sortAlgorithm = sortAlgorithm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - state
    
    private var currentActionIndex = 0 {
        didSet {
            guard oldValue != currentActionIndex else { return }
            
            let currentAction = actions[currentActionIndex]
            let oldAction: SortAction? = oldValue > -1 ? actions[oldValue] : nil
            
            if let oldAction {
                itemsView.dehighlight(for: oldAction)
            }
            
            if let oldAction, currentActionIndex < oldValue {
                itemsView.revert(oldAction)
            } else {
                itemsView.perform(currentAction)
            }
            
            itemsView.highlight(for: currentAction)
            
            updateActionLabel()
            updateNavButtons()
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
    
    private var nextActionAvailable: Bool {
        currentActionIndex + 1 < actions.count
    }
    
    private var previousActionAvailable: Bool {
        currentActionIndex > 0
    }
    
    func startPlayTask() {
        Task {
            guard nextActionAvailable else {
                isPlaying = false
                return
            }
            currentActionIndex += 1
            try? await Task.sleep(for: .milliseconds(100))
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
    
    private lazy var itemsView: ItemsView = .make(nil) {
        ItemsView(items: self.targetArray)
    }
    
    private lazy var previousButton: UIButton = .make(nil) {
        UIButton(configuration: .filled(), primaryAction: UIAction(title: "Previous") { [unowned self] _ in
            guard previousActionAvailable else { return }
            currentActionIndex -= 1
        })
    }
    
    private lazy var nextButton: UIButton = .make(nil) {
        UIButton(configuration: .filled(), primaryAction: UIAction(title: "Next") { [unowned self] _ in
            guard nextActionAvailable else { return }
            currentActionIndex += 1
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLayoutStackAxis),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        updateLayoutStackAxis()
        
        actions = sortAlgorithm.builder.build(for: targetArray)
        actions.insert(EmptyAction(), at: 0)
        actions.append(EmptyAction())
        
        updateNavButtons()
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
        let action = actions[currentActionIndex]
        actionLabel.textColor = action.color
        actionLabel.text = "\(action.label)"
        if action.affected.count > 0 {
            actionLabel.text! += "(\(action.affected.map({ String($0) }).joined(separator: ", ")))"
        }
    }
    
    func updateNavButtons() {
        nextButton.isEnabled = !isPlaying && nextActionAvailable
        previousButton.isEnabled = !isPlaying && previousActionAvailable
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
        cell.configure(name: complexity.name, value: complexity.expression)
        return cell
    }
    
}
