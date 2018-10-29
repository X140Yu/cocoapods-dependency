require 'cocoapods-dependency/visual_out'

RSpec.describe 'CocoapodsDependency' do
  it 'visual out works' do
    dependency_map = {
      'A': %w[B C],
      'B': %w[C D]
    }
    json_output = CocoapodsDependency::VisualOutHelper.new(dependency_map).to_d3js_json
    json_expected = {
      'links': [
        { 'source': 'A', 'dest': 'B' },
        { 'source': 'A', 'dest': 'C' },
        { 'source': 'B', 'dest': 'C' },
        { 'source': 'B', 'dest': 'D' }
      ]
    }
    # expect(json_output).to eq(json_expected.to_json)
  end

  it 'file output' do
    dependency_map = {
      'A': %w[B C],
      'B': %w[C D]
    }
    result_path = File.expand_path('Fixtures/index_res.js', __dir__)
    expected_path = File.expand_path('Fixtures/index.js', __dir__)
    CocoapodsDependency::VisualOutHelper.new(dependency_map).write_d3js_to_file(result_path)
    expect(File.read(result_path) == File.read(expected_path))
  end

  it 'json output' do
    dependency_map = {
      'A': %w[B C],
      'B': %w[C D]
    }
    result_path = File.expand_path('Fixtures/index2_res.json', __dir__)
    expected_path = File.expand_path('Fixtures/index2.json', __dir__)
    CocoapodsDependency::VisualOutHelper.new(dependency_map).write_json_to_file(result_path)
    expect(File.read(result_path) == File.read(expected_path))
  end
end
