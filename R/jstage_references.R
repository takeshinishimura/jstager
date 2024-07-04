#' Scrape J-STAGE References
#'
#' @description
#' Scrapes all available references from a J-STAGE article.
#'
#' @param url
#'   The URL or DOI of the J-STAGE article.
#' @param depth
#'   Integer. The depth to which references should be scraped. Default is 1.
#' @return A data frame with the DOI of each reference.
#' @export
jstage_references <- function(url,
                              depth = 1) {

  current_depth <- 0

  if (!grepl("^https?://", url)) {
    url <- paste0("https://doi.org/", url)
  }
  urls_to_process <- c(url)

  result <- tibble::tibble(citing_doi = character(),
                           cited_doi = character(),
                           article_link = character(),
                           depth = integer())

  while (current_depth < depth && length(urls_to_process) > 0) {

    current_depth <- current_depth + 1

    for (i in urls_to_process) {

      cat(sprintf("\u968e\u5c64 %d \u306e %d \u4ef6\u4e2d %d \u4ef6\u76ee\u3092\u51e6\u7406\u4e2d...\r",
                  current_depth, length(urls_to_process), match(i, urls_to_process)))

      session <- setup_chromote_session(i)
      if (is.null(session)) {
        next
      }

      if (!is.null(session) && inherits(session, "ChromoteSession")) {
        page_content <- get_page_content(session)
        session$close()
      } else {
        page_content <- NULL
      }
      if (is.null(page_content)) {
        next
      }

      urls <- get_urls_from_jstage(page_content)

      if (!is.na(urls$url[1])) {
        doi_list <- lapply(urls$url, get_doi_from_url)
        dois <- do.call(rbind, doi_list)
      } else {
        next
      }

      result <- rbind(result, tibble::tibble(citing_doi = urls$doi,
                                             cited_doi = dois$cited_doi,
                                             article_link = dois$article_link,
                                             depth = current_depth))
    }

    next_urls <- result |>
      dplyr::filter(.data$depth == current_depth) |>
      dplyr::select(.data$article_link, .data$cited_doi) |>
      dplyr::filter(!.data$cited_doi %in% result$citing_doi) |>
      dplyr::pull(.data$article_link) |>
      unique() |>
      stats::na.omit()

    urls_to_process <- next_urls

  }

  return(result)

}

get_urls_from_jstage <- function(page_content) {

  page <- rvest::read_html(page_content)

  jalc_urls <- page |>
    rvest::html_element("#article-overview-references-list") |>
    rvest::html_elements("a") |>
    rvest::html_attr("href")

  jalc_urls <- grep("https://jlc.jst.go.jp/DN/JLC/|https://jlc.jst.go.jp/DN/JALC/", jalc_urls, value = TRUE)

  if (length(jalc_urls) == 0) {
    jalc_urls <- NA
  }

  doi <- page |>
    rvest::html_node("meta[name='doi']") |>
    rvest::html_attr("content")

  return(data.frame(doi = doi, url = jalc_urls))

}

setup_chromote_session <- function(url, timeout = 10000, quiet = TRUE) {
  tryCatch({
    if (!quiet) cat("Starting Chromote session...\n")

    b <- chromote::ChromoteSession$new()

    if (!quiet) cat("Navigating to URL...\n")

    b$Page$navigate(url)
    b$Page$loadEventFired(timeout = timeout)

    if (!quiet) cat("Page loaded successfully.\n")

    b$Runtime$evaluate(
      expression = 'new Promise(resolve => {
        let checkInterval = setInterval(() => {
          if (document.querySelector("#article-overview-references-list")) {
            clearInterval(checkInterval);
            resolve(true);
          }
        }, 100);
      });',
      awaitPromise = TRUE,
      timeout = timeout
    )
    return(b)
  }, error = function(e) {
    if (!is.null(b) && inherits(b, "ChromoteSession")) {
      b$close()
    }
    message("Timeout or error occurred, skipping to next step.")
    return(NULL)
  })
}

get_page_content <- function(session) {
  tryCatch({
    content <- session$Runtime$evaluate("document.documentElement.outerHTML")$result$value
    return(content)
  }, error = function(e) {
    message("Failed to get page content.")
    return(NULL)
  })
}

get_doi_from_url <- function(jalc_url) {

  page <- rvest::read_html(jalc_url)

  doi_links <- page |>
    rvest::html_elements("a[href*='https://doi.org/']") |>
    rvest::html_attr("href")
  dois <- gsub("https://doi.org/", "", doi_links)
  decoded_dois <- utils::URLdecode(dois)

  article_links <- page |>
    rvest::html_elements("a[href*='://www.jstage.jst.go.jp/article']") |>
    rvest::html_attr("href")

  if (length(decoded_dois) == 0) {
    decoded_dois <- NA
  }
  if (length(article_links) == 0) {
    article_links <- NA
  }

  return(data.frame(cited_doi = decoded_dois, article_link = article_links))

}
