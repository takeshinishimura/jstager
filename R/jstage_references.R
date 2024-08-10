#' Scrape J-STAGE References
#'
#' @description
#' Scrapes all available references from a J-STAGE article web page.
#'
#' @param url
#'   The URL or DOI of the J-STAGE article web page.
#' @param depth
#'   Integer. The depth to which references should be scraped. For example, a
#'   depth of 2 means the references of the specified paper and recursively the
#'   references of those references are scraped, and so on.
#' @param citedby
#'   Logical. Set to `TRUE` to retrieve the list of cited-by references instead
#'   of the reference list. When set to `TRUE`, `depth` is automatically set to
#'   1.
#' @param wait
#'   Numeric. The number of seconds to wait between each request to reduce
#'   server load.
#' @param quiet
#'   Logical. Set to `FALSE` to display information about the progress.
#' @return A data frame with the DOI of each reference.
#' @export
jstage_references <- function(url,
                              depth = 1,
                              citedby = FALSE,
                              wait = 1,
                              quiet = TRUE) {

  if (citedby) {depth <- 1}
  current_depth <- 0

  if (!grepl("^https?://", url)) {
    url <- paste0("https://doi.org/", url)
  }
  urls_to_process <- c(url)

  result <- tibble::tibble(citing_doi = character(),
                           citing_article_link = character(),
                           cited_doi = character(),
                           cited_article_link = character(),
                           depth = integer())

  while (current_depth < depth && length(urls_to_process) > 0) {

    current_depth <- current_depth + 1

    for (i in urls_to_process) {

      if (!quiet) {
        cat(sprintf("\u968e\u5c64 %d \u306e %d \u4ef6\u4e2d %d \u4ef6\u76ee\u3092\u51e6\u7406\u4e2d...\r",
                    current_depth, length(urls_to_process), match(i, urls_to_process)))
      }

      session <- setup_chromote_session(i, quiet = quiet)
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

      urls <- get_urls_from_jstage(page_content, citedby = citedby)

      if (!is.na(urls$jalc_urls[1])) {
        doi_list <- lapply(urls$jalc_urls, get_doi_from_url, wait = wait)
        dois <- do.call(rbind, doi_list)
      } else {
        next
      }

      if (citedby) {
        result <- rbind(result, tibble::tibble(citing_doi = dois$cited_doi,
                                               citing_article_link = dois$cited_article_link,
                                               cited_doi = urls$doi,
                                               cited_article_link = urls$url,
                                               depth = current_depth))
      } else {
        result <- rbind(result, tibble::tibble(citing_doi = urls$doi,
                                               citing_article_link = urls$url,
                                               cited_doi = dois$cited_doi,
                                               cited_article_link = dois$cited_article_link,
                                               depth = current_depth))
      }

    }

    if (nrow(result) > 0) {
      urls_to_process <- result |>
        dplyr::filter(.data$depth == current_depth) |>
        dplyr::select(.data$cited_article_link, .data$cited_doi) |>
        dplyr::filter(!.data$cited_doi %in% result$citing_doi) |>
        dplyr::pull(.data$cited_article_link) |>
        unique() |>
        stats::na.omit()
    } else {
      urls_to_process <- NULL
    }

  }

  if (nrow(result) > 0) {
    result <- result |>
      dplyr::group_by(.data$citing_doi, .data$cited_doi, .data$cited_article_link) |>
      dplyr::filter(.data$depth == min(.data$depth)) |>
      dplyr::ungroup() |>
      dplyr::distinct()
  }

  return(result)

}

get_urls_from_jstage <- function(page_content, citedby) {

  page <- rvest::read_html(page_content)

  target_wrap <- ifelse(citedby, "#citedby-wrap", "#article-overiew-references-wrap")

  target_div <- page |>
    rvest::html_elements(target_wrap) |>
    purrr::keep(~ {
      section_title <- rvest::html_element(.x, "div[class*='section-title']")
      !is.null(section_title)
    })

  jalc_urls <- if (length(target_div) > 0) {
    target_div |>
      rvest::html_elements("a[href^='https://jlc.jst.go.jp/DN/']") |>
      rvest::html_attr("href")
  } else {
    NULL
  }

  if (length(jalc_urls) == 0) {
    jalc_urls <- NA
  }

  doi <- page |>
    rvest::html_node("meta[name='doi']") |>
    rvest::html_attr("content")

  url <- page |>
    rvest::html_node("meta[name='og:url']") |>
    rvest::html_attr("content")

  return(data.frame(doi = doi, url = url, jalc_urls = jalc_urls))

}

setup_chromote_session <- function(url, timeout = 10000, quiet = TRUE) {

  tryCatch({
    if (!quiet) cat("\nStarting Chromote session...\n")

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

    # Additional wait time to ensure all content is rendered
    Sys.sleep(2)

    return(b)
  }, error = function(e) {
    if (exists("b") && !is.null(b) && inherits(b, "ChromoteSession")) {
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

get_doi_from_url <- function(jalc_url, wait) {

  page <- rvest::read_html(jalc_url)

  doi_links <- page |>
    rvest::html_elements("a[href*='https://doi.org/']") |>
    rvest::html_attr("href")
  dois <- gsub("https://doi.org/", "", doi_links)
  decoded_dois <- utils::URLdecode(dois)

  article_link <- page |>
    rvest::html_elements("a[href*='://www.jstage.jst.go.jp/article']") |>
    rvest::html_attr("href")

  if (length(decoded_dois) == 0) {
    decoded_dois <- NA
  }
  if (length(article_link) == 0) {
    article_link <- NA
  }

  Sys.sleep(wait)
  return(data.frame(cited_doi = decoded_dois, cited_article_link = article_link))

}
