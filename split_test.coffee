# bare bones split testing, in javascript!
class window.SplitTest
	current_variation: null
	
	# create an instance of the class with the test name and variations
	# optionally pass in a user-id if you want users to see the same
	# variations across multiple sessions or browsers
	constructor: (@name, @variations = [], user_id = null) ->
		@current_variation =  @get_query_string() || @get_split_cookie()

		if not @current_variation?
			if user_id == null
				# pick a random variation
				@current_variation = @variations[(Math.floor Math.random() * @variations.length)]
			else
				# variation is a mod of user_id and variations length
				@current_variation = @variations[user_id % @variations.length]
		
		right_now = new Date()	
		two_weeks_from_now = new Date(right_now.getTime() + (1000 * 60 * 60 * 24 * 14))
		
		cookie = 'split_'+@name+'='+@current_variation
		cookie += '; expires='+two_weeks_from_now.toGMTString()
		cookie += ',path=/'
		
		document.cookie = cookie
	
	# get the current variation for this visitor		
	get_variation: ->
		@current_variation
	
	# check to see if the visitor is in the variation variation_name	
	has_variation: (variation_name) ->
		@current_variation == variation_name
	
	# track this visitor with a custom variable in Google Analytics
	# this must be done before your main google analytics snippet is called
	track_with_google_analytics: (slot_number) ->
		window._gaq = window._gaq || []
		window._gaq.push(["_setCustomVar", slot_number, @name, @current_variation, 1])
		
	get_split_cookie: ->
		cookies_raw = document.cookie?.split('; ') || []
		for cookie in cookies_raw
			cookie = (cookie.split '=')
			return cookie[1] if cookie[0] == 'split_'+@name
			
	get_query_string: ->
		for query in window.location.search.replace('?','').split '&'
			query = (query.split '=')
			return query[1] if query[0] == @name
				
			