
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
  target="_blank">J-STAGE WebAPIについて</a>
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
#> # A tibble: 17 × 25
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
#> # ℹ 21 more variables: `Print ISSN` <chr>, `Online ISSN` <chr>,
#> #   `学協会名(英)` <chr>, `学協会名(日)` <chr>, `学協会URL(英)` <chr>,
#> #   `学協会URL(日)` <chr>, 資料コード <chr>, `資料名(英)` <chr>,
#> #   `資料名(日)` <chr>, 巻 <dbl>, 分冊 <chr>, 号 <dbl>, 開始ページ <dbl>,
#> #   終了ページ <chr>, 発行年 <dbl>, システムコード <chr>, システム名 <chr>,
#> #   サブフィード名 <chr>, サブフィードURL <chr>, サブフィードID <chr>,
#> #   最新公開日 <chr>
```

### 論文検索結果の取得

``` r
d2 <- get_jstage_articles(author = "山中 伸弥")
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
#> # A tibble: 17 × 25
#>    `論文タイトル(英)`             `論文タイトル(日)` `書誌URL(英)` `書誌URL(日)`
#>    <chr>                          <chr>              <chr>         <chr>        
#>  1 ""                             iPS細胞研究の進展  https://www.… https://www.…
#>  2 ""                             iPS細胞研究の進展  https://www.… https://www.…
#>  3 ""                             PNL1 iPS細胞の可…  https://www.… https://www.…
#>  4 ""                             iPS細胞を用いた創… https://www.… https://www.…
#>  5 "1. Possibility of IPS Cells … 1．iPS細胞の可能…  https://www.… https://www.…
#>  6 "1. Possibility of IPS Cells … 1．iPS細胞の可能…  https://www.… https://www.…
#>  7 "New Era of Medicine with iPS… iPS細胞がひらく新… https://www.… https://www.…
#>  8 ""                             iPS細胞で広がる創… https://www.… https://www.…
#>  9 ""                             iPS細胞研究の進展  https://www.… https://www.…
#> 10 ""                             １．iPS 細胞研究…  https://www.… https://www.…
#> 11 ""                             日本で開発された…  https://www.… https://www.…
#> 12 "Establishment of iPS Cell an… 人工多能性幹細胞…  https://www.… https://www.…
#> 13 ""                             多能性幹細胞の標…  https://www.… https://www.…
#> 14 "Surgical treatments for trau… 当院における外傷…  https://www.… https://www.…
#> 15 "Clinical Study of Bipolar Fe… 変形性股関節症に…  https://www.… https://www.…
#> 16 "A Follow-up Study of Unicomp… 術後5年以上経過し… https://www.… https://www.…
#> 17 "Mechanism of post-transcript… 転写産物および蛋…  https://www.… https://www.…
#> # ℹ 21 more variables: `著者名(英)` <chr>, `著者名(日)` <chr>,
#> #   資料コード <chr>, `資料名(英)` <chr>, `資料名(日)` <chr>,
#> #   `Print ISSN` <chr>, `Online ISSN` <chr>, 巻 <dbl>, 分冊 <chr>, 号 <chr>,
#> #   開始ページ <chr>, 終了ページ <chr>, 発行年 <dbl>, JOI <chr>, DOI <chr>,
#> #   システムコード <chr>, システム名 <chr>, サブフィード名 <chr>,
#> #   サブフィードURL <chr>, サブフィードID <chr>, 最新公開日 <chr>
```

一度に取得できるデータは最大1,000件です。
1,000件を超えるデータを取得する場合は，しばらく時間をおいてから，次のように引数
`start` を指定して続きを取得してください。

``` r
d3 <- get_jstage_articles(article = "iPS", start = 1001)
```

### 取得したデータをExcelに保存

``` r
write_jstage_to_excel(d2, "results.xlsx")
```

### 論文のメタデータの取得

``` r
d4 <- jstage_metadata(d2$entry$DOI[8], bibtex_path = "~")
```

<a href="https://www.zotero.org/" target="_blank">Zotero</a>
ユーザーは，J-STAGE の情報を
<a href="https://www.zotero.org/download/connectors"
target="_blank">Zotero Connector</a>
経由で登録する際に，著者名の姓と名が逆になるという問題が発生します。
この問題は BibTeX を経由することで回避できます。

Powered by <a href="https://www.jstage.jst.go.jp/browse/-char/ja"
target="_blank">J-STAGE</a>
