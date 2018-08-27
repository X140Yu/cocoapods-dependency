RSpec.describe Cocoapods::Dependency do
  it 'has a version number' do
    expect(Cocoapods::Dependency::VERSION).not_to be nil
  end

  it 'no podfile exists in path will raise error' do
    expect { Cocoapods::DependencyAnalyzer.analyze(Pathname.new('.')) }.to raise_error(/No Podfile exists/)
  end

  it '' do
    
  end
end
