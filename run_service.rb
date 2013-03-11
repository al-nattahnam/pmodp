require './lib/pmodp'

pmodp = Pmodp.new ["A", "B", "C"]
#$stdout.puts pmodp.points.collect { |point| "module #{point.module}: #{point.path}" }
pmodp.run
