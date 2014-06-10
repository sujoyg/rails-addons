require 'spec_helper'

describe 'routes' do
  it 'routes GET /' do
    root_path.should == '/'
    { :get => '/' }.should route_to :controller => 'site', :action => 'home'
  end
end
