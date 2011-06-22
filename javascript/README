Quick and dirty split tests for Javascript
by: Robby Macdonell

- note: you need to be using Google Analytics to see the results of these tests

Usage:
In the head of your document:

<script type="text/javascript" src="path/to/split_test.js"></script>

Define a test:
<script type="text/javascript">
	var my_test = new SplitTest('my_test', ['control', 'variation1', 'variation2']);
</script>

Get a test variation:
my_test.get_variation();

Show content conditionally:
Conditional content in javascript is tricky. There are a bunch of different ways to handle it. Here's one strategy that's pretty simple:

1. Give all elements that you want to display conditionally a classname matching the variation name.
  <div class="control-content">
    ... control content here ...
  </div>
  <div class="variation1-content">
    ... variation one content here ...
  </div>
  <div class="variation2-content">
    ... variation two content here ...
  </div>

2. Hide them ALL by default with CSS:
  <style>
    .control-content, 
    .variation1-content, 
    .variation2-content { 
	    display: none; 
	  }
	
    body.control .control-content, 
    body.variation1 .variation1-content, 
    body.variation2 .variation2-content { 
	    display: block; 
	  }
  </style>

3. Add the name of the current variation as a body class when the page loads:

// note: there's 1000 ways to do this. 
// if using jquery, this can be placed in a $(document).ready() call instead of window.onload.
window.onload = function() {
	document.getElementsByTagName('body')[0].className = my_test.get_variation();
}

That should cause only the content from the active variation to show up.


Track the split as a custom variable in Google Analytics:

// track this variable in Google Analytics slot #3
page_test.track_with_google_analytics(3);


To review the results in Google Analytics:
Go to: Content -> Custom Variables -> look for your test name
   - You'll be able to see site-wide metrics like time on site, bounce rate, pageviews, etc
   - You'll be able to see ecommerce data if you have that set up.
   
To track more page specific actions, read up on Goals in Google Analytics.
