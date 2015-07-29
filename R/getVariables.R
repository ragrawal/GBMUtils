#' getVariables
#'
#' Returns variables used in building the tree
#' @param model gbm model
#' @keywords gbm, json, gbm2json
#' @export
#' @examples
#' getVariables(model)

getVariables <-
function(model){
	names = model$var.names
	types = model$var.type
	
	relInf <- summary(model, plot=F)
	rownames(relInf) <- relInf$var
	
	nof = length(names)
	variables = list()
	for(i in 1:nof){
		v <- list()
		v[["name"]] = names[i]

		name = names[i]
		type = types[i]
		if(types[i] > 0){
			v[["type"]] = "categorical"
			v[["values"]] = gsub(' ','_',model$var.levels[[i]])
		}else{
			v[["type"]] = "numeric"
		}
		v[["rel.inf"]] <- relInf[v[["name"]], "rel.inf"]
		
		variables[[name]] = v
	}
	names(variables) <- NULL
	return(variables)
}

