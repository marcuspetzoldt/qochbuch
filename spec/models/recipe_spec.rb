require 'spec_helper'

describe Recipe do

  before do
    @recipe = Recipe.new(
        time: 10,
        level: 1,
        title: 'Titel',
        description: 'Beschreibung',
        directions: 'Zubereitung'
    )
  end

  it "should have these fields" do
    expect(@recipe).to respond_to(:time)
    expect(@recipe).to respond_to(:level)
    expect(@recipe).to respond_to(:title)
    expect(@recipe).to respond_to(:description)
    expect(@recipe).to respond_to(:directions)
  end

  describe 'time' do
    it 'should be invalid if not pressent' do
      @recipe.time = nil
      expect(@recipe).not_to be_valid()
    end

    it 'should be invalid if not numeric' do
      @recipe.time = 'Invalid'
      expect(@recipe).not_to be_valid()
    end

    it 'should be invalid if zero' do
      @recipe.time = '0'
      expect(@recipe).not_to be_valid()
    end

    it 'should be invalid if less than zero' do
      @recipe.time = '-1'
      expect(@recipe).not_to be_valid()
    end

    it 'should be vaild' do
      expect(@recipe).to be_valid()
    end
  end

  describe 'level' do
    it 'should be invalid if not numeric' do
      @recipe.level = 'Invalid'
      expect(@recipe).not_to be_valid()
    end

    describe 'should be invalid if out of range' do
      it 'should not be less than 0' do
        @recipe.level = '-1'
        expect(@recipe).not_to be_valid()
      end
      it 'should not be greater than 4' do
        @recipe.level = '5'
        expect(@recipe).not_to be_valid()
      end
    end

    it 'should be valid' do
      (0..4).each do |level|
        @recipe.level = level
        expect(@recipe).to be_valid()
      end
    end
  end

  describe 'title' do
    it 'should be invalid if not present' do
      @recipe.title = nil
      expect(@recipe).not_to be_valid()
    end
    it 'should be valid' do
      expect(@recipe).to be_valid()
    end
  end

  describe 'description' do
    it 'should always be valid' do
      expect(@recipe).to be_valid()
      @recipe.description = nil
      expect(@recipe).to be_valid()
    end
  end

  describe 'directions' do
    it 'should be invalid if not present' do
      @recipe.directions = nil
      expect(@recipe).not_to be_valid()
    end
    it 'should be valid' do
      expect(@recipe).to be_valid()
    end
  end
end
