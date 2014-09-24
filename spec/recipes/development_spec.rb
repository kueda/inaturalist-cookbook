require 'chefspec'

describe 'inaturalist-cookbook::development' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['postgresql']['password']['postgres'] = 'itsapassword'
      node.set['rvm']['user_installs'] = [ {
        'user' => 'vagrant',
        'rubies' => [ 'ruby-1.9.3' ],
        'default_ruby' => 'ruby-1.9.3',
        'vagrant' => {
          'system_chef_solo' => '/usr/bun/chef-solo'
        }
      } ]
    end.converge(described_recipe)
  end

  before do
    stub_command('which sudo').and_return('/usr/bin/sudo')
    stub_command("bash -c \"source /home/vagrant/.rvm/scripts/rvm && type rvm | cat | head -1 | grep -q '^rvm is a function$'\"").and_return(true)
  end

  it 'includes sudo' do
    expect(chef_run).to include_recipe('sudo')
  end

  it 'includes rvm::user' do
    expect(chef_run).to include_recipe('rvm::user')
  end

  it 'includes postgresql::server' do
    expect(chef_run).to include_recipe('postgresql::server')
  end

  it 'includes postgresql::client' do
    expect(chef_run).to include_recipe('postgresql::client')
  end

end
