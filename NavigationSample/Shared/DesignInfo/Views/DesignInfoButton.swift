//
//  DesignInfoButton.swift
//  NavigationSample
//

import UIKit
import SwiftUI

/// UIKit 画面用の設計情報表示ボタン
final class DesignInfoButton: UIButton {
    private let info: ScreenDesignInfo
    private weak var presentingViewController: UIViewController?

    init(info: ScreenDesignInfo, presentingViewController: UIViewController) {
        self.info = info
        self.presentingViewController = presentingViewController
        super.init(frame: .zero)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var baseBackgroundColor: UIColor {
        switch info.framework {
        case .swiftUI: .systemOrange
        case .uiKit: .systemBlue
        }
    }

    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.title = info.framework.rawValue
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.baseBackgroundColor = baseBackgroundColor
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 12, weight: .bold)
            return outgoing
        }
        configuration = config

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        guard let presentingViewController else { return }

        let detailView = DesignInfoDetailView(info: info)
        let hostingController = UIHostingController(rootView: NavigationStack {
            detailView
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("閉じる") {
                            presentingViewController.dismiss(animated: true)
                        }
                    }
                }
        })

        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        presentingViewController.present(hostingController, animated: true)
    }

    /// ViewController の view に追加し、AutoLayout を設定する
    func addToViewController(_ viewController: UIViewController) {
        viewController.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
