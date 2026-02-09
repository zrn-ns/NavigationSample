import Foundation

// MARK: - HTML エスケープ

extension String {
    var htmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}

// MARK: - CSS

let css = """
:root {
    --bg: #ffffff;
    --bg-secondary: #f5f6f8;
    --bg-code: #f0f2f5;
    --text: #1a1a2e;
    --text-secondary: #555770;
    --border: #e0e2e8;
    --accent: #3b5998;
    --accent-light: #e8edf5;
    --link: #2563eb;
    --tag-bg: #e8edf5;
    --tag-text: #3b5998;
    --sidebar-bg: #f8f9fb;
    --sidebar-width: 280px;
    --header-height: 56px;
}
@media (prefers-color-scheme: dark) {
    :root {
        --bg: #1a1a2e;
        --bg-secondary: #22223a;
        --bg-code: #2a2a42;
        --text: #e0e0e8;
        --text-secondary: #a0a0b8;
        --border: #3a3a52;
        --accent: #7b9fd4;
        --accent-light: #2a3550;
        --link: #60a5fa;
        --tag-bg: #2a3550;
        --tag-text: #7b9fd4;
        --sidebar-bg: #16162a;
    }
}
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; scroll-padding-top: calc(var(--header-height) + 16px); }
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: var(--bg);
    color: var(--text);
    line-height: 1.7;
}
header {
    position: fixed; top: 0; left: 0; right: 0; z-index: 100;
    height: var(--header-height);
    background: var(--bg);
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center;
    padding: 0 24px;
}
header h1 { font-size: 18px; font-weight: 700; }
.sidebar-toggle {
    display: none; background: none; border: none; cursor: pointer;
    font-size: 24px; color: var(--text); margin-right: 12px;
}
aside {
    position: fixed; top: var(--header-height); left: 0; bottom: 0;
    width: var(--sidebar-width); background: var(--sidebar-bg);
    border-right: 1px solid var(--border);
    overflow-y: auto; padding: 16px 0; z-index: 50;
}
aside nav ul { list-style: none; }
aside nav > ul > li { margin-bottom: 4px; }
aside nav > ul > li > a {
    display: block; padding: 8px 20px; font-weight: 600; font-size: 14px;
    color: var(--text); text-decoration: none;
}
aside nav > ul > li > a:hover { background: var(--accent-light); }
aside nav > ul > li > ul { list-style: none; }
aside nav > ul > li > ul > li > a {
    display: block; padding: 4px 20px 4px 36px; font-size: 13px;
    color: var(--text-secondary); text-decoration: none;
}
aside nav > ul > li > ul > li > a:hover { color: var(--link); }
main {
    margin-left: var(--sidebar-width);
    margin-top: var(--header-height);
    padding: 32px 40px 80px;
    max-width: 960px;
}
h2 {
    font-size: 24px; font-weight: 700; margin-top: 48px; margin-bottom: 16px;
    padding-bottom: 8px; border-bottom: 2px solid var(--accent);
}
h3 { font-size: 18px; font-weight: 600; margin-top: 32px; margin-bottom: 12px; color: var(--accent); }
h4 { font-size: 15px; font-weight: 600; margin-top: 20px; margin-bottom: 8px; }
p { margin-bottom: 12px; }
.card {
    background: var(--bg-secondary); border: 1px solid var(--border);
    border-radius: 8px; padding: 20px; margin-bottom: 20px;
}
.card-header { display: flex; align-items: baseline; gap: 12px; margin-bottom: 8px; }
.card-id { font-weight: 700; color: var(--accent); font-size: 15px; white-space: nowrap; }
.card-title { font-weight: 600; font-size: 16px; }
.card-body { font-size: 14px; color: var(--text-secondary); white-space: pre-line; }
.card-section { margin-top: 12px; }
.card-section-title { font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 4px; }
pre {
    background: var(--bg-code); border: 1px solid var(--border);
    border-radius: 6px; padding: 14px 16px; overflow-x: auto;
    font-size: 13px; line-height: 1.5; margin-bottom: 12px;
}
code { font-family: 'SF Mono', Menlo, Consolas, monospace; font-size: 13px; }
.tag {
    display: inline-block; padding: 2px 10px; border-radius: 12px;
    font-size: 12px; font-weight: 500; background: var(--tag-bg); color: var(--tag-text);
    margin: 2px 4px 2px 0; text-decoration: none;
}
a.tag:hover { background: var(--accent); color: #fff; }
table {
    width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px;
}
th, td { padding: 10px 12px; border: 1px solid var(--border); text-align: left; }
th { background: var(--bg-secondary); font-weight: 600; white-space: nowrap; }
td { vertical-align: top; }
.check { text-align: center; color: var(--accent); font-weight: 700; }
.meta-grid {
    display: grid; grid-template-columns: auto 1fr; gap: 4px 16px;
    font-size: 14px; margin-bottom: 12px;
}
.meta-label { font-weight: 600; color: var(--text-secondary); }
@media (max-width: 768px) {
    aside { transform: translateX(-100%); transition: transform 0.3s; }
    aside.open { transform: translateX(0); }
    .sidebar-toggle { display: block; }
    main { margin-left: 0; padding: 24px 16px 80px; }
}
"""

