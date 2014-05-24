library('tm')
library('rjson')
library('lsa')
setwd('~/code/document-matrix/agendas/split/')
c <- Corpus(DirSource('.'))
c <- tm_map(c, tolower)
c <- tm_map(c, removeNumbers)
c <- tm_map(c, removePunctuation)
c <- tm_map(c, removeWords, stopwords('de'))
c <- tm_map(c, stripWhitespace)
c <- tm_map(c, stemDocument, 'german')

tfidf <- DocumentTermMatrix(c, control = list(weighting = weightTfIdf))

cosine_distance_matrix <- cosine(t(as.matrix(removeSparseTerms(tfidf, 0.95))))
cosine_distance_matrix_data <- as.data.frame(cosine_distance_matrix)

cdmjson <- toJSON(
  lapply(
    lapply(cosine_distance_matrix_data, as.list)
    , function(x) { names(x) <- colnames(cosine_distance_matrix_data); x}))

setwd('~/code/document-matrix/agendas/')
write(cdmjson, 'distances.json')
