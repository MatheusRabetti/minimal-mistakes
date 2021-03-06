#!/usr/bin/Rscript 

KnitPost <- function(input, outfile, figsfolder, cachefolder, base.url="/") {
  require(knitr);
  opts_knit$set(base.url = base.url)
  fig.path <- paste0(figsfolder, sub(".Rmd$", "", basename(input)), "/")
  cache.path <- file.path(cachefolder, sub(".Rmd$", "", basename(input)), "/")
  
  opts_chunk$set(fig.path = fig.path)
  opts_chunk$set(cache.path = cache.path)
  opts_chunk$set(fig.cap = "center")
  render_jekyll()
  knit(input, outfile, envir = parent.frame())
}

knit_folder <- function(infolder, outfolder, figsfolder, cachefolder) {
  for (infile in list.files(infolder, pattern = "*.Rmd", full.names = TRUE)) {
    pattern = "\\d\\d\\d\\d\\-\\d\\d\\-\\d\\d\\-"
    print(infile)
    # folder = ifelse(grepl(pattern, infile), outfolder, "pages")
    outfile = paste0(outfolder, "/", sub(".Rmd$", ".md", basename(infile)))
    print(outfile)
    
    # knit only if the input file is the last one modified
    if (!file.exists(outfile) |
        file.info(infile)$mtime > file.info(outfile)$mtime) {
      KnitPost(infile, outfile, figsfolder, cachefolder)
    }
  }
}

knit_folder("../_R", "../_posts", "../figs/", "../_caches/")
