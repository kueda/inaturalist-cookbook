require 'chefspec'

describe 'inaturalist-cookbook::default' do

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'includes apt' do
    expect(chef_run).to include_recipe('apt')
  end

  it 'includes vim' do
    expect(chef_run).to include_recipe('vim')
  end

  it 'includes git' do
    expect(chef_run).to include_recipe('git')
  end

  it 'includes curl' do
    expect(chef_run).to include_recipe('curl')
  end

  it 'includes build-essential' do
    expect(chef_run).to include_recipe('build-essential')
  end

end
