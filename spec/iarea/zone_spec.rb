# encoding: UTF-8
require 'spec_helper'

describe Iarea::Zone do
  describe 'Tokyo' do
    subject { Iarea::Zone.find(2) }
    its(:name) { should == "関東甲信越" }
  end

  describe 'equivalence' do
    before do
      @a = Iarea::Zone.find(0)
      @b = Iarea::Zone.find(0)
      @c = Iarea::Zone.find(1)
    end
    it do
      @a.should == @b
    end
    it do
      @a.should_not == @c
    end
  end
end
