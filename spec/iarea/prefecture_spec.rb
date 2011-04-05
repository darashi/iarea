# encoding: UTF-8
require 'spec_helper'

describe Iarea::Prefecture do
  describe 'Tokyo' do
    subject { Iarea::Prefecture.find(12) }
    its(:name) { should == "東京" }
    it do
      subject.zone.name.should == "関東甲信越"
    end
  end

  describe 'equivalence' do
    before do
      @a = Iarea::Prefecture.find(0)
      @b = Iarea::Prefecture.find(0)
      @c = Iarea::Prefecture.find(1)
    end
    it do
      @a.should == @b
    end
    it do
      @a.should_not == @c
    end
  end

  it '#all' do
    Iarea::Prefecture.all.should == (0..46).map {|i| Iarea::Prefecture.find(i)}
  end
end
