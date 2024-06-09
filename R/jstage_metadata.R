#' Scrape J-STAGE Article Metadata
#'
#' @description
#' Scrapes all available metadata from a J-STAGE article.
#'
#' @param url
#'   The URL of the J-STAGE article.
#' @param bibtex_file_name
#'   The file name to save the BibTeX entry. If empty, no file is saved.
#' @return A list containing the article metadata.
#' @export
jstage_metadata <- function(url, bibtex_file_name = "") {

  tryCatch({
    response <- httr::GET(url)
    response_url <- response$url
    page <- rvest::read_html(response)

    journal_title <- page |>
      rvest::html_node("meta[name='journal_title']") |>
      rvest::html_attr("content")
    journal_abbrev <- page |>
      rvest::html_node("meta[name='journal_abbrev']") |>
      rvest::html_attr("content")
    publisher <- page |>
      rvest::html_node("meta[name='publisher']") |>
      rvest::html_attr("content")
    authors <- page |>
      rvest::html_nodes("meta[name='authors']") |>
      rvest::html_attr("content")
    author_list <- lapply(authors, function(author) {
      names <- strsplit(author, " ")[[1]]
      if (grepl("-char/en", response_url)) {
        list(lastName = names[length(names)], firstName = names[1])
      } else {
        list(lastName = names[1], firstName = names[length(names)])
      }
    })
    authors_institutions <- page |>
      rvest::html_nodes("meta[name='authors_institutions']") |>
      rvest::html_attr("content")
    title <- page |>
      rvest::html_node("meta[name='title']") |>
      rvest::html_attr("content")
    publication_date <- page |>
      rvest::html_node("meta[name='publication_date']") |>
      rvest::html_attr("content")
    online_date <- page |>
      rvest::html_node("meta[name='online_date']") |>
      rvest::html_attr("content")
    volume <- page |>
      rvest::html_node("meta[name='volume']") |>
      rvest::html_attr("content")
    issue <- page |>
      rvest::html_node("meta[name='issue']") |>
      rvest::html_attr("content")
    firstpage <- page |>
      rvest::html_node("meta[name='firstpage']") |>
      rvest::html_attr("content")
    lastpage <- page |>
      rvest::html_node("meta[name='lastpage']") |>
      rvest::html_attr("content")
    doi <- page |>
      rvest::html_node("meta[name='doi']") |>
      rvest::html_attr("content")
    fulltext_world_readable <- page |>
      rvest::html_node("meta[name='fulltext_world_readable']") |>
      rvest::html_attr("content")
    pdf_url <- page |>
      rvest::html_node("meta[name='pdf_url']") |>
      rvest::html_attr("content")
    print_issn <- page |>
      rvest::html_node("meta[name='print_issn']") |>
      rvest::html_attr("content")
    online_issn <- page |>
      rvest::html_node("meta[name='online_issn']") |>
      rvest::html_attr("content")
    issn_l <- page |>
      rvest::html_node("meta[name='issn_l']") |>
      rvest::html_attr("content")
    language <- page |>
      rvest::html_node("meta[name='language']") |>
      rvest::html_attr("content")
    keywords <- page |>
      rvest::html_nodes("meta[name='keywords']") |>
      rvest::html_attr("content")
    abstract <- page |>
      rvest::html_node("meta[name='abstract']") |>
      rvest::html_attr("content")
    references <- page |>
      rvest::html_nodes("meta[name='references']") |>
      rvest::html_attr("content")
    access_control <- page |>
      rvest::html_node("meta[name='access_control']") |>
      rvest::html_attr("content")
    copyright <- page |>
      rvest::html_node("meta[name='copyright']") |>
      rvest::html_attr("content")

    x <- list(
      url = response_url,
      journal_title = journal_title,
      journal_abbrev = journal_abbrev,
      publisher = publisher,
      authors = author_list,
      authors_institutions = authors_institutions,
      title = title,
      publication_date = publication_date,
      online_date = online_date,
      volume = volume,
      issue = issue,
      firstpage = firstpage,
      lastpage = lastpage,
      doi = doi,
      fulltext_world_readable = fulltext_world_readable,
      pdf_url = pdf_url,
      print_issn = print_issn,
      online_issn = online_issn,
      issn_l = issn_l,
      language = language,
      keywords = keywords,
      abstract = abstract,
      references = references,
      access_control = access_control,
      copyright = copyright
    )

    if (bibtex_file_name != "") {
      bibtex_entry <- paste0(
        "@article{",
        gsub(" ", "", tolower(x$authors[[1]]$lastName)), strsplit(x$publication_date, "/")[[1]][1], ",\n",
        "  title   = {", x$title, "},\n",
        "  author  = {", paste(sapply(x$authors, function(author) {
          paste(author$lastName, author$firstName, sep = ", ")
        }), collapse = " and "), "},\n",
        "  journal = {", x$journal_title, "},\n",
        "  volume  = {", x$volume, "},\n",
        "  number  = {", x$issue, "},\n",
        "  pages   = {", x$firstpage, "-", x$lastpage, "},\n",
        "  year    = {", strsplit(x$publication_date, "/")[[1]][1], "},\n",
        "  month   = {", strsplit(x$publication_date, "/")[[1]][2], "},\n",
        "  publisher = {", x$publisher, "},\n",
        "  doi     = {", x$doi, "},\n",
        "  url     = {", response_url, "},\n",
        "  abstract = {", x$abstract, "}\n",
        "}"
      )
      cat(bibtex_entry, file = bibtex_file_name)
    }

    return(x)

  }, error = function(e) {

    x <- list(
      url = response_url,
      journal_title = NA,
      journal_abbrev = NA,
      publisher = NA,
      authors = NA,
      authors_institutions = NA,
      title = NA,
      publication_date = NA,
      volume = NA,
      issue = NA,
      firstpage = NA,
      lastpage = NA,
      doi = NA,
      fulltext_world_readable = NA,
      pdf_url = NA,
      print_issn = NA,
      online_issn = NA,
      issn_l = NA,
      language = NA,
      keywords = NA,
      abstract = NA,
      references = NA,
      access_control = NA,
      copyright = NA
    )

    return(x)

  })
}
