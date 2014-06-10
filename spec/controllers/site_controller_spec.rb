require 'spec_helper'

describe SiteController do
  describe '#home' do
    it 'should render.' do
      get :home
      response.should be_success
    end
  end
end
