
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jstager

<!-- badges: start -->

[![R-CMD-check](https://github.com/takeshinishimura/jstager/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/takeshinishimura/jstager/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/jstager)](https://CRAN.R-project.org/package=jstager)
<!-- badges: end -->

J-STAGE
WebAPIを利用して，J-STAGEに公開されている情報を取得するためのRパッケージです。
このパッケージを使用すると，巻号一覧や論文の検索結果を取得し，Excel形式で保存することができます。

## 利用上の注意

このパッケージはJ-STAGE WebAPIの利用規約等をご確認の上ご利用ください。

- <a href="https://www.jstage.jst.go.jp/static/pages/WebAPI/-char/ja"
  target="_blank">J-STAGE WebAPI 利用規約</a>
- <a
  href="https://www.jstage.jst.go.jp/static/pages/JstageServices/TAB3/-char/ja"
  target="_blank">J-STAGE WebAPI について</a>
- <a href="https://www.jstage.jst.go.jp/static/files/ja/manual_api.pdf"
  target="_blank">J-STAGE WebAPI ご利用マニュアル</a>

## インストール方法

jstagerパッケージはCRANからインストールできます。

``` r
install.packages("jstager")
```

開発版はGitHubからインストールできます。

``` r
# install.packages("devtools")
devtools::install_github("takeshinishimura/jstager")
```

## 使用例

### 巻号一覧の取得

``` r
library(jstager)

d1 <- get_jstage_volumes(material = "日本応用動物昆虫学会誌", pubyearfrom = 2020)
d1
#> $metadata
#> # A tibble: 1 × 10
#>   処理結果ステータス 処理結果メッセージ フィード名       クエリのURL クエリのURI
#>   <chr>              <chr>              <chr>            <chr>       <chr>      
#> 1 0                  ""                 Volumes and Iss… ""          https://ap…
#> # ℹ 5 more variables: サービスコード <chr>, 取得日時 <chr>, 検索結果総数 <dbl>,
#> #   開始件数 <dbl>, 件数 <dbl>
#> 
#> $entry
#> # A tibble: 18 × 25
#>    `巻号一覧表示名(英)` `巻号一覧表示名(日)` `目次一覧URL(英)` `目次一覧URL(日)`
#>    <chr>                <chr>                <chr>             <chr>            
#>  1 "Vol. 64 (2020) , N… "Vol. 64 (2020) , N… https://www.jsta… https://www.jsta…
#>  2 "Vol. 64 (2020) , N… "Vol. 64 (2020) , N… https://www.jsta… https://www.jsta…
#>  3 "Vol. 64 (2020) , N… "Vol. 64 (2020) , N… https://www.jsta… https://www.jsta…
#>  4 "Vol. 64 (2020) , N… "Vol. 64 (2020) , N… https://www.jsta… https://www.jsta…
#>  5 "Vol. 65 (2021) , N… "Vol. 65 (2021) , N… https://www.jsta… https://www.jsta…
#>  6 "Vol. 65 (2021) , N… "Vol. 65 (2021) , N… https://www.jsta… https://www.jsta…
#>  7 "Vol. 65 (2021) , N… "Vol. 65 (2021) , N… https://www.jsta… https://www.jsta…
#>  8 "Vol. 65 (2021) , N… "Vol. 65 (2021) , N… https://www.jsta… https://www.jsta…
#>  9 "Vol. 66 (2022) , N… "Vol. 66 (2022) , N… https://www.jsta… https://www.jsta…
#> 10 "Vol. 66 (2022) , N… "Vol. 66 (2022) , N… https://www.jsta… https://www.jsta…
#> 11 "Vol. 66 (2022) , N… "Vol. 66 (2022) , N… https://www.jsta… https://www.jsta…
#> 12 "Vol. 66 (2022) , N… "Vol. 66 (2022) , N… https://www.jsta… https://www.jsta…
#> 13 "Vol. 67 (2023) , N… "Vol. 67 (2023) , N… https://www.jsta… https://www.jsta…
#> 14 "Vol. 67 (2023) , N… "Vol. 67 (2023) , N… https://www.jsta… https://www.jsta…
#> 15 "Vol. 67 (2023) , N… "Vol. 67 (2023) , N… https://www.jsta… https://www.jsta…
#> 16 "Vol. 67 (2023) , N… "Vol. 67 (2023) , N… https://www.jsta… https://www.jsta…
#> 17 "Vol. 68 (2024) , N… "Vol. 68 (2024) , N… https://www.jsta… https://www.jsta…
#> 18 "Vol. 68 (2024) , N… "Vol. 68 (2024) , N… https://www.jsta… https://www.jsta…
#> # ℹ 21 more variables: `Print ISSN` <chr>, `Online ISSN` <chr>,
#> #   `学協会名(英)` <chr>, `学協会名(日)` <chr>, `学協会URL(英)` <chr>,
#> #   `学協会URL(日)` <chr>, 資料コード <chr>, `資料名(英)` <chr>,
#> #   `資料名(日)` <chr>, 巻 <dbl>, 分冊 <dbl>, 号 <dbl>, 開始ページ <dbl>,
#> #   終了ページ <chr>, 発行年 <dbl>, システムコード <chr>, システム名 <chr>,
#> #   サブフィード名 <chr>, サブフィードURL <chr>, サブフィードID <chr>,
#> #   最新公開日 <chr>
```

| 引数          | 内容                                         |
|---------------|----------------------------------------------|
| `pubyearfrom` | 発行年の始まり（西暦4桁）                    |
| `pubyearto`   | 発行年の終わり（西暦4桁）                    |
| `material`    | 資料名（完全一致）                           |
| `issn`        | ISSN（完全一致，XXXX-XXXX形式）              |
| `cdjournal`   | 資料コード                                   |
| `volorder`    | 結果の並び順（1:巻，分冊，号の昇順，2:降順） |
| `lang`        | 表頭を日本語にする（“ja”）か否か             |

### 論文検索結果の取得

``` r
d2 <- get_jstage_articles(text = "象の卵")
d2
#> $metadata
#> # A tibble: 1 × 10
#>   処理結果ステータス 処理結果メッセージ フィード名 クエリのURL クエリのURI      
#>   <chr>              <chr>              <chr>      <chr>       <chr>            
#> 1 0                  ""                 Articles   ""          https://api.jsta…
#> # ℹ 5 more variables: サービスコード <chr>, 取得日時 <chr>, 検索結果総数 <dbl>,
#> #   開始件数 <dbl>, 件数 <dbl>
#> 
#> $entry
#> # A tibble: 14 × 25
#>    `論文タイトル(英)`             `論文タイトル(日)` `書誌URL(英)` `書誌URL(日)`
#>    <chr>                          <chr>              <chr>         <chr>        
#>  1 ""                             1. アトピー性皮膚… https://www.… https://www.…
#>  2 ""                             2. in vivoでの食…  https://www.… https://www.…
#>  3 ""                             「生卵に乗る」 : … https://www.… https://www.…
#>  4 "Clarification of piezo-drive… ピエゾアクチュエ…  https://www.… https://www.…
#>  5 ""                             破壊の材料通有性…  https://www.… https://www.…
#>  6 "Diagnostic significance of 2… 卵白凍結乾燥粉末…  https://www.… https://www.…
#>  7 "SAFETY OF INFLUENZA VACCINAT… 当施設でインフル…  https://www.… https://www.…
#>  8 "Comparative Studies on the F… 3種の食〓性テント… https://www.… https://www.…
#>  9 "Small pools on the sides of … 林道脇の水たまり…  https://www.… https://www.…
#> 10 "STUDIS ON THE METHOD OF JUDG… 蛔虫駆除の臨床的…  https://www.… https://www.…
#> 11 "Experimental Studies on the … 性steroidsの向性…  https://www.… https://www.…
#> 12 "Analysis of 100 Women with I… 随証漢方療法で生…  https://www.… https://www.…
#> 13 ""                             生活・健康         https://www.… https://www.…
#> 14 ""                             第33回日本輪床細…  https://www.… https://www.…
#> # ℹ 21 more variables: `著者名(英)` <chr>, `著者名(日)` <chr>,
#> #   資料コード <chr>, `資料名(英)` <chr>, `資料名(日)` <chr>,
#> #   `Print ISSN` <chr>, `Online ISSN` <chr>, 巻 <chr>, 分冊 <dbl>, 号 <chr>,
#> #   開始ページ <dbl>, 終了ページ <chr>, 発行年 <dbl>, JOI <chr>, DOI <chr>,
#> #   システムコード <chr>, システム名 <chr>, サブフィード名 <chr>,
#> #   サブフィードURL <chr>, サブフィードID <chr>, 最新公開日 <chr>
```

| 引数          | 内容                                                                                         |
|---------------|----------------------------------------------------------------------------------------------|
| `pubyearfrom` | 発行年の始まり（西暦4桁）                                                                    |
| `pubyearto`   | 発行年の終わり（西暦4桁）                                                                    |
| `material`    | 資料名（部分一致）                                                                           |
| `article`     | 論文タイトル（部分一致）                                                                     |
| `author`      | 著者名（部分一致，姓と名の間にスペースを入れる）                                             |
| `affil`       | 著者所属機関（部分一致）                                                                     |
| `keyword`     | キーワード（部分一致）                                                                       |
| `abst`        | 抄録（部分一致）                                                                             |
| `text`        | 全文（部分一致）                                                                             |
| `issn`        | ISSN（完全一致，XXXX-XXXX形式）                                                              |
| `cdjournal`   | 資料コード                                                                                   |
| `sortflg`     | 結果の並び順（1:スコア順，2:巻，分冊，号，開始ページの降順），`material`か`issn`の指定が必要 |
| `vol`         | 巻（完全一致）                                                                               |
| `no`          | 号（完全一致）                                                                               |
| `start`       | 検索結果の中から取得を開始する件数                                                           |
| `count`       | 取得件数の上限（デフォルトは1000）                                                           |
| `sep`         | 複数の著者名の間の区切り文字（デフォルトは改行）                                             |
| `lang`        | 表頭を日本語にする（“ja”）か否か                                                             |

一度に取得できるデータは最大1,000件です。
1,000件を超えるデータを取得する場合は，しばらく時間をおいてから，次のように引数
`start` を指定して続きを取得してください。

``` r
d3 <- get_jstage_articles(article = "iPS", start = 1001)
```

### 取得したデータをExcel形式で保存

``` r
write_jstage_to_excel(d2, "results.xlsx")
```

### 論文のメタデータの取得

``` r
d4 <- jstage_metadata(d2$entry$DOI[8], pdf_path = ".", bibtex_path = ".")
```

<a href="https://www.zotero.org/" target="_blank">Zotero</a>
ユーザーは，J-STAGE の情報を
<a href="https://www.zotero.org/download/connectors"
target="_blank">Zotero Connector</a>
経由で登録する際に，著者名の姓と名が逆になるという問題を経験したことがあるはずです。
この問題は BibTeX を経由することで回避できます。

### 論文の引用文献リストの取得

``` r
d5 <- jstage_references("10.1241/johokanri.49.63", depth = 1)
d5
#> # A tibble: 5 × 4
#>   citing_doi              cited_doi                article_link            depth
#>   <chr>                   <chr>                    <chr>                   <dbl>
#> 1 10.1241/johokanri.49.63 10.1241/johokanri.42.682 http://www.jstage.jst.…     1
#> 2 10.1241/johokanri.49.63 10.1241/johokanri.46.536 http://www.jstage.jst.…     1
#> 3 10.1241/johokanri.49.63 10.1241/johokanri.48.149 http://www.jstage.jst.…     1
#> 4 10.1241/johokanri.49.63 10.1241/johokanri.49.69  http://www.jstage.jst.…     1
#> 5 10.1241/johokanri.49.63 10.18919/jkg.56.4_188    https://www.jstage.jst…     1
```

<a
href="https://connect.posit.cloud/takeshinishimura/content/0190eedf-0cff-2ce8-c1eb-689f1cc0d2c0"
target="_blank">引用文献リストの可視化</a>

リスト取得後に次のコードを実行すると可視化できます。

``` r
library(dplyr)
library(visNetwork)

edges <- d5 |>
  mutate(cited_doi = ifelse(is.na(cited_doi), 
                            paste0("non-DOI ", row_number()), 
                            cited_doi)) |>
  select(from = cited_doi, to = citing_doi)

nodes <- data.frame(id = unique(c(edges$from, edges$to))) |>
  left_join(
    d5 |>
      select(cited_doi, article_link) |>
      na.omit() |>
      distinct(),
    by = c("id" = "cited_doi")
  ) |>
  mutate(
    group = ifelse(!is.na(article_link), "J-Stage", "Outside J-Stage"),
    title = paste0("https://doi.org/", id)
  )
nodes$group[nodes$id == d5$citing_doi[1]] <- "J-Stage"

visNetwork(nodes, edges, width = "100%") |>
  visNodes(shape = "box", shadow = TRUE) |>
  visEdges(arrows = 'to', shadow = TRUE) |>
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) |>
  visLegend() |>
  visEvents(selectNode = "function(nodes) {
    var nodeId = nodes.nodes[0];
    var url = this.body.data.nodes.get(nodeId).title;
    if (url !== 'NA') {
      window.open(url, '_blank');
    }
  }") |>
  visLayout(randomSeed = 100)
```

Powered by <a href="https://www.jstage.jst.go.jp/browse/-char/ja"
target="_blank">J-STAGE</a>
