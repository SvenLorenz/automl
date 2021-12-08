# Intermediate recombination via mean
# @param parent (`data.table()`): data.table with one row holding the parent
# @param partner (`data.table()`): data.table with one row holding the other parent (partner)
# @param x_ids (`character()`): names of x
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @return (`data.table()`): data.table of recombined parent
recombine_intermediate = function(parent, partner, x_ids, lower, upper) {
  stop("To Implement")
}

# Uniform recombination by sampling each gene
# @param parent (`data.table()`): data.table with one row holding the parent
# @param partner (`data.table()`): data.table with one row holding the other parent (partner)
# @param x_ids (`character()`): names of x
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @param recom_prob (`double(1)`): probability of recombination of a gene
# @return (`data.table()`): data.table of recombined parent
recombine_uniform = function(parent, partner, x_ids, lower, upper, recom_prob = 0.5) {
  stop("To Implement")
}

# No recombination
# @param parent (`data.table()`): data.table with one row holding the parent
# @param partner (`data.table()`): data.table with one row holding the other parent (partner)
# @param x_ids (`character()`): names of x
# @param lower (`double()`): lower bounds of the domain of the objective
# @param upper (`double()`): upper bounds of the domain of the objective
# @return (`data.table()`): data.table of recombined parent
recombine_none = function(parent, partner, x_ids, lower, upper) {
  stop("To Implement")
}

