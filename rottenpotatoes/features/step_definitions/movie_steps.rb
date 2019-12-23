# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
	movies_table.hashes.each do |movie|
		Movie.create!(movie)
	end
end

Then /(.*) seed movies should exist/ do | n_seeds |
	Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /the following movies should (not )?show:/ do |no_show, movies_table|
	if no_show
		movies_table.hashes.each do |movie|
			step "I should not see \"#{movie["title"]}\""
		end
	else 
		movies_table.hashes.each do |movie|
			step "I should see \"#{movie["title"]}\""
		end
	end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
	#  ensure that that e1 occurs before e2.
	#  page.body is the entire content of the page as a string.
	page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
	# HINT: use String#split to split up the rating_list, then
	#   iterate over the ratings and reuse the "When I check..." or
	#   "When I uncheck..." steps in lines 89-95 of web_steps.rb
	ratelst = rating_list.split(",")
	if uncheck
		ratelst.each do |rate|
			step "I uncheck \"ratings[#{rate}]\""
		end
	else
		ratelst.each do |rate|
			step "I check \"ratings[#{rate}]\""
		end
	end
end

Then /I should see all the movies/ do
	# Make sure that all the movies in the app are visible in the table
	expect(page).to have_xpath("//*[@id=\"movies\"]/tbody/tr", :count => Movie.count)
end
