import UIKit
import SnapKit

private extension FullScreenErrorViewController.Layout {
    enum Size {
        static let tryAgainButton: CGFloat = 50
        static let contentView: CGFloat = 100
    }
    
    enum Padding {
        static let contentView: CGFloat = 16
    }
}

final class FullScreenErrorViewController: UIViewController {
    
    var tryAgainAction: (() -> Void)?
    
    fileprivate enum Layout {}
    private var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Opss...Sorry, some error has occurred. Please, try again"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Verdana-Bold", size: 16)
        return label
    }()
    
    private var tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .magenta.withAlphaComponent(0.7)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Verdana", size: 16)
        button.addTarget(self, action: #selector(didTapTryAgainButton), for: .touchUpInside)
        return button
    }()
    
    private var contentView: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        container.distribution = .fill
        
        return container
    }()
    
    deinit {
        print("FullScreenErrorViewController deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
    }
}

@objc
extension FullScreenErrorViewController {
    func didTapTryAgainButton() {
        dismiss(animated: false, completion: {
            self.tryAgainAction?()
        })
    }
}

extension FullScreenErrorViewController: ViewCoding {
    func addSubviews() {
        view.addSubview(contentView)
        contentView.addArrangedSubview(errorMessageLabel)
        contentView.addArrangedSubview(tryAgainButton)
    }
    
    func addConstraints() {
        tryAgainButton.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.tryAgainButton)
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.contentView)
            $0.centerY.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(Layout.Padding.contentView)
        }
    }
    
    func additionalConfig() {
        view.backgroundColor = .white
    }
}

