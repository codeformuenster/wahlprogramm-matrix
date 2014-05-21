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
distance <- dist(as.matrix(tfidf))
distance_matrix <- as.matrix(distance)
distance_matrix_data <- as.data.frame(distance_matrix)

json <- toJSON(
          lapply(
            lapply(distance_matrix_data, as.list)
          , function(x) { names(x) <- colnames(distance_matrix_data); x}))

setwd('~/code/document-matrix/agendas/')
write(json, 'distances.json')

cdm <- cosine(t(as.matrix(removeSparseTerms(tfidf, 0.95))))
cdmd <- as.data.frame(cdm)

cdmjson <- toJSON(
  lapply(
    lapply(cdmd, as.list)
    , function(x) { names(x) <- colnames(cdmd); x}))

setwd('~/code/document-matrix/agendas/')
write(cdmjson, 'cdistances.json')