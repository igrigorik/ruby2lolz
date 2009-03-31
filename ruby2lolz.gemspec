spec = Gem::Specification.new do |s|
  s.name = 'ruby2lolz'
  s.version = '0.1'
  s.date = '2009-03-31'
  s.summary = 'Ruby to Lolcode translator, kthnxbai.'
  s.description = s.summary
  s.email = 'ilya@igvita.com'
  s.homepage = "http://github.com/igrigorik/ruby2lolz"
  s.has_rdoc = true
  s.authors = ["Ilya Grigorik"]
  s.rubyforge_project = "ruby2lolz"
 
  # ruby -rpp -e' pp `git ls-files`.split("\n") '
  s.files = ["README",
	 "ruby2lolz.rb",
 	 "spec/lolz_spec.rb",
 	 "spec/specs/array.txt",
 	 "spec/specs/hash.txt",
 	 "spec/specs/hash_array.txt",
 	 "spec/specs/method.txt"]
end
