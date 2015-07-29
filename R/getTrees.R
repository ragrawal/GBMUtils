#' getTrees
#'
#' Returns specified tree from gbm model
#' @param model gbm model
#' @param n.trees tree to return
#' @keywords gbm, json, gbm2json
#' @export
#' @examples
#' getTrees(model, 10)


getTrees <-
function(model, n.trees){
	nodedef = c()
	trees = list()

	names = model$var.name
	types = model$var.type
	
	n <- n.trees
	for(i in 1:n){
		df <- pretty.gbm.tree(model, i.tree=i)
		df$NodeId <- as.numeric(rownames(df))
		nodedef <- names(df)
		nr <- nrow(df)
		nodes = list()
		for(j in 1:nr){
			row <- as.list(df[j,])
			splitVar <- as.integer(df$SplitVar[j])
			if(splitVar == -1){
				row[["SplitVar"]] <- "Leaf"
			}else{
				row[['Prediction']] <- as.numeric(0.0)
				varIndex = splitVar+1
				row[["SplitVar"]] <- names[varIndex] 
				if(types[varIndex] > 0){
					levels = gsub(' ','_',unlist(model$var.levels[varIndex]))
					splits = model$c.splits[[as.integer(df$SplitCodePred[j])+1]]
					tbl <- data.frame(levels, splits)
					names(tbl) <- c("value","branch")
					tbl <- subset(tbl, branch==-1)
					tbl$value <- tbl$value[,drop=T]
					row[["SplitCodePred"]] = as.character(tbl$value)					
				}
			}
			
			names(row) <- NULL
			nodes[[as.character(j-1)]]=row 
		}
		names(nodes) <- NULL
		tree = list("name"=as.character(i), "nodes"=nodes)
		trees[[as.character(i)]] = tree
	}
	
	nodedef[1] <- "Variable"
	nodedef[2] <- "SplitValue"
	names(trees) <- NULL
	return(	
		list(
			"trees"=trees,
			"nodedef"=nodedef
		)
	)
}

