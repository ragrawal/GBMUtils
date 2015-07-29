#' gbm2json function
#'
#' This function converts gbm tree trained using gbm package into json format
#' @param model gbm model
#' @param n.trees number of trees to convert to json format
#' @keywords gbm, json, gbm2json
#' @export
#' @examples
#' gbm2json(model, 10)

gbm2json <-
function(model, n.trees, ...){
	output = list()
	output[["meta"]] <- getMetaInfo(model, ...)
	output[["variables"]] <- getVariables(model)

	trees = getTrees(model, n.trees)
	output <- c(output, getTrees(model, n.trees))

	return(toJSON(output))
}

