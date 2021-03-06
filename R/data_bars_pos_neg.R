#' Add horizontal bars to rows in a column containing positive and negative values
#'
#' The `data_bars_pos_neg()` function conditionally adds a negative horizontal bar to each row of a column containing negative values, and a positive horizontal bar to each row containing positive values.
#'     The length of the bars are relative to the value of the row in relation to other values within the same column.
#'     It should be placed within the cell argument in reactable::colDef.
#'
#' @param data Dataset containing at least one numeric column.
#'
#' @param colors A minimum of two colors or a vector of colors.
#'     Colors should be given in order from negative values to positive values.
#'     Can use R's built-in colors or other color packages.
#'
#' @param percent Optionally format numbers as percentages.
#'
#' @export
#'
#' @examples
#' data <- data.frame(
#' company = sprintf("Company%02d", 1:10),
#' profit_chg = c(0.2, 0.685, 0.917, 0.284, 0.105, -0.701, -0.528, -0.808, -0.957, -0.11))
#'
#' ## By default, the negative values are assigned a red bar, and the positive values are assigned a green bar
#' reactable(data, bordered = TRUE, columns = list(
#'  company = colDef(name = "Company", minWidth = 100),
#'  profit_chg = colDef(
#'    name = "Change in Profit",
#'    defaultSortOrder = "desc",
#'    align = "center",
#'    minWidth = 400,
#'    cell = data_bars_pos_neg(data))))
#'
#' ## You can apply a relative color scale to the bars by assigning three or more colors
#' reactable(data, bordered = TRUE, columns = list(
#'   company = colDef(name = "Company", minWidth = 100),
#'   profit_chg = colDef(
#'   name = "Change in Profit",
#'   defaultSortOrder = "desc",
#'   align = "center",
#'   minWidth = 400,
#'   cell = data_bars_pos_neg(data, colors = c("#ff3030", "#ffffff", "#1e90ff")))))
#'
#' ## Set 'percent = TRUE' to format the numbers as percentages
#' reactable(data, bordered = TRUE, columns = list(
#'   company = colDef(name = "Company", minWidth = 100),
#'   profit_chg = colDef(
#'   name = "Change in Profit",
#'   defaultSortOrder = "desc",
#'   align = "center",
#'   minWidth = 400,
#'   cell = data_bars_pos_neg(data, colors = c("#ff3030", "#ffffff", "#1e90ff"), percent = TRUE))))


data_bars_pos_neg <- function(data, colors = c("red","green"), percent = NULL) {

  cell <- function(value, index, name) {

    if (!is.numeric(value)) return(value)

    if (is.null(percent) || percent == FALSE) {

      label <- value

    } else label <- paste0(round(value * 100), "%")

    if (length(colors) > 2) {

      color_pal <- function(x) {

        if (!is.na(x)) rgb(colorRamp(c(colors))(x), maxColorValue = 255) else NULL
      }

      normalized <- (value - min(data[[name]], na.rm = TRUE)) / (max(data[[name]], na.rm = TRUE) - min(data[[name]], na.rm = TRUE))
      fill_color <- color_pal(normalized)

      neg_chart <- htmltools::div(style = list(flex = "1 1 0"))
      pos_chart <- htmltools::div(style = list(flex = "1 1 0"))

      if (is.numeric(value) & (is.null(percent) || percent == FALSE)) {
        
        width <- paste0(abs(value) / max(abs(data[[name]]), na.rm = TRUE) * 100, "%")
        
      } else if (is.numeric(value) & percent == TRUE) {
        
        width <- paste0(abs(value / 1) * 100, "%")
        
      } else return(value)

      if (value < 0) {

        bar <- htmltools::div(style = list(marginLeft = "8px", background = fill_color, width = width, height = "16px"))
        chart <- htmltools::div(style = list(display = "flex", alignItems = "center", justifyContent = "flex-end"), label, bar)
        neg_chart <- htmltools::tagAppendChild(neg_chart, chart)

      } else {

        bar <- htmltools::div(style = list(marginRight = "8px", background = fill_color, width = width, height = "16px"))
        chart <- htmltools::div(style = list(display = "flex", alignItems = "center"), bar, label)
        pos_chart <- htmltools::tagAppendChild(pos_chart, chart)}

      htmltools::div(style = list(display = "flex"), neg_chart, pos_chart)

    } else {

      neg_color <- colors[[1]]
      pos_color <- colors[[2]]

      neg_chart <- htmltools::div(style = list(flex = "1 1 0"))
      pos_chart <- htmltools::div(style = list(flex = "1 1 0"))

      if (is.numeric(value) & (is.null(percent) || percent == FALSE)) {
        
        width <- paste0(abs(value) / max(abs(data[[name]]), na.rm = TRUE) * 100, "%")
        
      } else if (is.numeric(value) & percent == TRUE) {
        
        width <- paste0(abs(value / 1) * 100, "%")
        
      } else return(value)

      if (value < 0) {

        bar <- htmltools::div(style = list(marginLeft = "8px", background = neg_color, width = width, height = "16px"))
        chart <- htmltools::div(style = list(display = "flex", alignItems = "center", justifyContent = "flex-end"), label, bar)
        neg_chart <- htmltools::tagAppendChild(neg_chart, chart)

      } else {

        bar <- htmltools::div(style = list(marginRight = "8px", background = pos_color, width = width, height = "16px"))
        chart <- htmltools::div(style = list(display = "flex", alignItems = "center"), bar, label)
        pos_chart <- htmltools::tagAppendChild(pos_chart, chart)}

      htmltools::div(style = list(display = "flex"), neg_chart, pos_chart)

    }
  }
}
