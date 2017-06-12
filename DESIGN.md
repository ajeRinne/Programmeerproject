# Diagram of frameworks and classes

Classes

  Facebook(fb)
  
    checks if user is registered
    registeres user
    retreives user info
    create instance of current user
    saves info in instance
    create instance of othter user

  
  Database(db)
  
    authenticate user
    log out
    log in
    instanciate database
    instaciate connection
    save user data
    save place data
    save joining users data
    load users added places
    load users joined places
    load places 
    load currentplace info
    load joining users
    
  GooglePlaces(gp)
  
    gets place info
    typeahead
    suggestions
  
  Button
  
    design button
    
  TextField
  
    design text field
  
  TextView
  
   Design text view
   
# Sketches UI and Features

![Overview views](https://user-images.githubusercontent.com/27211421/26952884-a5f7e018-4ca7-11e7-976a-0b643b42c0a9.png)

Views (from left to right, up to down)
  1. Login
  
    checks if user is registered (fb)
    registeres user (fb)
    retreives user info (fb)
    create instance of current user (fb)
    saves info in instance (fb)
    instanciate database (db)
    instanciate connection (db)
    saves user info in database (db)
    logs in user (db)
    segue(facebook ID)-> MyPlaces
    
      
  2. MyPlaces
  
    instaciate connection (db)
    autheticates user with Database class (dp)
    get users added places (db)
    get users joined places (db)
    gets place info (gp)
    typeahead (gp)
    suggestions (gp)
    segue(facebookID, PlaceID)-> CreatePlace
    segue(facebookID, placeID) -> AddPlace
    segue(facebookID) -> Places
    
  3. Places
  
    authenticate user (db)
    instanciate connection (db)
    load places (db)
    segue(facebookID, placeID) -> AddPlace
    
  4. CreatePlace
  
    instanciate connection (db)
    get currentplace info (db)
    save joining users data (db)
    segue(facebookID, placeID) -> AddPlace
  
  5. AddPlace
  
    instanciate connection (db)
    get currentplace info (db)
    save joining users data (db)

# Frameworks and API's

  Firebase

    registration
    login
    authentication
    database

  Google places API

    retreiving place data

  Facebook login API

    registering users
    getting users profile  and picture
    getting users friendlist (not sure)

  #Datasources

  Google places API

    retreiving place data

  Facebook login API

    registering users
    getting users profile  and picture
    getting users friendlist (not sure)

  # Database structure

  Users

    Facebook id primary key (pk)
    Facebook name
    Facebook password

  Places

    place id pk
    users facebook id
    place name
    place time
    place description

  Joining users

    place id pk
    facebook id
    facebook name