// MARK: - アンカー ID 生成

func anchorId(for principle: ScreenDesignInfo.Principle) -> String {
    "principle-\(principle.rawValue.prefix(2).lowercased())"
}

func anchorId(for practice: PracticeInfo) -> String {
    "practice-\(practice.id)"
}

func anchorId(for screen: ScreenDesignInfo) -> String {
    "screen-\(screen.id)"
}

// MARK: - HTML パーツ生成

func principleTag(_ p: ScreenDesignInfo.Principle) -> String {
    "<a class=\"tag\" href=\"#\(anchorId(for: p))\">\(p.rawValue.htmlEscaped)</a>"
}

func practiceTag(_ p: PracticeInfo) -> String {
    "<a class=\"tag\" href=\"#\(anchorId(for: p))\">\(p.displayId.htmlEscaped): \(p.title.htmlEscaped)</a>"
}

func screenTag(_ s: ScreenDesignInfo) -> String {
    "<a class=\"tag\" href=\"#\(anchorId(for: s))\">\(s.screenName.htmlEscaped)</a>"
}

func codeBlock(_ code: String, description: String? = nil) -> String {
    var html = ""
    if let desc = description {
        html += "<p style=\"font-size:13px;color:var(--text-secondary);margin-bottom:4px;\">\(desc.htmlEscaped)</p>\n"
    }
    html += "<pre><code>\(code.htmlEscaped)</code></pre>\n"
    return html
}

// MARK: - サイドナビ生成

func buildSidebar() -> String {
    var html = "<aside id=\"sidebar\"><nav><ul>\n"

    // 設計原則
    html += "<li><a href=\"#principles\">設計原則</a><ul>\n"
    for group in PrincipleInfoProvider.groupedByCategory {
        for p in group.principles {
            html += "<li><a href=\"#\(anchorId(for: p.principle))\">\(p.principle.rawValue.htmlEscaped)</a></li>\n"
        }
    }
    html += "</ul></li>\n"

    // 具体的手段
    html += "<li><a href=\"#practices\">具体的手段</a><ul>\n"
    for p in PracticeInfoProvider.all {
        html += "<li><a href=\"#\(anchorId(for: p))\">\(p.displayId.htmlEscaped)</a></li>\n"
    }
    html += "</ul></li>\n"

    // パターン別マトリクス
    html += "<li><a href=\"#matrix\">パターン別マトリクス</a></li>\n"

    // 画面設計情報
    html += "<li><a href=\"#screens\">画面設計情報</a><ul>\n"
    for s in PrincipleInfoProvider.allScreenDesignInfos {
        html += "<li><a href=\"#\(anchorId(for: s))\">\(s.screenName.htmlEscaped)</a></li>\n"
    }
    html += "</ul></li>\n"

    html += "</ul></nav></aside>\n"
    return html
}

