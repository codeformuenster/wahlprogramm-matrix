library('tm')
library('rjson')
library('lsa')
setwd(paste(getwd(), 'agendas/split/', sep='/'))
c <- Corpus(DirSource('.'))
c <- tm_map(c, removeNumbers)
c <- tm_map(c, removePunctuation)
c <- tm_map(c, removeWords, stopwords('de'))
c <- tm_map(c, stripWhitespace)

m = as.matrix(DocumentTermMatrix(c, control = list(weighting = weightTfIdf)))
mostImportantTerms = apply(m, 1, function(row) {
  order = order(row, decreasing = TRUE)
  colnames(m)[order[0:3]]
})
mostImportantTermsFrame = as.data.frame(mostImportantTerms, stringAsFactors=FALSE)
mostImportantTermsJSON = toJSON(mostImportantTermsFrame)

c <- tm_map(c, content_transformer(tolower))
c <- tm_map(c, stemDocument, 'german')

tfidf <- DocumentTermMatrix(c, control = list(weighting = weightTfIdf))

cosine_distance_matrix <- cosine(t(as.matrix(removeSparseTerms(tfidf, 0.95))))
cosine_distance_matrix_data <- as.data.frame(cosine_distance_matrix)

d = cosine_distance_matrix_data
d = d[d$CDU.mdaa > 0,] # make NaN row a NA row
meandist = apply(d,2,mean, na.rm=TRUE)
outlier = sort(meandist, decreasing=TRUE)[0:15]

cdmjson <- toJSON(
  lapply(
    lapply(cosine_distance_matrix_data, as.list)
    , function(x) { names(x) <- colnames(cosine_distance_matrix_data); x}))

setwd(paste(getwd(), '..', sep='/'))
write(mostImportantTermsJSON, 'important.json')
write(cdmjson, 'distances.json')
write(outlier, 'outlier.json')
