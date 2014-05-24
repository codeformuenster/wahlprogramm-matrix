require 'json'

desc 'Split agendas (*.md) in agendas/ into files in agendas.split/'
task :split do
  system 'sh split.sh'
  puts 'done.'
end

desc 'Load agendas from agendas/split/ into agendas.json'
task :"agendas.json" do
  agendas = Dir['./agendas/split/*'].sort.inject({}) do |h, f|
    file = f.split('/').last
    party = file.split('.').first
    h[party] ||= []
    h[party] << {id: file, text: File.read(f)}
    h
  end

  File.open('./agendas/agendas.json', 'w+') do |f|
    f.write agendas.to_json
  end

  puts 'done.'
end

desc 'Calculate distances.json from fragments in agendas/split'
task :"distances.json" do
  system 'Rscript distances.R'
  puts 'done.'
end
