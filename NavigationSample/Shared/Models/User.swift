//
//  User.swift
//  NavigationSample
//

import Foundation

/// マッチングアプリのユーザモデル
struct User: Identifiable, Hashable {
    let id: UUID
    let name: String
    let age: Int
    let bio: String
    let imageURL: String
    let photos: [Photo]

    init(
        id: UUID = UUID(),
        name: String,
        age: Int,
        bio: String,
        imageURL: String,
        photos: [Photo] = []
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.imageURL = imageURL
        self.photos = photos
    }
}

// MARK: - Photo

extension User {
    struct Photo: Identifiable, Hashable {
        let id: UUID
        let imageURL: String
        let caption: String?

        init(id: UUID = UUID(), imageURL: String, caption: String? = nil) {
            self.id = id
            self.imageURL = imageURL
            self.caption = caption
        }
    }
}

// MARK: - 自分のプロフィール（プレビュー用）

extension User {
    static let myself = User(
        name: "自分",
        age: 25,
        bio: "プロフィールのプレビューです",
        imageURL: "person.circle.fill",
        photos: [
            Photo(imageURL: "photo.fill", caption: "プロフィール写真"),
        ]
    )
}

// MARK: - サンプルデータ

extension User {
    static let samples: [User] = [
        User(
            name: "田中 花子",
            age: 26,
            bio: "カフェ巡りと読書が好きです。週末は美術館によく行きます。",
            imageURL: "person.circle.fill",
            photos: [
                Photo(imageURL: "photo.fill", caption: "お気に入りのカフェで"),
                Photo(imageURL: "photo.fill", caption: "美術館にて"),
                Photo(imageURL: "photo.fill", caption: "旅行の思い出"),
            ]
        ),
        User(
            name: "鈴木 太郎",
            age: 28,
            bio: "エンジニアです。休日はハイキングやキャンプを楽しんでいます。",
            imageURL: "person.circle.fill",
            photos: [
                Photo(imageURL: "photo.fill", caption: "山頂からの景色"),
                Photo(imageURL: "photo.fill", caption: "キャンプ場にて"),
            ]
        ),
        User(
            name: "佐藤 美咲",
            age: 24,
            bio: "音楽とダンスが大好き！毎週末はライブに行っています。",
            imageURL: "person.circle.fill",
            photos: [
                Photo(imageURL: "photo.fill", caption: "フェス会場で"),
                Photo(imageURL: "photo.fill", caption: "ダンス練習中"),
                Photo(imageURL: "photo.fill", caption: "お気に入りのアーティストと"),
            ]
        ),
        User(
            name: "高橋 健一",
            age: 30,
            bio: "料理が趣味で、特にイタリアンが得意です。美味しいお店探しも好き。",
            imageURL: "person.circle.fill",
            photos: [
                Photo(imageURL: "photo.fill", caption: "自作パスタ"),
                Photo(imageURL: "photo.fill", caption: "隠れ家レストランにて"),
            ]
        ),
        User(
            name: "伊藤 さくら",
            age: 27,
            bio: "旅行好きで、年に3回は海外旅行に行きます。次はヨーロッパ周遊を計画中。",
            imageURL: "person.circle.fill",
            photos: [
                Photo(imageURL: "photo.fill", caption: "パリにて"),
                Photo(imageURL: "photo.fill", caption: "ビーチリゾート"),
                Photo(imageURL: "photo.fill", caption: "ローマの休日"),
                Photo(imageURL: "photo.fill", caption: "バルセロナ散策"),
            ]
        ),
        User(
            name: "山本 大輔",
            age: 29,
            bio: "スポーツ全般好きです。特にサッカーとテニスをよくやっています。",
            imageURL: "person.circle.fill",
            photos: [
                Photo(imageURL: "photo.fill", caption: "フットサル大会"),
                Photo(imageURL: "photo.fill", caption: "テニスコートにて"),
            ]
        ),
    ]
}
