#' getMetaInfo
#'
#' Returns metadata list containing various training parameters for gbm trees
#' @param model gbm model
#' @param owner owner who created the tree. By default blank
#' @param description short description. By default blank
#' @keywords gbm, json, gbm2json
#' @export
#' @examples
#' getMetaInfo(model, owner="ragrawal", description="sample tree")

getMetaInfo <-
function(model, owner="", description="", ...){
	info <- list(
		'contact'=owner,
		'description'=description,
		'distribution'=model$distribution$name,
		'n.tree'=model$n.trees,
		'shrinkage'=model$shrinkage,
		'interaction.depth'=model$interaction.depth,
		'intercept'=model$initF
	)
	return(info)
}

