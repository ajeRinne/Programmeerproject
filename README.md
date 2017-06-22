# Programmeerproject

Project

programmeer project Meet @pp

# Description

‘Meet @pp’ allows users to create an event to go to a place they have always wanted to go or just like to go anytime soon. The app uses the Facebook API to login and register users as well as getting their public profile. Besides the Facebook login API to get the users info and friend list. (https://developers.facebook.com/docs/facebook-login/ios) the app uses the Google places API (https://developers.google.com/places/) to look up the places and their info. All the user and place info and authentication will be done with firebase in order to allow the use of the app offline as well as online. Once the user has created an event, other people can join him to go to the particular place meet new people. 

# Storage

The user data will be stored in an online database using firebase. This database will consist out of three tables: the users table, the places table and the joining users table. In the users table the primary key is the user’s Facebook ID. This ID as well as the Facebook name will also be linked to the place table. Also this table has an ID as primary key and contains all the data retrieved from Google Places the API. The joining users table contains the place ID referring to the place in the places table and the user ID referring to the user in the users table.

# Usage

The app will consist out of six views. The first view is the login view that allows the user to log in with Facebook and if they are not registered yet it will register trough Facebook. This view will only appear if the user has logged out or if the user hasn’t registered yet. The next view is the ‘my places’ view that shows a search bar and a table view displaying the placed added by the user or attended by the user. If the user clicks on one of the places, he will be directed to the place view, showing a picture of the place, all the details about the place event as well as the users that join the event with their profile pictures.

When the user types the search field in the ‘my places’ view he will see get a list of the ‘type ahead’ options from Google Places. When the user clicks on one of these suggestions, he will be directed to the ‘add place’ view. This view will display a picture of the place and contains text fields to enter the date and time of the event as well as a description of the event. The user can then add the event and will be redirected to the ‘my places’ view. The event will be added to the places table and will be displayed in the ‘my places’ table view of the user.

When the user clicks on the ‘friends places’ button on the ‘my places’ view, he will be directed to the ‘friends places’ view. This will display a table view containing all the places added by friends. You can click on this place and go to the ‘place event’ view, that contains the place picture, an added by user label, the date, time and event description. Underneath this info a table is displayed with all the users that join the event with their profile pictures and name. On the navigation bar a ‘join’ button is displayed. When the user clicks on this button, he will be added to the ‘joining users’ table and will be displayed in the ‘joining users table on the ‘place event’ page. The user will be redirected to the ‘search place’ view. When a user clicks on a place in this view, he will again be directed to the ‘place event’ view.

# Possible difficulties

The biggest risk in the project is the use of two API’s. Though they can be very helpful, they might cause problems with implementation and risk making the app more buggy.

# Comparison to Facebook

Though not a lot of apps are like this, the ‘event’ functionality of the Facebook app is a lot like it. This places the event central and allows the user to add details to it. The user can invite his friends to the app. As ‘meet @pp’ is more of a social app all of the user’s friends can join the event.

# Minimal Viable Product

The MVP of the app is the functionality without the API’s. On this way the user can just fill in a place where he wants to go and subsequently other users can join him by clicking on the event. This way a user can register with an alert that asks for a username and password and uploads it to firebase.

App Visualisation
![App overview](https://github.com/ajeRinne/Project/issues/1)


# June 6: Inventing the app

Spended most of the time thinking different ideas over and thinking this one trough. Descided which features were reasonable and which ones would take to much work. Started to work on the interface.

# June 7: Setting up the frame

Spended some thime thinking the app over. Descided which screens i would implement and how and where the data would be saved. 

# June 8: Fixing the prototype

Fixed some bugs in the interface. Finished the prototype. Thought the backend trough.

# June 13: Researching API's

Looked into the functionality of the API's required for the ap and started to work with the facebook API. Fixed some missing functionality in the prototype.

# June 14: Implementing Facebook login

Used the FBSDK API to let users login throuw facebook. Spended a lot of time to fix a but that stopped segue's from being triggered after the facebook login screen popped up. Made the structs that create the instances for uploading data into firebase.

# June 15: Implementing firebase

Firebase configuration works. Users can log in using facebook, their personal profile is loaded, they log into firebase with a credential received from facebook. Started on the maps API.

# June 18: Retreiving all the data from Google Map

Plan:

Showing the map
Retreiving the mapsdata when you click on a marker
Adding the maps data to firebase
Adding the data from google maps in hte createPlace view and addPlace view

fixed: 

map shows on screen

# June 19: Getting the facebook data
Plan:

Showing the facebook data in the fields
Adding the maps data to the fields

fixt:

Placepicker installed and working
Place create controller shows data on screen

# June 20: Completing the maps view

Plan:

Adding the markers of other place events to the view.
Letting other users select your places and adding them to the myPlaces view
Showing your places in the myPlaces view.
Attatching the app to phone

fixed:

firebase upload place item

![Overview views](https://user-images.githubusercontent.com/27211421/26952884-a5f7e018-4ca7-11e7-976a-0b643b42c0a9.png)
