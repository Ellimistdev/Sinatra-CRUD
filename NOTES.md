<!-- Movie review application

## Models
#### user  
> has many reviews  
has a secure password  
is unique  
attr: username  
attr: email  
attr: password         

#### movie  
> has many reviews  
is unique  
attr: name  

#### review  
> belongs to user  
belongs to movie  
attr: content  
attr: rating  
foreign_key: movie_id  
foreign_key: user_id  

## Controllers

application  
>- '/'  
    - shows index

user  
>- get '/signup'   
    - shows user/signup  
>- get '/login'  
    - shows user/login
>- post '/logout'  
    - clear session  
    - redirect to /

movie
>-  get '/movies/:id'  
    - shows movie/show  
>- get '/movies/new'  
    - shows movie/new  
>- post '/movies  
    - create new movie  
    - redirect movie/:id  

review
>- get '/reviews/:id'  
    - shows reviews/show  
>- get '/reviews/:id/edit'  
    - shows reviews/edit  
>- get '/reviews/new'  
    - shows reviews/new  
>- patch '/reviews/:id  
    - updates reviews with id == :id  
    - redirect '/reviews/:id'  
>- post 'reviews'  
    - creates new review  
    - redirect '/reviews/:id'  
>- delete '/reviews/:id/delete'  
    - deletes review with id == :id  

## Views
>- index  
    - show latest reviews  
    - show registration?  
>- user  
    - action: create new user  
    - view > see all reviews    
>- movie    
    - show.erb > see all reviews for this movie  
    - new.erb > action: create movie > post to /movies
>- review  
    - show.erb > action: delete review if owner > delete to /reviews/:id/delete  
    - link_to: /reviews/:id/edit if owner  
    - edit.erb > action: update review if owner > patch to /reviews/:id  
    - new.erb > action: create review > post to /reviews
-->
## TODO: 
### Style/Copy
- Write Readme  
- Complete User page
- Complete Movies page    
- Complete Movie page
- Write Welcome message
- Add form labels
    - /signup
    - /login
    - /movies/new
    - /movies/:id new review form

### Logic
- seed db for testing
- ~~add link to movie page from /movies~~
- add link to movie page from /user/:id review
- add form to delete review from /user/:id review
- add form to edit review from /user/:id review
- ~~add link to user page from /movies/:id review (review by: user)~~
- ~~add form to delete review from /movie/:id review~~
- ~~add form to edit review from /movie/:id review~~
- Inform user when invalid login
- Inform user when invalid signup
- Inform user when invalid review
- Inform user when invalid movie
- Generate session key

### New Tests:
- ~~link to individual movie page is present on /movies~~
- ~~link to individual movie page is present on /user/:id review~~
- ~~when logged in~~
    - ~~review owned by user~~
      - ~~edit~~
        - ~~link to edit review is present on /movie/:id review~~ 
        - ~~link to edit review is present on /user/:id review~~ 
        - ~~user can edit review via /movie/:id review~~
        - ~~user can edit review via /user/:id review~~
      - ~~delete~~
        - ~~link to delete review is present on /movie/:id review~~
        - ~~link to delete review is present on /user/:id review~~
        - ~~user can delete review via /movie/:id review~~ 
        - ~~user can delete review via /user/:id review~~ 
    - ~~not owned~~
      - ~~edit~~
        - ~~link to edit review is not present on /movie/:id review~~
        - ~~link to edit review is not present on /user/:id review~~
        - ~~user can not edit review via /movie/:id review~~
        - ~~user can not edit review via /user/:id review~~
      - ~~delete~~
        - ~~link to delete review is not present on /movie/:id review~~
        - ~~link to delete review is not present on /user/:id review~~
        - ~~user can not delete review via /movie/:id review~~
        - ~~user can not delete review via /user/:id review~~
- ~~Inform user when invalid login~~
- ~~Inform user when invalid signup~~
- ~~Inform user when invalid review~~
- ~~Inform user when invalid movie~~

### Clean Up:
- del NOTES.md
- del unused views
- del unused specs