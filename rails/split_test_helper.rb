# Quick and dirty split tests for rails
# see https://github.com/robby1066/Quick-and-dirty-split-tests for documentation

module SplitTestHelper
  
  # set up a split test, give it a name, some variations, and optionally a unique numeric identifier for the visitor
  def split_test(test_name, variations = ['control'], user_id = nil)
    
    # create the split_data hash for this user if it doesn't already exist
    session[:split_data] = {} if session[:split_data].nil?
        
    # allow for querystring overrides      
    if !params[test_name].nil? && variations.include?(params[test_name])
      current_variation = params[test_name]
      
		elsif !cookies["split_#{test_name}"].blank? && variations.include?(cookies["split_#{test_name}"])
		  
		  # pull from the cookie
		  current_variation = cookies["split_#{test_name}"]
		  
		  # clear out the session variable since we know the cookie has been set
		  session[:split_data][test_name] = nil
	
		elsif session[:split_data][test_name].present?
		  
		  # get variation from the session if it exists
		  current_variation = session[:split_data][test_name]
		  
	  else  
	    if !user_id.nil? && user_id.is_a?(Integer)
	      current_variation = variations[ user_id.modulo(variations.length) ]
	    else
	      current_variation = variations.sample
      end
    end
    
    # store in cookie and session (session is so we can test later in this request)
    cookies["split_#{test_name}"] = { :value => current_variation, :expires => 2.weeks.from_now }
    session[:split_data][test_name] = current_variation
    
    #return current variation
    current_variation
  end
  
  #get the split variation
  def get_split_variation(test_name)
    if !cookies["split_#{test_name}"].nil?
      cookies["split_#{test_name}"]
    elsif !session[:split_data].nil? && !session[:split_data][test_name].nil?
      session[:split_data][test_name]
    end
  end
  
  # call this in your view before your google analytics tracking snippet
  def track_split_with_google_analytics(test_name, slot_number = 1)
    current_variation = get_split_variation(test_name)
    unless current_variation.nil?
       "<script type='text/javascript'> var _gaq = _gaq || []; _gaq.push(['_setCustomVar', #{slot_number}, 'split_#{test_name}', '#{current_variation}', 1]); </script>"
    end
  end
  
  # track with kissmetrics
  def track_split_with_kissmetrics(test_name)
    current_variation = get_split_variation(test_name)
    unless current_variation.nil?
      "<script>_kmq.push(['set', {'split_#{test_name}': '#{current_variation}'}]);</script>"
    end
  end
end