// MARK: - 設計原則セクション

func buildPrinciplesSection() -> String {
    var html = "<h2 id=\"principles\">設計原則</h2>\n"

    for group in PrincipleInfoProvider.groupedByCategory {
        html += "<h3>\(group.category.htmlEscaped)</h3>\n"

        for info in group.principles {
            html += "<div class=\"card\" id=\"\(anchorId(for: info.principle))\">\n"
            html += "<div class=\"card-header\">"
            html += "<span class=\"card-id\">\(String(info.principle.rawValue.prefix(2)).htmlEscaped)</span>"
            html += "<span class=\"card-title\">\(info.explanation.htmlEscaped)</span>"
            html += "</div>\n"
            html += "<div class=\"card-body\">\(info.detailedExplanation.htmlEscaped)</div>\n"

            // コード例
            if !info.codeExamples.isEmpty {
                html += "<div class=\"card-section\">"
                html += "<div class=\"card-section-title\">コード例</div>\n"
                for ex in info.codeExamples {
                    html += codeBlock(ex.code, description: ex.description)
                }
                html += "</div>\n"
            }

            // 関連する具体的手段
            let practices = info.relatedPractices
            if !practices.isEmpty {
                html += "<div class=\"card-section\">"
                html += "<div class=\"card-section-title\">関連する具体的手段</div>\n"
                for p in practices { html += practiceTag(p) }
                html += "</div>\n"
            }

            // 画面パターン
            let patterns = info.navigationPatterns
            if !patterns.isEmpty {
                html += "<div class=\"card-section\">"
                html += "<div class=\"card-section-title\">適用される画面パターン</div>\n"
                for pat in patterns {
                    html += "<span class=\"tag\">\(pat.htmlEscaped)</span>"
                }
                html += "</div>\n"
            }

            // 適用画面
            let screens = info.appliedScreens
            if !screens.isEmpty {
                html += "<div class=\"card-section\">"
                html += "<div class=\"card-section-title\">適用画面</div>\n"
                for s in screens { html += screenTag(s) }
                html += "</div>\n"
            }

            html += "</div>\n"
        }
    }
    return html
}

// MARK: - 具体的手段セクション

func buildPracticesSection() -> String {
    var html = "<h2 id=\"practices\">具体的手段</h2>\n"

    for practice in PracticeInfoProvider.all {
        html += "<div class=\"card\" id=\"\(anchorId(for: practice))\">\n"
        html += "<div class=\"card-header\">"
        html += "<span class=\"card-id\">\(practice.displayId.htmlEscaped)</span>"
        html += "<span class=\"card-title\">\(practice.title.htmlEscaped)</span>"
        html += "</div>\n"
        html += "<div class=\"card-body\">\(practice.description.htmlEscaped)</div>\n"

        // コード例
        if !practice.codeExamples.isEmpty {
            html += "<div class=\"card-section\">"
            html += "<div class=\"card-section-title\">コード例</div>\n"
            for ex in practice.codeExamples {
                html += codeBlock(ex.code, description: ex.description)
            }
            html += "</div>\n"
        }

        // 関連する原則
        if !practice.relatedPrinciples.isEmpty {
            html += "<div class=\"card-section\">"
            html += "<div class=\"card-section-title\">関連する設計原則</div>\n"
            for p in practice.relatedPrinciples { html += principleTag(p) }
            html += "</div>\n"
        }

        html += "</div>\n"
    }
    return html
}

// MARK: - パターン別マトリクス

