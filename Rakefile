require 'bundler/setup'
require 'awesome_print'
require 'json'
require 'pry'

desc 'Generate json files from markdown documents'
task :default do
  require 'stopwords'
  require 'lingua/stemmer'
  require 'babosa'
  # require 'matrix'
  require 'narray'
  require 'tf-idf-similarity'

  # load files from documents/*.md
  puts 'Reading markdown documents...'
  documents_paths = Dir.glob('documents/*.md').sort
  documents = {}
  documents_paths.each_with_index do |path, document_index|
    text = File.read(path)
    # create hash { filename: { paragraph_id: "Paragraphtext" } }
    paragraphs = text.scan(/\#{1,3}[^#]+/).map(&:strip)
    title = paragraphs.shift.gsub(/#\s*/, '')
    documents[title] = paragraphs.each_with_index.map do |text, paragraph_index|
      { id: "d#{document_index}p#{paragraph_index}", text: text }
    end
  end
  puts 'done.'

  File.open('./data/documents.json', 'w+') do |f|
    f.write documents.to_json
    puts 'writing ./data/documents.json'
  end

  # create corpus from preprocessed paragraph texts
  stopwords = Stopwords::Snowball::Filter.new('de', Stopwords::Snowball::Filter.new('de').stopwords.map(&:capitalize))
  stemmer = Lingua::Stemmer.new(language: 'de')
  # create tfidf model
  corpus = []
  unstemmed_corpus = []
  documents.each do |title, paragraphs|
    paragraphs.each do |paragraph|
      text = paragraph[:text]
      # unhypenate
      text = text.gsub(/(\w)-[\s\n]+(?!und)/,"#{$1}")
      # transliterate
      text = text.to_slug.transliterate(:german).to_s
      # lowercase
      text = text.downcase
      # remove numbers
      text = text.gsub(/\d/,'')
      # remove remaining punctuation
      text = text.gsub(/[^a-zA-ZüÜöÖäÄ\s]/, '')
      # tokenize
      tokens = text.strip.split(/[\s\r\n]+/)
      # stopwords
      tokens = stopwords.filter tokens
      unstemmed_corpus << TfIdfSimilarity::Document.new(paragraph[:id], tokens: tokens)
      # stem
      tokens = tokens.map { |token| stemmer.stem(token) }
      corpus << TfIdfSimilarity::Document.new(paragraph[:id], tokens: tokens)
    end
  end
  puts 'Computing tf/idf model...'
  model = TfIdfSimilarity::BM25Model.new(corpus, library: :narray)
  unstemmed_model = TfIdfSimilarity::BM25Model.new(unstemmed_corpus, library: :narray)
  puts 'done.'

  # calculate important terms from unstemmed corpus
  puts 'Calculating important terms...'
  important = {}
  corpus.each_with_index do |doc, i|
    terms_with_weights = unstemmed_model.terms.zip unstemmed_model.instance_variable_get('@matrix').transpose[i,0..-1]
    important[doc.text] = terms_with_weights.sort_by { |term, weight| -weight }[0..2].inject({}) { |h, (term, weight)| h.update term => weight }
  end
  puts 'done.'

  File.open('./data/important.json', 'w+') do |f|
    f.write important.to_json
    puts 'writing ./data/important.json'
  end

  # write distance matrix from stemmed corpus
  puts 'Calculating paragraph distances...'
  similarity_matrix = model.similarity_matrix
  distances = {}
  corpus.each_with_index do |lhs, i|
    distances[lhs.text] = {}
    sum = 0.0
    corpus.each_with_index do |rhs, j|
      sum += distances[lhs.text][rhs.text] = similarity_matrix[i,j]
    end
    distances[lhs.text][:avg] = sum/corpus.length
  end
  puts 'done.'

  File.open('./data/distances.json', 'w+') do |f|
    f.write distances.to_json
    puts 'writing ./data/distances.json'
  end

  File.open('./debug.csv', 'w+') do |f|
    f.puts 'val'
    distances.each { |k,v| v.each { |k,v| f.puts v } }
  end

  puts 'Calculating closest paragraphs'
  closest = documents.map(&:last).reduce(:+).each_with_object({}) do |fromdoc, h|
    h[fromdoc[:id]] = documents.map do |title, docs|
      docs.map do |todoc|
        {doc: todoc[:id], dist: distances[fromdoc[:id]][todoc[:id]]}
      end.max_by do |h|
         h[:dist]
      end
    end
  end

  File.open('./data/closest.json', 'w+') do |f|
    f.write closest.to_json
    puts 'writing ./data/closest.json'
  end

end
