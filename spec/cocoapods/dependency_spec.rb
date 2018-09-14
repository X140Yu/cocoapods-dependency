RSpec.describe 'CocoapodsDependency' do
  it 'has a version number' do
    expect(CocoapodsDependency::VERSION).not_to be nil
  end

  it 'no podfile exists in path will raise error' do
    expect { CocoapodsDependency::Analyzer.analyze(Pathname.new('/')) }.to raise_error(/No Podfile exists/)
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
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        pod 'Masonry', '1.0'
      end
    end

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq('Masonry' => [])
  end

  it 'custom podfile with two dependencies' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        pod 'Masonry', '1.0'
        pod 'ReactiveObjC', '1.0.1'
      end
    end

    res_map = {
      'Masonry' => [],
      'ReactiveObjC' => []
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with dependencies' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        pod 'RxCocoa', '4.2'
      end
    end

    res_map = {
      'RxSwift' => [],
      'RxCocoa' => ['RxSwift']
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with subspec' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        # https://github.com/rs/SDWebImage/blob/master/SDWebImage.podspec
        pod 'SDWebImage', '4.4.2'
      end
    end

    res_map = {
      'SDWebImage' => [],
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with subspec 2' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        # https://github.com/rs/SDWebImage/blob/master/SDWebImage.podspec
        pod 'SDWebImage/GIF', '4.4.2'
      end
    end

    res_map = {
      'SDWebImage' => ['FLAnimatedImage'],
      'FLAnimatedImage' => [],
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with subspec 3' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        # https://github.com/rs/SDWebImage/blob/master/SDWebImage.podspec
        pod 'SDWebImage/GIF', '4.4.2'
        pod 'SDWebImage/WebP', '4.4.2'
      end
    end

    res_map = {
      'SDWebImage' => %w[FLAnimatedImage libwebp],
      'FLAnimatedImage' => [],
      'libwebp' => [],
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with subspec 4' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        # https://github.com/rs/SDWebImage/blob/master/SDWebImage.podspec
        pod 'SDWebImage/GIF', '4.4.2'
        pod 'SDWebImage/WebP', '4.4.2'
        pod 'RxCocoa', '4.2'
      end
    end

    res_map = {
      'SDWebImage' => %w[FLAnimatedImage libwebp],
      'FLAnimatedImage' => [],
      'libwebp' => [],
      'RxCocoa' => %w[RxSwift],
      'RxSwift' => [],
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with subspec 5' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        # https://github.com/TextureGroup/Texture/blob/master/Texture.podspec
        pod 'Texture', '2.7'
      end
    end

    res_map = {
      'Texture' => %w[PINCache PINOperation PINRemoteImage],
      'PINCache' => %w[PINOperation],
      'PINRemoteImage' => %w[PINCache PINOperation],
      'PINOperation' => [],
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end

  it 'dependencies with subspec 6' do
    podfile = Pod::Podfile.new do
      project 'spec/cocoapods/Fixtures/Test/Test.xcodeproj'
      target 'Test' do
        # https://github.com/TextureGroup/Texture/blob/master/Texture.podspec
        pod 'Texture', '2.7', subspecs: %w[PINRemoteImage IGListKit Yoga]
      end
    end

    res_map = {
      'Texture' => %w[IGListKit PINCache PINOperation PINRemoteImage Yoga],
      'PINCache' => %w[PINOperation],
      'PINRemoteImage' => %w[PINCache PINOperation],
      'PINOperation' => [],
      'IGListKit' => [],
      'Yoga' => [],
    }

    expect(
      CocoapodsDependency::Analyzer.analyze_with_podfile(Pathname.new('/'), podfile)
    ).to eq(res_map)
  end
end
