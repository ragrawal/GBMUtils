#' treeplot
#'
#' Plots GBM tree using graphviz library
#' @param m model 
#' @param tree tree to plot
#' @keywords gbm, json, gbm2json
#' @export
#' @examples
#' treeplot(model, 1)


treeplot <-
function(m, tree=1){

	#TODO: Sanity check: tree < noTree(gbmModel)

	df <- pretty.gbm.tree(m,i.tree=tree)
	nrow <- nrow(df)

	varNames <- m$var.names  
	varColors <- brewer.pal(length(varNames),"Spectral")
	varTypes <- m$var.type

	nodeNames <- c()
	nodeColors <- c()
	edgeLabels <- {}

	for(i in 1:nrow){
		var <- df[i,"SplitVar"]
		if(var == -1){
			nodeNames[i] <- "Leaf"
			nodeColors[i] <- "white"
		} else{
			nodeNames[i] <- varNames[var+1] #in gbm, node variables are index starting zero where as in R array index starts with one
			nodeColors[i] <- varColors[var+1]
		}
	}


	g <- new("graphNEL",nodes=as.character(1:nrow),edgemode="directed")

	#Add Edges
	for(i in 1:nrow){
		var <- df[i,"SplitVar"]
		if(var != -1){
			leftNode = as.character(df[i,"LeftNode"]+1)
			rightNode = as.character(df[i,"RightNode"]+1)
			missingNode = as.character(df[i,"MissingNode"]+1)
			
			g <- addEdge(as.character(i),leftNode,g,1)
			g <- addEdge(as.character(i),rightNode,g,1)
			g <- addEdge(as.character(i),missingNode,g,1)
			
			if(varTypes[var+1] == 0){
				edgeLabels[paste(i,'~',leftNode,sep="")]=paste("<",df[i,"SplitCodePred"],sep="")
				edgeLabels[paste(i,'~',rightNode,sep="")]=paste(">",df[i,"SplitCodePred"],sep="")	
			}
			
		}

	}

	#Assign Labels to Nodes
	names(nodeNames) <- nodes(g)
	names(nodeColors) <- nodes(g)
	nAttrs <- list()
	eAttrs <- list()

	nAttrs$label <- nodeNames
	nAttrs$fillcolor <- nodeColors
	eAttrs$label <- edgeLabels
	plot(g, nodeAttrs = nAttrs, edgeAttrs=eAttrs,
	attrs=list(node=list(fontcolo="black",fontsize=20,shape="rectangle")))
}

