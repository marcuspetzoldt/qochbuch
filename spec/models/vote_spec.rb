require 'spec_helper'

describe Vote do

  before do
    @recipe = FactoryGirl.create(:recipe)
    @vote = Vote.new(recipe_id: @recipe.id, user_id: @recipe.user.id, vote: 3)
  end

  it 'should have these fields' do
    expect(@vote).to respond_to(:vote)
  end

  describe 'vote' do
    it 'should be invalid if not present' do
      @vote.vote = nil
      expect(@vote).not_to be_valid()
    end

    it 'should be invalid if less than 0' do
      @vote.vote = -1
      expect(@vote).not_to be_valid()
    end

    it 'should be invalid if greater than 4' do
      @vote.vote = 5
      expect(@vote).not_to be_valid()
    end

    it 'should be valid' do
      5.times do |i|
        @vote.vote = i
        expect(@vote).to be_valid()
      end
    end
  end
end
