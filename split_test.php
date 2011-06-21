<?php 

class SplitTest {
  
  static private $_splitTestData = array();
  
  /*
   * Simple split test function
   * @arguments:
   *  - $testname = the name of your test
   *  - $variations = an array of variation names that will be evenly split 
   *  - $user_id = an integer that can be used as an identifier for the user.
   *    If this is provided, the splits will be based off the user-id instead of a random number.
   *    This will allow your users to see the same variation on multiple browsers.
   * @return a variation name
   * use the function trackWithGoogleAnalytics() to log the data to google analytics.
   */
   
  public static function split($testname, $variations = array('control'), $user_id = null) {
    $current_variation = null;
    
    if (isset(self::$_splitTestData[$testname])) {
      // if the test variation was set earlier in the same request, return that
      $current_variation = self::$_splitTestData[$testname];
    } else {
      // allow querystring enabling of features
      if (isset($_REQUEST[$testname]) && in_array($_REQUEST[$testname], $variations)) {
        $current_variation = $_REQUEST[$testname];
      } else if (isset($_COOKIE['split_' . $testname]) && !empty($_COOKIE['split_' . $testname]) && in_array($_COOKIE['split_' . $testname], $variations)) {
        // we've got a variation already set from a previous request
        $current_variation = $_COOKIE['split_' . $testname];
      } else {
        // need to set a variation, use the user id if available
        if ($user_id != null && count($variations) > 0) {
          $current_variation = $variations[($user_id % count($variations))];
        } else {
          $current_variation = $variations[array_rand($variations)];
		    }
      }
      
      // the next two lines should only happen once per request.
      // set (or reset) a short-lived cookie so we don't have to worry about cleaning up old tests
      // when the test code is pulled out, the cookie will expire shortly thereafter
      setcookie('split_' . $testname, $current_variation, time() + (60 * 60 * 24 * 14), '/');
      
      // store the value in case it's needed later in this request
      self::$_splitTestData[$testname] = $current_variation;
    }
    
    // return the current variation
    return $current_variation;
  }
  
  /*
   *  get the current variation for a specific test.
   */ 
  public static function getVariation($testname) {
	if (isset(self::$_splitTestData[$testname])) {
    	return self::$_splitTestData[$testname];  
    } else if (isset($_COOKIE['split_' . $testname]) && !empty($_COOKIE['split_' . $testname])) {
	    return $_COOKIE['split_' . $testname];
    }
    return null;
  }

  /*
   *  Spit out a string that Google Analytics can use to track the visitor
	 *  @arguments
	 *   - $testname: the name of the test you want to track
	 *   - $slotNumber: the slot in Google Analytics you want to use
	 *     (You should understand how Google Analytics custom variables work before using this function.)
   *  @return a google analytics tracking event string
   */
  public static function trackWithGoogleAnalytics($testname, $slotNumber = 1) {
    $gaTrackingSnippet = '';
    if (isset(self::$_splitTestData[$testname])) {
      $gaTrackingSnippet = '<script type="text/javascript"> var _gaq = _gaq || []; _gaq.push(["_setCustomVar", '. $slotNumber .', "ab_' .  $testname . '", "' . self::$_splitTestData[$testname] . '", 1]); </script>';  
    }
    return $gaTrackingSnippet;
  }
  
}
