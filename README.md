# CrowdlabChallenge

This was the coding challenge I submited to join Crowdlab back in Feb 2015.

I'd probably do things a bit differently now, of course.  More thorough coding standards, fewer (no?) comments, that sort of thing.

I also have learned that TDD is more about ensuring separation of concerns, single responsibility, and therefore making the app testable.  The automated regression testing that you get out of it is a very nice bonus.

Here's my original notes regarding this project, written in 2015.
-----------------------------------
So here's my stab at the Crowdlab Coding Challenge.

I thought at first I was being a little OCD about using TDD everywhere.  As time has gone on, I realise that in creating this challenge, I only put 44 tests in place.  considering I'm testing database functionality, UI factors, and basic logic, that's almost nothing.  I have no testing for constraint viability, and that probably took as long as anything else.

Several times, when I changed direction the tests brought me back on the right path.

Overview
========

The app delivered here is broken into distinct groups:

Crowdlab Coding Challenge
-------------------------
Data Models - the data model itself, the generated classes, and the categories to go with them.

Images.xcassets - the image catalog.  I'm not going to make much of this in this demo.

View Controllers - the visible part of the app, the view controllers should be fairly self-explanatory.  Note that I purposely chose individual .xib files over Storyboards, as it is /much/ easier to create, manipulate, and test Viewcontrollers as .xibs.  If you use Storyboards, you can still do it, except there's a bit more boilerplate to instantiate the ViewController (http://iosunittesting.com/using-storyboards/).  That and the unbelievable pain of trying to merge Storyboard files with multiple developers has turned me way off storyboards.

Crowdlab Coding ChallengeTests
------------------------------
Each view has its own tests, as well as TaskFetcher and I've also broken the database tests out as a separate file.

Weaknesses of this Challenge
============================
1) The sample data is perfect.  That's great in a production machine.  It's horrible for testing.  I've created two different tests (empty) and (broken) for input data.  That's not adequate, though.  The test data should contain type mismatches, mispellings, omitted attributes, questions without options, tasks without questions, null values, repeated IDs, etc, and the code should "just" handle this.  Of course, that's beyond the scope of this project...just thought I'd mention it.  In future challenges, perhaps there should be a perfect data file and a rubbish data file to break tests and code upon?
2) The instructions suggest that 'Option' be treated as a UITextView.  That's all well, and good, but that implies that the answer is stored.  Then it occurs that the option table is a template that might be used by another user, not necessarily the user using the device.  That would suggest that we need another table (answer, perhaps), with the fields "user, option, answer" (as well as the user table, along with its registration screens, etc).  The answer would only appear in the option if both the user who answered the option and the particular option are shown on the screen.

    <ahem>  Adding two more table and a few screens for entering data for them seemed slightly far afield for the purposes of a demo.  I don't see much point in creating a bunch of other entities, and then storing them and then linking them..so I've punted here and put the answer in with the option table.  Good enough for government work, but obviously not good enough for a production app.
3) I understand that a task can have multiple questions. Questions can have multiple options.  In the case of this sample data, we don't. Each question has a single option. Since there's only every one option per question, forcing the user to click through to an option is a wasted step I'd rather not do.  Of course, if this isn't a valid assumption then when a question could have many options, then it would make sense for the user to click through.

Future Directions
=================
1) As mentioned in 2 above, there are apparently needs for more tables, more data, (and the classes and tests to go along with them).
2) I'd also want to consider how options are provided, what they do, and how they are presented on the screen.  The instructions suggest that for this challenge options are UITextViews.  Fair enough.  In the real world, I expect there's an appreciable number of different types of options, and we'd have to consider handling more than one option per question.
3) I'd want to seriously beef up the garbage detection in the database handling and the JSON conversion.  No data should be trusted (either from ourselves, or from the server) as cruft will sneak in. That part of the app should simply shrug when garbage comes down.

Mistakes I made
===============
1) One weakness in this design is the error handling for when inserting an object into Core Data.  If there's an error (or already more than one object with the same id) an error should be flagged...but there's no way currently to pass the error back.  That's smelly.
2) Come to think of it, there were a few places where we could return a reference or an error.  I'm getting a powerful smell from that now.
3) The concept of throwing JSON into a table and then reading it back on a few table view controllers seemed so easy, I was going to ramp it up a bit, and allow the user to enter the URL of another input file.  This was a mistake, as I didn't appreciate how the TDD aspect would slow me down for this first effort.  To keep things simple, I sort of bailed on the idea of remote JSON.  I'm sure the code is not a million miles away from being able to do it...I just didn't build that in.
4) I was thrown enough while building out the database functions that I messed up on the TDD methodology.  I did a few tests with the database, but no where near enough.  Then that threw me enough that I didn't really do the TackViewController with TDD. I just wanted to see first results in the simulator. I need to take it out and do it with TDD methodology. EDIT: since I'd already written it the night before and knew what I'd had in mind, this took all of about 20 minutes.

Just to document branching...this line is inserted in the master branch, and I'm going to end up merging the NewTaskView branch into the master once done.

The current repo history looks like this:
* 7b0ba4b Added updates to support viewing and editting the answer for a given option.
* d9f2cc2 This is a version with the option viewer as simply another table.
*   23e322e Merge branch 'NewTaskView'
|\
| * 83298e6 Rebuilt the TaskViewController, being TDD driven while doing so.
| * 7f3646f Put in some very important thoughts into the Overview.
* | 8be29b6 Added a line to overview to demonstrate branching/merging.
|/
* 8c847e1 First data visible in the task screen.
* b9e4793 First decent level.
* 16e8600 Initial Commit

