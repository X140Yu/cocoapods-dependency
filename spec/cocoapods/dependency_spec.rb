RSpec.describe Cocoapods::Dependency do
  it 'has a version number' do
    expect(Cocoapods::Dependency::VERSION).not_to be nil
  end

  it 'no podfile exists in path will raise error' do
    expect { Cocoapods::DependencyAnalyzer.analyze(Pathname.new('.')) }.to raise_error(/No Podfile exists/)
  end

  it 'generate custom podfile' do
    podfile = Pod::Podfile.new do
      platform :ios
      pod 'BananaLib', '1.0'
      pod 'CoconutLib', '1.0'
      pod 'OCMock', '3.4'
    end

    expect(podfile).not_to be nil
  end

  it 'custom podfile with simple dependency' do
    podfile = Pod::Podfile.new do
      target 'Test' do
        pod 'AFNetworking'
      end
    end

    Cocoapods::DependencyAnalyzer.analyze_with_podfile(Pathname.new('.'), podfile)
  end
end
