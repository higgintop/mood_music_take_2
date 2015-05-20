#!/usr/bin/env ruby

class MoodsController

  # controller for mood
  def find_recommendation(category_name)
    recommendation_output = ""
    mood = Mood.new(category_name)
    mood_id = mood.get_category_id

    random_rec = Recommendation.find_random_song(mood_id)
    recommendation_output << "I recommend the song #{random_rec['song_title']} by #{random_rec['artist']}."
  end
end
