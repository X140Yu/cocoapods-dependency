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
    expect(json_output).to eq(json_expected.to_json)
  end
end
