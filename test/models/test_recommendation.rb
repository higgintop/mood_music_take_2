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
        assert_equal 0, Recommendation.count
      end
    end

    describe "if there are recs in database" do
      before do
        create_recommendation("b_song", "b_artist", 1)
        create_recommendation("a_song", "a_artist", 2)
        create_recommendation("c_song", "c_artist", 3)
      end

      it "should return the correct count" do
        assert_equal 3, Recommendation.count
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
         recommendation.mood_category = "1"
         assert recommendation.save # returns the ID which is truthy
       end
       it "should save the model to the database" do
         recommendation.song_title = "test song title"
         recommendation.artist = "test artist"
         recommendation.mood_category = "1"

         recommendation.save
         last_row = Database.execute("SELECT * FROM recommendations")
         database_song_title = last_row[0]['song_title']
         assert_equal "test song title", database_song_title
       end
       it "should populate the model with the id from the database" do
         recommendation.song_title = "test song title"
         recommendation.artist = "test artist"
         recommendation.mood_category = "1"

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
         recommendation.mood_category = "1"

         refute recommendation.save
       end
       it "should not save the model to the database" do
         recommendation.song_title = ""
         recommendation.artist = "test artist"
         recommendation.mood_category = "1"

         recommendation.save
         assert_equal 0, Recommendation.count
       end
       it "should populate the error messages" do
         recommendation.song_title = ""
         recommendation.artist = "test artist"
         recommendation.mood_category = "1"

         recommendation.save
         assert_equal "Song title invalid", recommendation.errors
       end
     end
   end

   describe ".song_title_valid?" do
     describe "with valid data" do
       let(:recommendation) {Recommendation.new}
       it "returns true" do
         recommendation.song_title = "test song title"
         assert recommendation.song_title_valid?
       end
       it "should set errors to nil" do
         recommendation.song_title = "test song title"
         recommendation.song_title_valid?
         assert recommendation.errors.nil?
       end
     end

     describe "with an empty song title" do
       let(:recommendation) {Recommendation.new}
       it "returns false" do
         recommendation.song_title = ""
         refute recommendation.song_title_valid?
       end
       it "sets the error message" do
         recommendation.song_title = ""
         recommendation.song_title_valid?
         assert_equal "Song title invalid", recommendation.errors
       end
     end

     describe "a song title with no letter characters" do
       let(:recommendation) { Recommendation.new}
       it "returns false" do
         recommendation.song_title = "777"
         refute recommendation.song_title_valid?
       end
       it "sets the error message" do
         recommendation.song_title = "777"
         recommendation.song_title_valid?
         assert_equal "Song title invalid", recommendation.errors
       end
     end

     describe "with previously invalid song title" do
       let(:recommendation) {Recommendation.new}
       before do
         recommendation.song_title = "777"
         refute recommendation.song_title_valid?
         recommendation.song_title = "Better song title"
       end
       it "should return true" do
         assert recommendation.song_title_valid?
       end
       it "should not have an error message" do
         recommendation.song_title_valid?
         assert_nil recommendation.errors
       end
     end
   end




   describe ".artist_valid?" do
     describe "with valid data" do
       let(:recommendation) {Recommendation.new}
       it "returns true" do
         recommendation.artist = "test artist"
         assert recommendation.artist_valid?
       end
       it "should set errors to nil" do
         recommendation.artist = "test artist"
         recommendation.artist_valid?
         assert recommendation.errors.nil?
       end
     end

     describe "with an empty artist" do
       let(:recommendation) {Recommendation.new}
       it "returns false" do
         recommendation.artist = ""
         refute recommendation.artist_valid?
       end
       it "sets the error message" do
         recommendation.artist = ""
         recommendation.artist_valid?
         assert_equal "Artist invalid", recommendation.errors
       end
     end

     describe "an artist with no letter characters" do
       let(:recommendation) { Recommendation.new}
       it "returns false" do
         recommendation.artist = "777"
         refute recommendation.artist_valid?
       end
       it "sets the error message" do
         recommendation.artist = "777"
         recommendation.artist_valid?
         assert_equal "Artist invalid", recommendation.errors
       end
     end

     describe "with previously invalid artist" do
       let(:recommendation) {Recommendation.new}
       before do
         recommendation.artist = "777"
         refute recommendation.artist_valid?
         recommendation.artist = "Better Artist"
       end
       it "should return true" do
         assert recommendation.artist_valid?
       end
       it "should not have an error message" do
         recommendation.artist_valid?
         assert_nil recommendation.errors
       end
     end
   end



      describe ".mood_category_valid?" do
     describe "with valid data" do
       let(:recommendation) {Recommendation.new}
       it "returns true" do
         recommendation.mood_category = "1"
         assert recommendation.mood_category_valid?
       end
       it "should set errors to nil" do
         recommendation.mood_category = "1"
         recommendation.mood_category_valid?
         assert recommendation.errors.nil?
       end
     end

     describe "with an empty mood_category" do
       let(:recommendation) {Recommendation.new}
       it "returns false" do
         recommendation.mood_category = ""
         refute recommendation.mood_category_valid?
       end
       it "sets the error message" do
         recommendation.mood_category = ""
         recommendation.mood_category_valid?
         assert_equal "Mood category invalid", recommendation.errors
       end
     end

     describe "with previously invalid mood_category" do
       let(:recommendation) {Recommendation.new}
       before do
         recommendation.mood_category = "777"
         refute recommendation.mood_category_valid?
         recommendation.mood_category = "1"
       end
       it "should return true" do
         assert recommendation.mood_category_valid?
       end
       it "should not have an error message" do
         recommendation.mood_category_valid?
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
         recommendation.mood_category = "1"

         id = recommendation.save # put in database
         assert_equal 1, Recommendation.count

         # now update
         recommendation.song_title = "New Song Title"
         recommendation.update(id)
         last_row = Database.execute("SELECT * FROM recommendations WHERE song_title LIKE ?", "New Song Title")[0]
         assert_equal 1, Recommendation.count
         assert_equal new_song_title, last_row['song_title']
       end
     end
   end
end
