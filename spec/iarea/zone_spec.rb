# encoding: UTF-8
require 'spec_helper'

describe Iarea::Zone do
  describe 'Tokyo' do
    subject { Iarea::Zone.find(2) }
    its(:name) { should == "関東甲信越" }

    it '#prefectures' do
      subject.prefectures.map(&:name).should == ["栃木", "群馬", "茨城", "埼玉", "千葉", "東京", "神奈川", "山梨", "長野", "新潟"]
    end
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

  it '#all' do
    Iarea::Zone.all.should == (0..8).map {|i| Iarea::Zone.find(i)}
  end
end
