require_relative '../helper'

describe Recommendation do

  # Rec#all
  describe "#all" do
    describe "if there are no recs in database" do
      it "should return an empty array" do
        assert_equal [], Recommendation.all
      end
    end

    describe "if there are recs in database" do
      before do
        create_recommendation("b_song", "b_artist", 1)
        create_recommendation("a_song", "a_artist", 2)
        create_recommendation("c_song", "c_artist", 3)
      end
      it "should return an array" do
        assert_equal Array, Recommendation.all.class
      end
      it "should return the recs in alpha order by song title" do
        actual = Recommendation.all.map{|rec| rec.song_title}
        expected = ["a_song", "b_song", "c_song"]
        assert_equal expected, actual
      end
    end
  end


  # Rec#count
  describe "#count" do
    describe "if there are no recs in database" do
      it "should return 0" do
        assert_equal 0, Recommendation.count_by_mood("happy")
      end
    end

    describe "if there are recs in database" do
      before do
        create_recommendation("b_song", "b_artist", "happy")
        create_recommendation("a_song", "a_artist", "happy")
        create_recommendation("c_song", "c_artist", "happy")
      end

      it "should return the correct count" do
        assert_equal 3, Recommendation.count_by_mood("happy")
      end
    end
  end


  describe ".initialize" do
    it "sets the song_title attribute" do
      rec = Recommendation.new("foo")
      assert_equal "foo", rec.song_title
    end
  end

   describe ".save" do
     describe "if the model is valid" do
       let(:recommendation) {Recommendation.new}
        it "should return true" do
         recommendation.song_title = "test song title"
         recommendation.artist = "test artist"
         recommendation.mood_category = "happy"
         assert recommendation.save # returns the ID which is truthy
       end
       it "should save the model to the database" do
         recommendation.song_title = "test song title"
         recommendation.artist = "test artist"
         recommendation.mood_category = "happy"

         recommendation.save
         last_row = Database.execute("SELECT * FROM recommendations")
         database_song_title = last_row[0]['song_title']
         assert_equal "test song title", database_song_title
       end
       it "should populate the model with the id from the database" do
         recommendation.song_title = "test song title"
         recommendation.artist = "test artist"
         recommendation.mood_category = "happy"

         recommendation.save
         last_row = Database.execute("SELECT * FROM recommendations")
         database_id = last_row[0]['id']
         assert_equal database_id, recommendation.id
       end
     end

     describe "if the model is invalid" do
       let (:recommendation) {Recommendation.new}
       it "should return false" do
         recommendation.song_title = ""
         recommendation.artist = "test artist"
         recommendation.mood_category = "happy"

         refute recommendation.save
       end
       it "should not save the model to the database" do
         recommendation.song_title = ""
         recommendation.artist = "test artist"
         recommendation.mood_category = "happy"

         recommendation.save
         assert_equal 0, Recommendation.count_by_mood("happy")
       end
       it "should populate the error messages" do
         recommendation.song_title = ""
         recommendation.artist = "test artist"
         recommendation.mood_category = "happy"

         recommendation.save
         assert_equal " is invalid", recommendation.errors
       end
     end
   end

   describe ".valid?" do
     describe "with valid data" do
       let(:recommendation) {Recommendation.new}
       it "returns true" do
         assert recommendation.valid?("test song title")
       end
       it "should set errors to nil" do
         recommendation.valid?("test song title")
         assert recommendation.errors.nil?
       end
     end

     describe "with an empty song title" do
       let(:recommendation) {Recommendation.new}
       it "returns false" do
         refute recommendation.valid?("")
       end
       it "sets the error message" do
         recommendation.song_title = ""
         recommendation.valid?("")
         assert_equal " is invalid", recommendation.errors
       end
     end

     describe "a song title with no letter characters" do
       let(:recommendation) { Recommendation.new}
       it "returns false" do
         recommendation.song_title = "777"
         refute recommendation.valid?("777")
       end
       it "sets the error message" do
         recommendation.song_title = "777"
         recommendation.valid?("777")
         assert_equal "777 is invalid", recommendation.errors
       end
     end

     describe "with previously invalid song title" do
       let(:recommendation) {Recommendation.new}
       before do
         recommendation.song_title = "777"
         refute recommendation.valid?("777")
         recommendation.song_title = "Better song title"
       end
       it "should return true" do
         assert recommendation.valid?("Better song title")
       end
       it "should not have an error message" do
         recommendation.valid?("Better song title")
         assert_nil recommendation.errors
       end
     end
   end

   describe ".update" do
     describe "edit previously entered recommendation" do
       let(:recommendation){Recommendation.new}
       let(:new_song_title){"New Song Title"}
       it "should update the recommendation but not the id" do
         recommendation.song_title = "Original Song Title"
         recommendation.artist = "Original Artist Name"
         recommendation.mood_category = "happy"

         id = recommendation.save # put in database
         assert_equal 1, Recommendation.count_by_mood("happy")

         # now update
         recommendation.song_title = "New Song Title"
         recommendation.update(id)
         last_row = Database.execute("SELECT * FROM recommendations WHERE song_title LIKE ?", "New Song Title")[0]
         assert_equal 1, Recommendation.count_by_mood("happy")
         assert_equal new_song_title, last_row['song_title']
       end
     end
   end
end
