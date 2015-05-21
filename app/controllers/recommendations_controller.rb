#!/usr/bin/env ruby


class RecommendationsController

  def index(category)
    if Recommendation.count_by_mood(category) > 0
      recommendations = Recommendation.by_mood(category)
      rec_str = ""
      recommendations.each_with_index do |rec, index|
        rec_str << "#{index + 1}. #{rec[0]} by #{rec[1]}\n"
      end
      rec_str
    else
      "No recommendations found.\n"
    end
  end


  def get_selection(category, user_selection)
    if Recommendation.count_by_mood(category) > 0
      recommendations = Recommendation.by_mood(category)
      recommendations[user_selection-1]
    else
      nil
    end
  end


  def add_row(song_title, artist, mood_category)
    song_title_clean = song_title.strip
    artist_clean = artist.strip

    rec = Recommendation.new
    rec.song_title = song_title_clean
    rec.artist = artist_clean
    rec.mood_category = mood_category

    if rec.save
      return "valid"
    else
      rec.errors
    end
  end

  def update_row(new_song_title, new_artist, new_mood_category, id)
    song_title_clean = new_song_title.strip
    artist_clean = new_artist.strip

    rec = Recommendation.new
    rec.song_title = song_title_clean
    rec.artist = artist_clean
    rec.mood_category = new_mood_category

    if rec.update(id)
      return "valid"
    else
      rec.errors
    end

  end

  def delete_row(id)
    Recommendation.delete(id)
  end

  def is_property_valid?(property)
    rec = Recommendation.new
    return rec.valid?(property)
  end

  def find_recommendation(category_name)
    recommendation_output = ""
    random_rec = Recommendation.find_random_song(category_name)
    recommendation_output << "I recommend the song #{random_rec['song_title']} by #{random_rec['artist']}."
  end


  def list_mood_categories_menu
    choose do |sub_menu|
      sub_menu.prompt=""
      puts "What category would you like to see?"
      sub_menu.choice('happy') do
        response = index('happy')
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection('happy', choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end
        # at this point have a valid selection
        list_action_options(selection['id'])
      end
      sub_menu.choice('sad') do
        response = index('sad')
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection('sad', choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end

        # at this point have a valid selection
        list_action_options(selection['id'])

      end
      sub_menu.choice('mellow') do
        response = index('mellow')
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection('mellow', choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end

        # at this point have a valid selection
        list_action_options(selection['id'])

      end
      sub_menu.choice('angry') do
        response = index('angry')
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection('angry', choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end

        # at this point have a valid selection
        list_action_options(selection['id'])
      end
    end
  end

  def list_action_options(id)

    puts "What would you like to do?"
    choose do |menu|
      menu.prompt = ""

      menu.choice('edit')do
        new_song_title = ""
        new_artist = ""
        new_mood_category = ""
        loop do
          update_song_title = ask("Update song title? [y/n]").upcase
          if update_song_title == 'Y'
            loop do
             new_song_title = ask("Please enter new song title:")
             break if is_property_valid?(new_song_title)
            end
          end
          break if update_song_title == 'Y' or update_song_title == 'N'
        end

        loop do
          update_artist = ask("Update song's artist? [y/n]").upcase
          if update_artist == 'Y'
            loop do
             new_artist = ask("Please enter new artist:")
             break if is_property_valid?(new_artist)
            end
          end
          break if update_artist == 'Y' or update_artist == 'N'
        end

        loop do
          update_mood_category = ask("Update mood category? [y/n]").upcase
          if update_mood_category == 'Y'
            loop do
              new_mood_category = ask("Please enter new mood category:\n1. happy\n2. sad\n3. mellow\n4. angry")
             break if is_property_valid?(new_mood_category)
            end
          end
          break if update_mood_category == 'Y' or update_mood_category == 'N'
        end

        # update unless all options are still blank
        unless new_song_title.empty? and new_artist.empty? and new_mood_category.empty?
          update_row(new_song_title, new_artist, new_mood_category, id)
          puts "Your song recommendation has been saved."
        else
          puts "No changes made."
        end
        list_main_menu
      end
      menu.choice('delete')do
        delete_row(id)
        puts "Your song recommendation has been deleted."
        list_main_menu
      end
      menu.choice('exit'){list_main_menu}
    end
  end

  def list_main_menu
    choose do |menu|
      recommendations_controller = RecommendationsController.new
      menu.prompt = ""
      menu.choice('Add song recommendation') do
        song_title = ""
        artist = ""
        mood_category = ""
        loop do
          song_title = ask("What is the song's title?")
          song_response = recommendations_controller.is_property_valid?(song_title)
          break if song_response
        end

        loop do
          artist = ask("Who is the artist of the song?")
          artist_response = recommendations_controller.is_property_valid?(artist)
          break if artist_response
        end

        loop do
          mood_category = ask("How would you classify the feel of this song?\n1. happy\n2. sad\n3. mellow\n4. angry")
          mood_response = recommendations_controller.is_property_valid?(mood_category)
          break if mood_response
        end

        # save
        added_rec = recommendations_controller.add_row(song_title, artist, mood_category)
        if added_rec == "valid"
          puts "Your recommendation was successfully saved to the database"
        else
          puts "Your recommendation was not saved."
        end
        list_main_menu
      end
      menu.choice('List song recommendations') do
        recommendations_controller.list_mood_categories_menu
        exit
      end
      menu.choice('Exit') do
        say ("Peace Out!")
        exit
      end
    end
  end

end


