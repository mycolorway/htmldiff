# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'
require 'htmldiff'

class TestDiff
  extend HTMLDiff
end

describe "htmldiff" do

  it "should diff text" do
    diff = TestDiff.diff('a word is here', 'a nother word is there')
    diff.should == "a<ins class=\"diffins\"> nother</ins> word is <del class=\"diffmod\">here</del><ins class=\"diffmod\">there</ins>"
  end

  it "should insert a letter and a space" do
    diff = TestDiff.diff('a c', 'a b c')
    diff.should == "a <ins class=\"diffins\">b </ins>c"
  end

  it "should remove a letter and a space" do
    diff = TestDiff.diff('a b c', 'a c')
    diff.should == "a <del class=\"diffdel\">b </del>c"
  end

  it "should change a letter" do
    diff = TestDiff.diff('a b c', 'a d c')
    diff.should == "a <del class=\"diffmod\">b</del><ins class=\"diffmod\">d</ins> c"
  end

  it "should support Chinese" do
    diff = TestDiff.diff('这个是中文内容, Ruby is the bast', '这是中国语内容，Ruby is the best language.')
    diff.should == "这<del class=\"diffdel\">个</del>是中<del class=\"diffmod\">文</del><ins class=\"diffmod\">国语</ins>内容<del class=\"diffmod\">, Ruby</del><ins class=\"diffmod\">，Ruby</ins> is the <del class=\"diffmod\">bast</del><ins class=\"diffmod\">best language.</ins>"
  end

  it "should support html tag filter" do
    diff = TestDiff.diff('a <img src="1.jpg" />, c', 'a bb<img src="2.jpg" />, d', allow_tags = ['img'])
    diff.should == "a <del class=\"diffmod\"><img src=\"1.jpg\" /></del><ins class=\"diffmod\">bb<img src=\"2.jpg\" /></ins>, <del class=\"diffmod\">c</del><ins class=\"diffmod\">d</ins>"

    diff = TestDiff.diff('a', 'a bbb<img src="1.jpg" />', allow_tags = ['img'])
    diff.should == "a<ins class=\"diffins\"> bbb<img src=\"1.jpg\" /></ins>"

    diff = TestDiff.diff('a', 'a <p>b</p>', allow_tags = ['p'])
    diff.should == "a<ins class=\"diffins\"> <p>b</p></ins>"
  end

end
