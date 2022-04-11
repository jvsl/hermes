import UIKit
import SnapKit
import Kingfisher
import Cosmos

// MARK: - Layout Constants

private extension GithubGraphQLCell.Layout {
    enum Size {
        static let avatar: CGFloat = 75
        static let contentView: CGFloat = 90
        static let ownerInfoContainer: CGFloat = 40
        static let ratingContainer: CGFloat = 40
    }
    
    enum Padding {
        static let contentViewTopBottom: CGFloat = 4
        static let contentViewLeadingTrailing: CGFloat = 8
        static let avatar: CGFloat = 8
        static let ownerInfoContainerLeading: CGFloat = 8
        static let ownerInfoContainerTrailing: CGFloat = 4
        static let ratingContainer: CGFloat = 8
    }
}

final class GithubGraphQLCell: UITableViewCell, ReusableView {
    
    // MARK: - Avatar UI
    
    fileprivate enum Layout {}
    private let avatarContainer = UIView()
    private var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        DispatchQueue.main.async {
            imageView.layer.cornerRadius = imageView.frame.height/2
        }
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.yellow.cgColor
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        
        return imageView
    }()
    
    // MARK: - OwnerInfo UI
    

    private lazy var ownerNameLabel = makeLabel(color: .magenta.withAlphaComponent(0.7))
    private var ownerInfoContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 0
        container.distribution = .equalCentering
        
        return container
    }()
    private lazy var repoNameLabel = makeLabel()
    
    // MARK: - Stars/Rating UI
    
    private lazy var starsLabel = makeLabel(aligment: .center)
    private var ratingView = CosmosView()
    private var ratingContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 0
        container.distribution = .fill
        container.alignment = .trailing
        return container
    }()

    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        buildView()
    }
    
    // MARK: Public Methods
    
    func setup(viewModel: GithubRepoCellViewModel) {
        avatarImage.kf.setImage(with: viewModel.avatarURL)
        ownerNameLabel.text = viewModel.owner.login
        starsLabel.text = "(\(viewModel.stargazers.totalCount))"
        repoNameLabel.text = viewModel.name
        ratingView.rating = viewModel.stars
    }
    
    // MARK: Private Methods
    
    private func makeLabel(color: UIColor = .black, aligment: NSTextAlignment = .natural) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont(name: "Verdana-Bold", size: 14)
        label.textAlignment = aligment
        return label
    }
    
    private func resetCellValues() {
        avatarImage.image = nil
        ownerNameLabel.text = ""
        starsLabel.text = ""
        repoNameLabel.text = ""
        ratingView.rating = .zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentViewContainer = UIView()
}

// MARK: - Layout

extension GithubGraphQLCell: ViewCoding {
    func addSubviews() {
        contentView.addSubview(contentViewContainer)
       
        contentViewContainer.addSubview(avatarContainer)
        contentViewContainer.addSubview(ownerInfoContainer)
        contentViewContainer.addSubview(ratingContainer)
        
        ownerInfoContainer.addArrangedSubview(ownerNameLabel)
        ownerInfoContainer.addArrangedSubview(repoNameLabel)

        ratingContainer.addArrangedSubview(ratingView)
        ratingContainer.addArrangedSubview(starsLabel)
        
        avatarContainer.addSubview(avatarImage)
    }
    
    func addConstraints() {
        contentViewContainer.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.contentView)
            $0.top.bottom.equalToSuperview().inset(Layout.Padding.contentViewTopBottom)
            $0.trailing.leading.equalToSuperview().inset(Layout.Padding.contentViewLeadingTrailing)
        }
        avatarContainer.snp.makeConstraints {
            $0.width.height.equalTo(Layout.Size.avatar)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Layout.Padding.avatar)
        }
        
        avatarImage.snp.makeConstraints {
            $0.width.height.equalTo(Layout.Size.avatar)
            $0.centerY.equalToSuperview()
        }
        
        ownerInfoContainer.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.ownerInfoContainer)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(avatarContainer.snp.trailing).offset(Layout.Padding.ownerInfoContainerLeading)
            $0.trailing.equalTo(ratingContainer.snp.leading).inset(Layout.Padding.contentViewLeadingTrailing)
        }
        
        ratingContainer.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.ratingContainer)
            $0.trailing.equalTo(-Layout.Padding.ratingContainer)
            $0.centerY.equalToSuperview()
        }
    }
    
    func additionalConfig() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentViewContainer.backgroundColor = .white
        contentViewContainer.layer.cornerRadius = 8
    }
}
