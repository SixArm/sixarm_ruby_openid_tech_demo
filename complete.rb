#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

##
# OpenID demo using the simplest way of authenticating.
#command line

require 'rubygems'

# The OpenID identity verification process, continued.
# Please see the other program in this directory for details.

require 'openid'
require 'openid/store/filesystem'
session = {}
store = OpenID::Store::Filesystem.new('tmp/openids')  
openid_consumer = OpenID::Consumer.new(session, store)

# We then redirect the user to the resulting URL where the user logs 
# in to their OpenID server, authorises your verification request and
# is (normally) redirected to return URL you provided.
#
# When the user is redirected back to your application, the server 
# will append information about the response in the query string,
# which the OpenID library will unpack.


# <tt>current_url</tt>: Get the URL of the current request from 
# your application's web request framework; this library with check 
# it against the openid.return_to value in the response.  Do not just
# pass <tt>args['openid.return_to']</tt> here; that will defeat the
# purpose of this check.  (See OpenID Authentication 2.0 section 11.1.)

print "What is the OpenID server's reply, i.e. the current URL in your web browser? "
current_url = $stdin.gets.chomp


# <tt>query</tt>: A hash of the query parameters for this HTTP request.
# Note that in Rails, this is <b>not</b> <tt>params</tt> but rather
# <tt>params.reject{|k,v|request.path_parameters[k]}</tt> because
# the <tt>controller</tt>, <tt>action</tt>, and other "path parameters"
# are included in params.
#
# Example <tt>current_url</tt>:
#
#     http://example.com/foo/bar?name=alice&color=red
#
# Example <tt>query_string</tt>:
#
#    name=alice&color=red
#
# Note: Ruby's CGI parse method returns a hash of key value pairs
# where each value is an array, whereas this OpenID library needs
# each value to be a string. So we need to change each
# value from an array of one item to just a string; we use do this in
 
query = CGI::parse(current_url).inject({}) { |h,(k,v)| h[k] = v.first; h }


# The Consumer #complete method is alled to interpret the server's 
# response to an OpenID request; parameters are query and current_url.
#
# Returns a subclass of Response:
#
#   * SuccessReponse
#   * CancelReponses
#   * FailureResponse
#   * SetupNeededReponse
#
# The subclass type of response is indicated by the status attribute, 
# which will be one of SUCCESS, CANCEL, FAILURE, or SETUP_NEEDED.
#
# If the return_to URL check fails, the status of the completion 
# will be FAILURE.

response = openid_consumer.complete(query, current_url)


# Handle the response.
#
# For this simple demo we simply print a message and some diagnostics.
#
# A typical Rails web application would set up the <code>session</code>,
# make the <code>current_user</code> return the user's ActiveRecord object,
# and redirect the user's browser to the start page of the web application.

case response.status
when OpenID::Consumer::SUCCESS
  session[:openid] = response.identity_url
  puts "Success. The user is signed in."
when OpenID::Consumer::CANCEL
  puts "Cancel."
when OpenID::Consumer::FAILURE
  puts "Failure."
  puts "endpoint: #{response.endpoint||'?'}" 
  puts "message: #{response.message}"
  puts "contact: #{response.contact}" if response.contact
  puts "reference: #{reference}" if response.reference
when OpenID::Consumer::SETUP_NEEDED
  puts "Setup Needed."
end
