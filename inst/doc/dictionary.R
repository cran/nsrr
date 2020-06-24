## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(nsrr)

## -----------------------------------------------------------------------------
library(nsrr)
df = nsrr_datasets()
head(df)

## -----------------------------------------------------------------------------
datasets = df$slug
L = vector(mode = "list", length = length(datasets))
names(L) = datasets
for (dataset in datasets) {
  a = nsrr_dataset_files(dataset = dataset, path = "datasets")
  L[[dataset]] = a
  print(dataset)
}
head(L[[1]])

## ----subsetfiles--------------------------------------------------------------
files = lapply(L, function(x) {
  if (length(x) == 0) {
    return(NULL)
  }
  x[ grepl("dictionary", tolower(x$file_name)),]
})
files = do.call("rbind", files)
rownames(files) = NULL
head(files)
vars = files[ grepl("variables", tolower(files$file_name)),]
head(vars)

## ----dl-----------------------------------------------------------------------
i = 3
# for (i in seq(nrow(vars))) {
  idf = vars[i,]
  out = nsrr::nsrr_download_file(
    dataset = idf$dataset, 
    path = idf$full_path,
    check_md5 = FALSE
  )
  if (requireNamespace("readr", quietly = TRUE)) {
    var_df = readr::read_csv(out$outfile)
  } else {
    var_df = utils::read.csv(out$outfile, as.is = TRUE)
  }
  print(head(var_df))
# }

