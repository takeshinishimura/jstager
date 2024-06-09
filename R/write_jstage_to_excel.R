#' Write J-Stage Data to Excel File
#'
#' @description
#' Writes the J-Stage search results to an Excel file.
#'
#' @param data
#'   A list containing the metadata and entry data frames obtained from J-Stage.
#' @param file_name
#'   A character string specifying the name of the Excel file to save the data.
#' @return None. The function writes data to an Excel file.
#' @export
write_jstage_to_excel <- function(data, file_name) {
  wb <- openxlsx::createWorkbook()

  openxlsx::addWorksheet(wb, "metadata")
  openxlsx::writeData(wb, "metadata", data$metadata)

  openxlsx::addWorksheet(wb, "entry")
  openxlsx::writeData(wb, "entry", data$entry)

  wrap_text_style <- openxlsx::createStyle(wrapText = TRUE)
  openxlsx::addStyle(wb, sheet = "entry", style = wrap_text_style,
                     rows = 1:nrow(data$entry) + 1, cols = 5:6,
                     gridExpand = TRUE)

  openxlsx::saveWorkbook(wb, file_name, overwrite = TRUE)
}
