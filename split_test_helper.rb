# Quick and dirty split tests for rails 3
# see README.rails for documentation

module SplitTestHelper

  SplitData = {}
  
  # set up a split test, give it a name, some variations, and optionally a unique numeric identifier for the visitor
  def split_test(test_name, variations = ['control'], user_id = nil)
    return SplitTestHelper::SplitData[test_name] unless SplitTestHelper::SplitData[test_name].nil?
    
    if !params[test_name].nil? && variations.include?(params[test_name])
      current_variation = params[test_name]
		elsif !cookies["split_#{test_name}"].blank? && variations.include?(cookies["split_#{test_name}"])
		  current_variation = cookies["split_#{test_name}"]
	  else
	    if !user_id.nil? && user_id.is_a?(Integer)
	      current_variation = variations[ user_id.modulo(variations.length) ]
	    else
	      current_variation = variations.sample
      end
    end
    cookies["split_#{test_name}"] = { :value => current_variation, :expires => 2.weeks.from_now, :domain => '/' }
  
    SplitTestHelper::SplitData[test_name] = current_variation

    current_variation
  end
  
  #get the split variation
  def get_split_variation(test_name)
    if !SplitTestHelper::SplitData[test_name].nil?
      SplitTestHelper::SplitData[test_name]
    elsif !cookies["split_#{test_name}"].nil?
      cookies["split_#{test_name}"]
    end
  end
  
  # render a block if the visitor is viewing variation_name for test_name
  def has_split_variation?(test_name, variation_name, &block)
    if get_split_variation(test_name) == variation_name
      capture(&block)
    end
  end
  
  # call this in your view before your google analytics tracking snippet
  def track_split_with_google_analytics(test_name, slot_number = 1)
    unless SplitTestHelper::SplitData[test_name].nil?
       "<script type='text/javascript'> var _gaq = _gaq || []; _gaq.push(['_setCustomVar', '#{slot_number}', split_#{test_name}', '#{SplitTestHelper::SplitData[test_name]}', 1]); </script>"
    end
  end
end