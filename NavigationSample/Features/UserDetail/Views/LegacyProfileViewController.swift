//
//  LegacyProfileViewController.swift
//  NavigationSample
//

import UIKit

/// UIKit で実装されたプロフィール画面（レガシー画面のサンプル）
///
/// SwiftUI から modal で表示され、UIKit 側で自由に push/pop できる。
/// 閉じるときは onDismiss を呼んで SwiftUI 側に通知する。
final class LegacyProfileViewController: UIViewController {
    private let user: User
    private let onDismiss: (() -> Void)?

    init(user: User, onDismiss: (() -> Void)? = nil) {
        self.user = user
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
        setupNavigationBar()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "UIKit で実装された画面"
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center

        let nameLabel = UILabel()
        nameLabel.text = "\(user.name), \(user.age)歳"
        nameLabel.font = .preferredFont(forTextStyle: .title2)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center

        let bioLabel = UILabel()
        bioLabel.text = user.bio
        bioLabel.font = .preferredFont(forTextStyle: .body)
        bioLabel.textColor = .secondaryLabel
        bioLabel.textAlignment = .center
        bioLabel.numberOfLines = 0

        let pushButton = UIButton(type: .system)
        pushButton.setTitle("次の画面へ（UIKit push）", for: .normal)
        pushButton.addTarget(self, action: #selector(pushNextScreen), for: .touchUpInside)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(bioLabel)
        stackView.addArrangedSubview(pushButton)

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupNavigationBar() {
        title = user.name

        if onDismiss != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(closeTapped)
            )
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(actionTapped)
        )
    }

    @objc private func closeTapped() {
        onDismiss?()
    }

    @objc private func actionTapped() {
        let alert = UIAlertController(
            title: "アクション",
            message: "UIKit の UIAlertController です",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "共有", style: .default))
        alert.addAction(UIAlertAction(title: "報告", style: .destructive))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func pushNextScreen() {
        let nextVC = LegacyProfileSecondViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - 2画面目（push 遷移のデモ用）

/// UIKit 側での push 遷移をデモするための2画面目
final class LegacyProfileSecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "2画面目（UIKit）"

        let label = UILabel()
        label.text = "UIKit の push で遷移した画面\n\n戻るボタンで pop できます"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
