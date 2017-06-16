# README #

This is a little Sinatra app to post email addresses to Mailerlite (who don't allow client-side access to their API).

### What is this repository for? ###

* Accepts Jquery.ajax POST submissions from whitelisted urls
* Takes the email address supplied and subscribes this to the Henrietta Hotel list
* Returns the status received from Mailerlite.

### How do I get set up? ###

* Clone the repo
* ```bundle install```
* ```rackup -s thin```

### How to contribute ###

Create a new branch:

``` git branch <your-branch-name> ```
``` git checkout <your-branch-name> ```

Then when you are ready to push your branch:

``` git fetch origin master ```
``` git pull origin master ```
``` git rebase master ```

(fix any conflicts)

``` git push origin <your-branch-name> ```

Then open a Pull Request in Bitbucket.

