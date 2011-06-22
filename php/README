Quick and dirty split tests for PHP
by: Robby Macdonell

- note: you need to be using Google Analytics to see the results of these tests

Usage:
require_once('path/to/split-test.php');

Define a test:
<?php
  $splitVariation = SplitTest::split('my_test', array('control', 'variation1', 'variation2'));
?>

Get a test variation:
<?php SplitTest::getVariation('my_test') ?>

Show content conditionally:
<?php if ($splitVariation == 'variation1'): ?>

  <h3>You're looking at Variation One! Use the links below to switch.</h3>

<?php elseif ($splitVariation == 'variation2'): ?>

  <p>This is variation two. Click below to see the others.</p>

<?php else: ?>

  <p>This is the control variation. Use the links below to see the other variations.</p>

<?php endif; ?>

Track the split as a custom variable in Google Analytics:
<?php echo SplitTest::trackWithGoogleAnalytics('my_test', 1); ?>


To review the results in Google Analytics:
Go to: Content -> Custom Variables -> look for your test name
   - You'll be able to see site-wide metrics like time on site, bounce rate, pageviews, etc
   - You'll be able to see ecommerce data if you have that set up.
   
To track more page specific actions, read up on Goals in Google Analytics.