# encoding: UTF-8
require 'spec_helper'

describe Iarea::Utils do
  it ".lat_lng_to_meshcode" do
    Iarea::Utils.lat_lng_to_meshcode(42.8840971954764,141.571321907496).should == "64412430032"
  end
  it ".expand_meshcode" do
    Iarea::Utils.expand_meshcode("64412430032").should == ["644124", "6441243", "64412430", "644124300", "6441243003", "64412430032", "64412430032"]
  end
end
