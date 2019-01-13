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
    - /reviews/:id/edit 

### Logic
- seed db for testing
- Generate session key
- ~~add link to movie page from /movies~~
- ~~add link to movie page from /user/:id review~~
- ~~add form to delete review from /user/:id review~~
- ~~add form to edit review from /user/:id review~~
- ~~add link to user page from /movies/:id review (review by: user)~~
- ~~add form to delete review from /movie/:id review~~
- ~~add form to edit review from /movie/:id review~~
- ~~Inform user when invalid login~~
- ~~Inform user when invalid signup~~
- ~~Inform user when invalid review~~
- ~~Inform user when invalid movie~~

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