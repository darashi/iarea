# encoding: UTF-8
require 'spec_helper'

describe Iarea::Area do
  context "at 43.0568397222222,141.3478975" do
    subject { Iarea::Area.find_by_lat_lng(43.0568397222222,141.3478975) }

    its(:name) { should == "すすきの" }
    its(:areacode) { should == "00208" }
    its(:areaid) { should == "002" }
    its(:subareaid) { should == "08" }
    it do
      subject.prefecture.name.should == "北海道"
    end
    it do
      subject.zone.name.should == "北海道"
    end
    it do
      subject.neighbors.map(&:name).should == ["大通公園周辺", "大通東", "山鼻/藻岩周辺", "中島公園周辺"]
    end
  end

  context "at 35.606022,139.734979" do
    subject { Iarea::Area.find_by_lat_lng(35.606022,139.734979) }
    its(:name) { should == "大井町" }
    its(:areacode) { should == "06003" }
    its(:areaid) { should == "060" }
    its(:subareaid) { should == "03" }
    it do
      subject.prefecture.name.should == "東京"
    end
    it do
      subject.zone.name.should == "関東甲信越"
    end
  end

  context "finding by id" do
    subject { Iarea::Area.find("06003") }
    its(:name) { should == "大井町" }
  end

  context "at out of Japan" do
    subject do
      Iarea::Area.find_by_lat_lng(0,0)
    end

    it "should be nil" do
      should be_nil
    end
  end
end
