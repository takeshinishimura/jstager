#' Get J-Stage Articles List
#'
#' @description
#' Retrieves a list of articles published on J-STAGE, including detailed
#' information such as publication date and bibliographic metadata.
#'
#' @param pubyearfrom
#'   An integer specifying the starting publication year (in YYYY format).
#' @param pubyearto
#'   An integer specifying the ending publication year (in YYYY format).
#' @param material
#'   A character string specifying the material name (partial match search,
#'   case insensitive).
#' @param article
#'   A character string specifying the article title (partial match search,
#'   case insensitive).
#' @param author
#'   A character string specifying the author name (partial match search, case
#'   insensitive).
#' @param affil
#'   A character string specifying the affiliation (partial match search, case
#'   insensitive).
#' @param keyword
#'   A character string specifying the keyword (partial match search, case
#'   insensitive).
#' @param abst
#'   A character string specifying the abstract (partial match search, case
#'   insensitive).
#' @param text
#'   A character string specifying the full text (partial match search, case
#'   insensitive).
#' @param issn
#'   A character string specifying the ISSN (exact match search in XXXX-XXXX
#'   format).
#' @param cdjournal
#'   A character string specifying the journal code.
#' @param sortflg
#'   An integer specifying the sort flag: 1 for score order, 2 for volume,
#'   issue, and page order (default is 1).
#' @param vol
#'   An integer specifying the volume (exact match).
#' @param no
#'   An integer specifying the issue number (exact match).
#' @param start
#'   An integer specifying the starting index for the search results.
#' @param count
#'   An integer specifying the number of search results to retrieve (up to
#'   1,000).
#' @param lang
#'   A character string specifying the language for column names: "ja" for
#'   Japanese (default is "ja").
#' @return A list containing metadata and entry data frames with the search
#'   results.
#' @export
get_jstage_articles <- function(pubyearfrom = NA,
                                pubyearto = NA,
                                material = "",
                                article = "",
                                author = "",
                                affil = "",
                                keyword = "",
                                abst = "",
                                text = "",
                                issn = "",
                                cdjournal = "",
                                sortflg = NA,
                                vol = NA,
                                no = NA,
                                start = NA,
                                count = NA,
                                lang = "ja") {

  x <- get_jstage(pubyearfrom = pubyearfrom,
                  pubyearto = pubyearto,
                  material = material,
                  article = article,
                  author = author,
                  affil = affil,
                  keyword = keyword,
                  abst = abst,
                  text = text,
                  issn = issn,
                  cdjournal = cdjournal,
                  sortflg = sortflg,
                  vol = vol,
                  no = no,
                  start = start,
                  count = count,
                  service = 3)

  dm <- xml_meta(x)
  de <- xml_entry3(x)

  if (dm$status == "ERR_001") {
    warning("\u691c\u7d22\u7d50\u679c\u306f0\u4ef6\u3067\u3059\u3002")
  }

  if (dm$status == "WARN_002") {
    warning(dm$totalResults, " \u4ef6\u306e\u3046\u3061 ",
            dm$startIndex, " \u4ef6\u76ee\u304b\u3089 ",
            dm$itemsPerPage,
            " \u4ef6\u5206\u306e\u691c\u7d22\u7d50\u679c\u3092\u53d6\u5f97\u3057\u307e\u3057\u305f\u3002")
  }

  if (lang == "ja") {
    names(dm) <- c("\u51e6\u7406\u7d50\u679c\u30b9\u30c6\u30fc\u30bf\u30b9",
                   "\u51e6\u7406\u7d50\u679c\u30e1\u30c3\u30bb\u30fc\u30b8",
                   "\u30d5\u30a3\u30fc\u30c9\u540d",
                   "\u30af\u30a8\u30ea\u306eURL",
                   "\u30af\u30a8\u30ea\u306eURI",
                   "\u30b5\u30fc\u30d3\u30b9\u30b3\u30fc\u30c9",
                   "\u53d6\u5f97\u65e5\u6642",
                   "\u691c\u7d22\u7d50\u679c\u7dcf\u6570",
                   "\u958b\u59cb\u4ef6\u6570",
                   "\u4ef6\u6570")
    names(de) <- c("\u8ad6\u6587\u30bf\u30a4\u30c8\u30eb(\u82f1)",
                   "\u8ad6\u6587\u30bf\u30a4\u30c8\u30eb(\u65e5)",
                   "\u66f8\u8a8cURL(\u82f1)",
                   "\u66f8\u8a8cURL(\u65e5)",
                   "\u8457\u8005\u540d(\u82f1)",
                   "\u8457\u8005\u540d(\u65e5)",
                   "\u8cc7\u6599\u30b3\u30fc\u30c9",
                   "\u8cc7\u6599\u540d(\u82f1)",
                   "\u8cc7\u6599\u540d(\u65e5)",
                   "Print ISSN", "Online ISSN",
                   "\u5dfb", "\u5206\u518a", "\u53f7",
                   "\u958b\u59cb\u30da\u30fc\u30b8",
                   "\u7d42\u4e86\u30da\u30fc\u30b8",
                   "\u767a\u884c\u5e74",
                   "JOI", "DOI",
                   "\u30b7\u30b9\u30c6\u30e0\u30b3\u30fc\u30c9",
                   "\u30b7\u30b9\u30c6\u30e0\u540d",
                   "\u30b5\u30d6\u30d5\u30a3\u30fc\u30c9\u540d",
                   "\u30b5\u30d6\u30d5\u30a3\u30fc\u30c9URL",
                   "\u30b5\u30d6\u30d5\u30a3\u30fc\u30c9ID",
                   "\u6700\u65b0\u516c\u958b\u65e5")
  }

  list(metadata = dm, entry = de)

}

