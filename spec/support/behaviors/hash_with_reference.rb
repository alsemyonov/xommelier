shared_examples_for 'Hash with references' do |*args|
  keys = args.shift
  values = args.size > 1 ? args.shift : keys

  keys.each do |key|
    it { subject.include?(key).should be_true }
  end
  its(:count) { should == keys.size }
  its(:keys) { should == keys }
  its(:values) { should == values }
end
