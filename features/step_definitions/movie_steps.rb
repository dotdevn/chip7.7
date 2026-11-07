Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then(/^(\d+) seed movies should exist$/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

Then(/^I should see "([^"]*)" before "([^"]*)" in the movie list$/) do |first_title, second_title|
  # Compare the displayed titles, rather than text elsewhere on the page.
  titles = all('#movies > div[id^="movie_"] > p:first-child').map do |element|
    element.text.sub(/\ATitle:\s*/, '')
  end
  expect(titles).to include(first_title, second_title)
  expect(titles.index(first_title)).to be < titles.index(second_title)
end

When(/^I check the following ratings: (.*)$/) do |rating_list|
  rating_list.split(',').each do |rating|
    check(rating.strip)
  end
end

Then(/^I should (not )?see the following movies: (.*)$/) do |no, movie_list|
  within('#movies') do
    movie_list.split(',').each do |title|
      if no
        expect(page).not_to have_content(title.strip)
      else
        expect(page).to have_content(title.strip)
      end
    end
  end
end

Then(/^I should see all the movies$/) do
  # This version of the app renders movie cards, not table rows.
  expect(page).to have_css('#movies > div[id^="movie_"]', count: Movie.count)
  within('#movies') do
    Movie.pluck(:title).each do |title|
      expect(page).to have_content(title)
    end
  end
end

### Utility Steps Just for this assignment.

Then(/^debug$/) do
  # Use this to write "Then debug" in your scenario to open a console.
  require "byebug"
  byebug
  1 # intentionally force debugger context in this method
end

Then(/^debug javascript$/) do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end

Then(/complete the rest of of this scenario/) do
  # This shows you what a basic cucumber scenario looks like.
  # You should leave this block inside movie_steps, but replace
  # the line in your scenarios with the appropriate steps.
  raise "Remove this step from your .feature files"
end
