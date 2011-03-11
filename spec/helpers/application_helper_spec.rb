require "spec_helper"

describe ApplicationHelper do
  
  describe "#truncate_url" do
    it "returns truncated url" do
      url = ['http://www.', 'example.com/']
      helper.truncate_url(url.join(''), n = 24).should == url[1]
    end

    it "returns truncated url" do
      url = ['http://www.', 'example.com/123456789012', '3456789']
      helper.truncate_url(url.join(''), n = 24).should == url[1] + ' ...'
    end
  end
end
