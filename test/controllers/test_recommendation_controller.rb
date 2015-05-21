require_relative '../helper'

describe RecommendationsController do

  # .index is instance method - need an instance of class to use
  # #index is a class method - don't need an instance to use method
  describe ".index" do
    let(:controller) {RecommendationsController.new}
    it "should say no scenarios found when empty" do
      actual = controller.index('happy')
      expected = "No recommendations found.\n"
      assert_equal expected, actual
    end
  end

  describe ".add" do
    let(:controller) {RecommendationsController.new}
    describe "" do
      it "should add a recommendation to the database" do
        controller.add_row("songTitle", "songArtist", 'happy')
        assert_equal 1, Recommendation.count_by_mood('happy')
      end

      it "should not add recommendation with just whitespace" do
        bad_song_title = "        "
        controller.add_row(bad_song_title, "songArtist", 'happy')
        assert_equal 0, Recommendation.count_by_mood('happy')
      end
    end
  end

end
