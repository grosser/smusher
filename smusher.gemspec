# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{smusher}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Grosser"]
  s.date = %q{2009-01-27}
  s.default_executable = %q{smusher}
  s.description = %q{Automatic Lossless Reduction Of All Your Images}
  s.email = %q{grosser.michael@gmail.com}
  s.executables = ["smusher"]
  s.extra_rdoc_files = ["lib/smusher.rb", "bin/smusher", "README.markdown"]
  s.files = ["Manifest", "lib/smusher.rb", "spec/out/people.jpg", "spec/spec_helper.rb", "spec/smusher_spec.rb", "spec/images/logo.gif", "spec/images/woman.jpeg", "spec/images/add.png", "spec/images/drink_empty.png", "spec/images/people.jpg", "spec/images/water.JPG", "spec/reduced/fam.png", "spec/reduced/add.png", "bin/smusher", "Rakefile", "README.markdown", "smusher.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/grosser/smusher}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Smusher", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{smusher}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Automatic Lossless Reduction Of All Your Images}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
