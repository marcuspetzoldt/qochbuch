require 'spec_helper'

describe RecipesController do

  describe 'GET new' do
    before do
      get 'new'
    end

    it 'returns http success' do
      response.should be_success
    end
  end

end
