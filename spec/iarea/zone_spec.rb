# encoding: UTF-8
require 'spec_helper'

describe Iarea::Zone do
  describe 'Tokyo' do
    subject { Iarea::Zone.find(3) }
    its(:name) { should == "関東甲信越" }

    it '#prefectures' do
      subject.prefectures.map(&:name).should == ["栃木", "群馬", "茨城", "埼玉", "千葉", "東京", "神奈川", "山梨", "長野", "新潟"]
    end
  end

  describe 'Shikoku' do
    subject { Iarea::Zone.find(8) }
    it '#areas' do
      subject.areas.map(&:name).should == ["高松市周辺", "東讃", "中讃", "西讃", "徳島市", "徳島県北部", "徳島県西部", "徳島県南部", "中予", "東予", "南予北部", "南予南部", "高知市", "高知県中部", "高知県東部", "高知県西部"]
    end
  end

  describe 'equivalence' do
    before do
      @a = Iarea::Zone.find(1)
      @b = Iarea::Zone.find(1)
      @c = Iarea::Zone.find(2)
    end
    it do
      @a.should == @b
    end
    it do
      @a.should_not == @c
    end
  end

  it '#all' do
    Iarea::Zone.all.should == (1..9).map {|i| Iarea::Zone.find(i)}
  end
end
