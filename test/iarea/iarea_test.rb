# encoding: UTF-8
require 'test_helper'

describe Iarea::Utils do
  it ".lat_lng_to_meshcode" do
    Iarea::Utils.lat_lng_to_meshcode(42.8840971954764,141.571321907496).should == "64412430032"
  end
  it ".expand_meshcode" do
    Iarea::Utils.expand_meshcode("64412430032").should == ["644124", "6441243", "64412430", "644124300", "6441243003", "64412430032", "64412430032"]
  end
end

describe Iarea::Area do
  context "at 43.0568397222222,141.3478975" do
    subject do
      Iarea::Area.find_by_lat_lng(43.0568397222222,141.3478975)
    end

    it "#name" do
      subject.name.should == "すすきの"
    end

    it "#areacode" do
      subject.areacode.should == "00208"
    end

    it "#areaid" do
      subject.areaid.should == "002"
    end

    it "#subareaid" do
      subject.subareaid.should == "08"
    end
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
