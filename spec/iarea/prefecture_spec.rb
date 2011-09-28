# encoding: UTF-8
require 'spec_helper'

describe Iarea::Prefecture do
  describe 'Tokyo' do
    subject { Iarea::Prefecture.find(13) }
    its(:name) { should == "東京" }
    it do
      subject.zone.name.should == "関東甲信越"
    end
  end

  describe 'Okinawa' do
    subject { Iarea::Prefecture.find(47) }
    its(:name) { should == "沖縄" }
    it do
      subject.areas.map(&:name).should == ["那覇/浦添", "沖縄/名護", "宮古/石垣"]
    end
  end

  describe 'equivalence' do
    before do
      @a = Iarea::Prefecture.find(1)
      @b = Iarea::Prefecture.find(1)
      @c = Iarea::Prefecture.find(2)
    end
    it do
      @a.should == @b
    end
    it do
      @a.should_not == @c
    end
  end

  it '#all' do
    Iarea::Prefecture.all.should == (1..47).map {|i| Iarea::Prefecture.find(i)}
  end

  context 'finding by invalid id' do
    it do
      Iarea::Prefecture.find(-1).should be_nil
    end
  end
end
