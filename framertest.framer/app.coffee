module = require "myModule"
# test AMD
module.myFunction()

tokenClient = require "clientID"
# get clientID from module
tk = tokenClient.clientID

# Set background color
Screen.backgroundColor = "#7DDD11"

# Create PageComponent
page = new PageComponent 
	x: Align.center
	y: Align.center	
	width: 300
	borderRadius: 6
	scrollVertical: false

page.style = {
	"font-size": "12px",
	"margin": "10px",
	"padding": "10px"
	"color": "black"
}

# subLayer = new Layer
# 	superLayer: page
# 	style: {
# 		"margin": "40px",
# 		"padding":"40px",
# 		"backgroundColor": "red",
# 		"textAlign": "center",
# 		"verticalAlign": "middle"
# 	}

# Add pages
list = for i in [0...5]
	layer = new Layer 
		parent: page.content
		name: "Page #{i}"
		color: "#000000"
		x: 210 * i
		backgroundColor: "#fff"
		borderRadius: 6
		opacity: .25

# Style current page
page.currentPage.opacity = 1

# Fade in the most centered page
page.onChange "currentPage", ->
	page.previousPage.animate 
		properties:
			opacity: 0.25
		time: 0.5
		
	page.currentPage.animate 
		properties:
			opacity: 1
		time: 0.5

# SPOTIFY app manager
# https://developer.spotify.com/my-applications/#!/applications/669f1e7ebab84e029757fb5d87ffd756

# come from framer native webserver print window.location.href to get url to add to the web api whitelist - this our server running and will be used to loopback when we contact spotify API
redirectUri = window.location.href
# print redirectUri

# Spotify OAuth: https://accounts.spotify.com/authorize
OAuthrequestParams = "response_type=token&client_id=#{tk}&redirect_uri=#{redirectUri}"

# add scope to in the request to ask user whether we can see their email address
scope = "&scope=user-read-email"
spotifyClientrequest = "https://accounts.spotify.com/authorize?#{OAuthrequestParams}#{scope}"
r = new XMLHttpRequest

# We don't have an access token, so we need to authenticate
if window.location.href.indexOf('access_token') == -1
# override current window.location with our request to the api and looping back to our server
	window.location = spotifyClientrequest
# We do have an access token so don't authenticate again
else
	hashElements = window.location.hash.split('&')
	accessToken = hashElements[0].split('=')[1]
	
	# Spotify API endpoints: https://developer.spotify.com/web-api/endpoint-reference/
	r.open 'GET', 'https://api.spotify.com/v1/me', true
	r.responseType = 'json'
	r.setRequestHeader('Authorization', 'Bearer '+ accessToken)	
	r.onreadystatechange = ->
	  if(r.status >= 400)
	    print "Error #{r.status}"
	  if(r.readyState == XMLHttpRequest.DONE && r.status == 200)
	    data = r.response
	    # get data back from the API
	    print data
	    
	    # rerender elements/attributes with response data
	    for layers in list
	    	layers.html = data.email
	    	layers.style = {
	    		"font-size":"12px",
	    		"padding": "10px",
	    		"text-align": "center"
	    		}
    		first = list[0]
    		first.html = "hello"
    		first.style= {
    			"color": "red"
    			"font-weight": "900"
    			"font-size": "2em"
    			}
	    
	r.send()
	
	

