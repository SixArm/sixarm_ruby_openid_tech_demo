# SixArm.com » Ruby » OpenID » Tech demo for programmers

This Ruby OpenID tech demo shows a simple example of authentication using the command line and the ruby-openid gem.

This tech demo is intended for programmers who want to see source code.


## Step 1

Run it:

    ruby begin.rb

What it does:

  * Prompts for the user's OpenID URL, such as "http://alice.myopenid.com"
  * Uses the OpenID gem to begin a connection to the user's OpenID URL.
  * Outputs the OpenID result, which is a URL for the next step.


## Step 2

This step is simply copy/paste between the command line and your browser.

  * You copy/paste the Step 1 output URL into your browser's address bar.
  * Your browser goes to your OpenID server and asks you to sign in.
  * When you sign in, your browser shows a new URL in the address bar.
  * This new URL is your confirmation URL and you copy/paste it in Step 3.


## Step 3

Run it:

    ruby complete.rb

What it does:

  * Prompts for the user's OpenID confirmation URL from Step 2 above.
  * Uses the OpenID gem to verify the sign in and the location.
  * Outputs a message like "Success", "Failure", "Cancel", etc.


## What's next?

If you want to understand more about OpenID source code, we suggest reading the ruby-openid gem's source code because it's well written and has plenty of comments.

If you want to use OpenID in your web application, we suggest learning about OpenID integration with web frameworks and and authentication gems:

  * Rack OpenID gem
  * Devise authentication 
  * OmniAuth OpenID strategy
  * Authlogic using OpenID


## Credits

The Ruby OpenID gem is by JanRain, and it has excellent code with comments and examples. This demo is derived from the gem.

This demo is by Joel Parker Henderson, thanks to the University of California, Berkeley and the University of California, Irvine.

Feedback is welcome. Pull requests are welcome too.
