require 'spec_helper'
require 'globals'

describe 'config/support/globals.yml' do
  let(:user) { random_text }
  let(:globals) do
    with_user(user) do
      configs = [:development, :production, :sandbox, :test].map do |e|
        [e, Globals.read('config/support/globals.yml', e)]
      end
      Hash[*configs.flatten]
    end
  end

  [:development, :production, :sandbox, :test].each do |environment|
    it "should not raise any error for #{environment}." do
      expect { Globals.read('config/support/globals.yml', environment) }.to_not raise_error
    end
  end

  it 'should raise an error for unknown environments.' do
    expect {
      Globals.read('config/support/globals.yml', 'foo')
    }.to raise_error('Globals were not defined for environment: foo in config/support/globals.yml')
  end

  describe 'application' do
    [:development, :production, :sandbox, :test].each do |environment|
      it environment do
        globals[environment].application.should == 'Example'
      end
    end
  end

  describe 'deployment' do
    describe 'dir' do
      [:sandbox, :production].each do |environment|
        it environment do
          globals[environment].deployment.dir.should == '/mnt/deployment/example'
        end
      end
    end

    describe 'host' do
      it 'sandbox' do
        globals[:sandbox].deployment.host.should == "#{user}.i.example.com"
      end

      it 'production' do
        globals[:production].deployment.host.should == 'www.example.com'
      end
    end

    describe 'repository' do
      [:development, :production, :sandbox, :test].each do |environment|
        it environment do
          globals[environment].deployment.repository.should == "git@github.com:#{user}/example.git"
        end
      end
    end

    describe 'user' do
      [:production, :sandbox].each do |environment|
        it environment do
          globals[environment].deployment.user.should == 'user'
        end
      end
    end
  end

  describe 'host' do
    it 'development' do
      globals[:development].host.should == 'localhost:3000'
    end

    it 'production' do
      globals[:production].host.should == 'www.example.com'
    end

    it 'sandbox' do
      globals[:sandbox].host.should == "#{user}.i.example.com"
    end

    it 'test' do
      globals[:test].host.should == 'test.host'
    end
  end

  describe 'token' do
    [:development, :production, :sandbox, :test].each do |environment|
      it environment do
        globals[environment].token.should == '2def5bdfe89f8dda89d37fb95932483450cf995b20252fc60cbe82cf1e0688504a79c25bfcc52c123c9d37cc3b806753854b9b473e4f3ba8db415bbe40390fe6'
      end
    end
  end
end