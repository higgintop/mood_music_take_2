# mood_music

NSS Cohort 8 Ruby capstone project

# Project Vision
This is a simple command line program written in Ruby.
The program will recommend a song based
on the mood category they choose.

## Usage
  * Run `rake bootstrap_database` to setup your local database
  * Then , `./mood_music manage` to manage the list of song
    recommendations
# Features

## Adding a song recommendation
```
  > ./mood_music manage
  1. Add song recommendation
  2. List song recommendations
  3. Exit
  > 1
  What is song title?
  > Elephant
  Who is artist of song?
  > Tame Impala
  How would you classify the feel of this song?
  1. happy
  2. sad
  3. mellow
  4. angry
  > 1
  Your song recommendation has been saved.
  ```
Acceptance Criteria:
* Confirmation that entry has been saved to database
* There are three questions asked


## Editing a song recommendation
```
  > ./mood_music manage
  1. Add song recommendation
  2. List song recommendations
  3. Exit
  > 2
  What category would you like to see?
  1. happy
  2. sad
  3. mellow
  4. angry
  > 1
  1. Elephant by Tame Impala
  2. Tangerine by Led Zeppelin
  > 1
  What would you like to do:
  1. Edit recommendation
  2. Delete recommendation
  > 1
  Update song title? [y/n]
  > n
  Update song's artist? [y/n]
  > n
  Update mood category? [y/n]
  > y
   How would you classify the feel of this song?
  1. happy
  2. sad
  3. mellow
  4. angry
  > 4
  Your song recommendation has been saved.
 ```
Acceptance Criteria:
* Confirmation that entry has been edited successfully
* When user lists entries and then enters the corresponding entry
  number, user is prompted about whether they want to edit
* In edit mode, all 3 questions will be asked regardless of a yes/no
  answer

## Deleting a song recommendation
```
  > ./mood_music manage
  1. Add song recommendation
  2. List song recommendations
  3. Exit
  > 2
  What category would you like to see?
  1. happy
  2. sad
  3. mellow
  4. angry
  > 1
  1. Elephant by Tame Impala
  2. Tangerine by Led Zeppelin
  > 2
  What would you like to do:
  1. Edit recommendation
  2.  Delete recommendation
  > 2
  Your song recommendation has been deleted.
```
* When user lists entries and then enters the corresponding entry
  number, user is prompted with sub-menu asking whether they want to
  edit or delete
## Viewing list of song recommendations

If no data/recommendations exist in database:

```
  > ./mood_music manage
  1. Add song recommendation
  2. List song recommendations
  3. Exit
  > 2
  No recommendations found.
  ```

Otherwise:

```
  > ./mood_music manage
  1. Add song recommendation
  2. List song recommendations
  3. Exit
  > 2
  What category would you like to see?
  1. happy
  2. sad
  3. mellow
  4. angry
  > 1
  1. Elephant by Tame Impala
  2. Tangerine by Led Zeppelin

```

## Getting a recommendation
```
  > ./mood_music recommend
  What is your mood today?
  1. happy
  2. sad
  3. mellow
  4. angry
  > 1
  I recommend the song Elephant by Tame Impala based on your happy mood.
```

## User stories

As a user I can select current mood and a song will be recommended to
me.

As a user I can get a listing of all songs currently in the database.

As a user I can edit a song recommendation

As a user I can delete a song from the database

As a user I can create a new song recommendation

