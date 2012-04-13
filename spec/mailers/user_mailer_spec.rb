require "spec_helper"

describe UserMailer do
  let(:deliver) { @email = UserMailer.daymail(@user, {news: @news}).deliver }

  before do
    @news ||= create_list(:news, 2)
    @user = stub('user',
      real_name: 'Joe Dupont',
      email: 'joe.dupont@example.net'
    )
  end

  it "sends the daymail correctly" do
    deliver
    ActionMailer::Base.deliveries.count.should == 1
  end

  it "contains expected informations" do
    deliver

    # we send it in both text and HTML so it should be 'multipart/alternative'
    @email.content_type.starts_with?('multipart/alternative').should be_true
    @email.from.should == ["bde@utt.fr"]
    @email.to.should == [@user.email]
    @email.subject.starts_with?('[Daymail] ').should be_true

    @news.each do |news|
      [:title, :content].each do |attribute|
        # we send it in both text and HTML so each attribute should be in twice
        @email.encoded.scan(news.send attribute).count.should == 2 * @news.count
      end
    end
  end

  it "does not contain old news" do
    old_news = create(:news, created_at: 2.days.ago)
    deliver
    @email.encoded.should_not include old_news.title
  end
end
