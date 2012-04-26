#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'

# The OpenID identity verification process most commonly works like this:
#
# * The user enters their OpenID into a field on the consumer's
#    site, and hits a login button.
#
# * The consumer site discovers the user's OpenID provider using
#    the Yadis protocol.
#
# * The consumer site sends the browser a redirect to the OpenID
#    provider.  This is the authentication request as described in
#    the OpenID specification.
#
# * The OpenID provider's site sends the browser a redirect back to
#    the consumer site.  This redirect contains the provider's
#    response to the authentication request.

require 'openid'
require 'openid/store/filesystem'

puts "To use this example, you need an OpenID URL."
puts "For example, http://yourname.myopenid.com"


# <tt>session</tt> keeps track of the user's current authentication
# attempt.  Things like the identity URL, the list of endpoints 
# discovered for that URL, and in case where some endpoints are
# unreachable, the list of endpoints already tried.
#
# This state needs to be held  from Consumer.begin() to 
# Consumer.complete(), but it is only applicable to a single 
# session with a single user agent, and at the end of the 
# authentication process (i.e. when an OP replies with 
# either <tt>id_res</tt>. or <tt>cancel</tt>).
#
# <tt>session</tt> is a dict-like object and we hope your web 
# framework provides you with one of these bound to the user agent.

session = {}


# <tt>store</tt> keeps track of the openid library's relationships
# with servers, i.e. shared secrets (associations) with servers 
# and nonces seen on signed messages.
#
# This information should persist from one session to the next;
# it should not be bound to a particular user-agent; it should
# be private i.e. not readable by other tenants on the system.
#
# <tt>store</tt> is an instance of Store. We use the simple
# file system store and the conventional path tmp/openids.

store = OpenID::Store::Filesystem.new('tmp/openids')  


# The Consumer object keeps track of two types of state:
# the session and the store (as described above).

openid_consumer = OpenID::Consumer.new(session, store)


# <tt>openid_url</tt> is the user's personal OpenID URL.
#
# Typically you get this by add an OpenID login field on your site.
# When an OpenID is entered in that field and the form is submitted,
# it should make a request to the site which includes that OpenID URL.
#
# The field name convention is "openid_url" for browser autofill.

print "What is your OpenID URL? "
openid_url = $stdin.gets.chomp


# We begin using the consumer with the user's OpenID URL.
#
# This returns a CheckID Request object containing the discovered
# information, with a method for building a redirect URL to the
# server, as described later. 
#
# The CheckID Request object may also be used to add extension 
# arguments to the request, using its add_extension_arg method.
#
# If no OpenID server is found, this raises a DiscoveryFailure.

begin
  checkid_request = openid_consumer.begin openid_url
  puts "Success"
rescue OpenID::DiscoveryFailure
  puts "Discovery failure for url #{openid_url}"
  exit 0
end

# <tt>realm</tt> is the URL (or URL pattern) that identifies
# your web site to the user when he or she is authorizing it. 
# The realm is typically the homepage URL of your site.
#
# In older versions of OpenID, the realm is called "trust root".

realm = "http://sixarm.com"


# <tt>return_to</tt> is the URL that the OpenID server will send 
# the user back to after attempting to verify his or her identity. 

return_to = "http://sixarm.com/return"


# Next, you call the redirect_url method on the CheckIDRequest object.  
#
# Returns a URL with an encoded OpenID request. The URL is the OpenID 
# provider's endpoint URL with parameters appended as query arguments.  
# You should redirect the user agent to this URL.
#
# OpenID 2.0 endpoints can also accept POST requests.

url = checkid_request.redirect_url(realm, return_to)

p "To see OpenID work, you can copy/paste this URL into your browser:"
p url

# We then redirect the user to the resulting URL where the user logs 
# in to their OpenID server, authorises your verification request and
# is (normally) redirected to return URL you provided.
#
# When the user is redirected back to your application, the server 
# will append information about the response in the query string,
# which the OpenID library will unpack.
#
# These next steps are done in the other program in this directory.

