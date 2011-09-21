def open_fixture(name)
  open(File.join(SPEC_ROOT, 'spec/fixtures', name))
end