func buildMatrixSection() -> String {
    var html = "<h2 id=\"matrix\">画面パターン別マトリクス</h2>\n"
    html += "<p>各画面パターンに適用される設計原則の一覧です。</p>\n"
    html += "<table><thead><tr><th>パターン</th>"
    for p in ScreenDesignInfo.Principle.allCases {
        html += "<th>\(String(p.rawValue.prefix(2)).htmlEscaped)</th>"
    }
    html += "</tr></thead><tbody>\n"

    for row in PrincipleInfoProvider.navigationPatternMatrix {
        html += "<tr><td>\(row.pattern.htmlEscaped)</td>"
        for p in ScreenDesignInfo.Principle.allCases {
            if row.principles.contains(p) {
                html += "<td class=\"check\">\u{2713}</td>"
            } else {
                html += "<td></td>"
            }
        }
        html += "</tr>\n"
    }

    html += "</tbody></table>\n"
    return html
}

// MARK: - 画面設計情報セクション

func buildScreensSection() -> String {
    var html = "<h2 id=\"screens\">画面設計情報</h2>\n"

    for screen in PrincipleInfoProvider.allScreenDesignInfos {
        html += "<div class=\"card\" id=\"\(anchorId(for: screen))\">\n"
        html += "<div class=\"card-header\">"
        html += "<span class=\"card-title\">\(screen.screenName.htmlEscaped)</span>"
        html += "</div>\n"

        // メタ情報
        html += "<div class=\"meta-grid\">"
        html += "<span class=\"meta-label\">フレームワーク</span><span>\(screen.framework.rawValue.htmlEscaped)</span>"
        html += "<span class=\"meta-label\">レイヤー</span><span>\(screen.layer.rawValue.htmlEscaped)</span>"
        html += "<span class=\"meta-label\">RootView</span><span><code>\(screen.rootViewName.htmlEscaped)</code></span>"
        html += "</div>\n"

        // 説明
        html += "<div class=\"card-body\">\(screen.description.htmlEscaped)</div>\n"

        // パターン
        html += "<div class=\"card-section\">"
        html += "<div class=\"card-section-title\">実装パターン</div>\n"
        for pat in screen.patterns {
            html += "<span class=\"tag\">\(pat.rawValue.htmlEscaped)</span>"
        }
        html += "</div>\n"

        // 適用原則
        html += "<div class=\"card-section\">"
        html += "<div class=\"card-section-title\">適用される設計原則</div>\n"
        for p in screen.appliedPrinciples { html += principleTag(p) }
        html += "</div>\n"

        html += "</div>\n"
    }
    return html
}

// MARK: - HTML 全体の組み立て

func buildHTML() -> String {
    var html = """
    <!DOCTYPE html>
    <html lang="ja">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NavigationSample 設計情報</title>
    <style>
    \(css)
    </style>
    </head>
    <body>
    <header>
    <button class="sidebar-toggle" onclick="document.getElementById('sidebar').classList.toggle('open')">\u{2261}</button>
    <h1>NavigationSample 設計情報</h1>
    </header>

    """

    html += buildSidebar()
    html += "<main>\n"
    html += buildPrinciplesSection()
    html += buildPracticesSection()
    html += buildMatrixSection()
    html += buildScreensSection()
    html += "</main>\n"

    html += """
    <script>
    document.querySelectorAll('#sidebar a').forEach(a => {
        a.addEventListener('click', () => {
            document.getElementById('sidebar').classList.remove('open');
        });
    });
    </script>
    </body>
    </html>
    """

    return html
}

// MARK: - メイン処理

let html = buildHTML()

// 出力先ディレクトリの決定
// Tools/DocGenerator/ から実行されることを想定し、プロジェクトルートの docs/ に出力
let packageDir = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // Sources/
    .deletingLastPathComponent()  // DocGenerator/
let projectRoot = packageDir
    .deletingLastPathComponent()  // Tools/
    .deletingLastPathComponent()  // プロジェクトルート
let docsDir = projectRoot.appendingPathComponent("docs")
let outputFile = docsDir.appendingPathComponent("index.html")

// docs/ ディレクトリを作成
try FileManager.default.createDirectory(at: docsDir, withIntermediateDirectories: true)

// HTML を書き出し
try html.write(to: outputFile, atomically: true, encoding: .utf8)

print("生成完了: \(outputFile.path)")
