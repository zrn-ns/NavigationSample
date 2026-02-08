//
//  LikeSendViewController.swift
//  NavigationSample
//

import UIKit

/// いいね送信画面（UIKit 実装）
///
/// SwiftUI の UserDetail Feature から modal で表示される UIKit 画面（パターン A）。
/// UINavigationController でのラップは不要（単画面のため）。
final class LikeSendViewController: UIViewController {
    private let user: User
    private let onLikeSent: ((LikeType) -> Void)?
    private let onDismiss: (() -> Void)?

    init(user: User, onLikeSent: ((LikeType) -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        self.user = user
        self.onLikeSent = onLikeSent
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // タイトル
        let titleLabel = UILabel()
        titleLabel.text = "\(user.name)さんにいいねを送る"
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textAlignment = .center

        // いいねボタン（1pt）
        let likeButton = UIButton(type: .system)
        likeButton.setTitle("いいね（1pt）", for: .normal)
        likeButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        var likeConfig = UIButton.Configuration.filled()
        likeConfig.title = "いいね（1pt）"
        likeConfig.baseBackgroundColor = .systemPink
        likeConfig.cornerStyle = .large
        likeConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        likeButton.configuration = likeConfig
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)

        // スペシャルいいねボタン（3pt）
        let specialLikeButton = UIButton(type: .system)
        var specialConfig = UIButton.Configuration.filled()
        specialConfig.title = "スペシャルいいね（3pt）"
        specialConfig.baseBackgroundColor = .systemOrange
        specialConfig.cornerStyle = .large
        specialConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        specialLikeButton.configuration = specialConfig
        specialLikeButton.addTarget(self, action: #selector(specialLikeTapped), for: .touchUpInside)

        // キャンセルボタン
        let cancelButton = UIButton(type: .system)
        var cancelConfig = UIButton.Configuration.plain()
        cancelConfig.title = "キャンセル"
        cancelConfig.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        cancelButton.configuration = cancelConfig
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(specialLikeButton)
        stackView.addArrangedSubview(cancelButton)

        // ボタン間にスペースを追加
        stackView.setCustomSpacing(24, after: titleLabel)

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])

        // 設計情報ボタン
        let designInfoButton = DesignInfoButton(
            info: ScreenDesignInfoProvider.likeSend,
            presentingViewController: self
        )
        designInfoButton.addToViewController(self)
    }

    @objc private func likeTapped() {
        onLikeSent?(.normal)
    }

    @objc private func specialLikeTapped() {
        onLikeSent?(.special)
    }

    @objc private func cancelTapped() {
        onDismiss?()
    }
}
