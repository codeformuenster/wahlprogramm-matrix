require 'json'

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