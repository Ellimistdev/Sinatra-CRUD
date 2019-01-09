Movie review application

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




