require 'spec_helper'

#TODO: Tester les permissions basiques pour chaque cas (Anonyme, inscrit, UTTien, moderator, admin)

describe Ability do
  describe 'Anonymous user' do
    before(:all) do
      @ability = Ability.new(nil)
    end

    subject { @ability }

    it { should be_able_to(:read, News.new(:is_moderated => true)) }
    it { should be_able_to(:read, Classified.new) }
    it { should_not be_able_to(:read, User.new) }
  end
end
