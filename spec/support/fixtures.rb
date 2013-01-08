def load_xml_file(file_name)
  open(File.join(SPEC_ROOT, 'spec', 'fixtures', "#{file_name}.xml")).read
end