xml_entry3 <- function(x) {

  entries <- xml2::xml_find_all(x = x, xpath = "//d1:entry")
  data_list <- list()

  for (entry in entries) {
    article_title_en <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:article_title/d1:en"))
    article_title_ja <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:article_title/d1:ja"))

    article_link_en <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:article_link/d1:en"))
    article_link_ja <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:article_link/d1:ja"))

    author_en_nodes <- xml2::xml_find_all(x = entry, xpath = "d1:author/d1:en/d1:name")
    author_en <- paste(xml2::xml_text(author_en_nodes), collapse = "\n")

    author_ja_nodes <- xml2::xml_find_all(x = entry, xpath = "d1:author/d1:ja/d1:name")
    author_ja <- paste(xml2::xml_text(author_ja_nodes), collapse = "\n")

    cdjournal <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:cdjournal"))
    material_title_en <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:material_title/d1:en"))
    material_title_ja <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:material_title/d1:ja"))

    issn <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:issn"))
    eIssn <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:eIssn"))
    volume <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:volume"))
    cdvols <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:cdvols"))
    number <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:number"))
    startingPage <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:startingPage"))
    endingPage <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:endingPage"))

    pubyear <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:pubyear"))
    joi <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:joi"))
    doi <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "prism:doi"))

    systemcode <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:systemcode"))
    systemname <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:systemname"))
    title <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:title"))
    link <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:link"))
    id <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:id"))
    updated <- xml2::xml_text(xml2::xml_find_first(x = entry, xpath = "d1:updated"))

    data_list[[length(data_list) + 1]] <- tibble::tibble(
      article_title_en = article_title_en,
      article_title_ja = article_title_ja,
      article_link_en = article_link_en,
      article_link_ja = article_link_ja,
      author_en = author_en,
      author_ja = author_ja,
      cdjournal = cdjournal,
      material_title_en = material_title_en,
      material_title_ja = material_title_ja,
      issn = issn,
      eIssn = eIssn,
      volume = volume,
      cdvols = cdvols,
      number = number,
      startingPage = startingPage,
      endingPage = endingPage,
      pubyear = pubyear,
      joi = joi,
      doi = doi,
      systemcode = systemcode,
      systemname = systemname,
      title = title,
      link = link,
      id = id,
      updated = updated
    )
  }

  de <- dplyr::bind_rows(data_list)
  de <- convert_numeric_columns(de, c("volume", "cdvols", "number", "startingPage", "endingPage", "pubyear"))

  return(de)

}
