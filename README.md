iOS app which enables users to find nearest Electric Vehicle chargers in India.
Link : 
https://itunes.apple.com/us/app/re-charge/id1088549964?mt=8

The app uses Google Map SDK, Location Services, REST APIs, SqlLite Database. 
App supports offline use, without internet connection.

The new version uses Firebase API's which - which meant more 'online' features like real time comments comments, photos, notifications etc.
Also a Firebase Cloud function is used to trigger emails to admins on Database entry.

![alt text](https://image.ibb.co/iUQC5f/tour1.png)
![alt text](https://image.ibb.co/gPQC5f/tour4.png)


********************************************************************************
The codebase is organized into the following folders
********************************************************************************

Resources-iPad 		- iPad related UI 
Resources-iPhone 	- iPhone related UI 
Classes             - Core app code
Common              - Common classes
FMDB                - Classes to interact with local SQLite DB (if applicable)
Service             - Classes that talk to remote services
ThirdParty          - Name implies it
Views               - UI related files    
OtherFiles          - Contain Misc files
Images              - Collection of Images used

Have a nice day :)


## Release History

* 0.1 Initial release, template skeleton.

1. Xcode Project included

2. Basic Login Screen

3. Home Screen

4. Left Navigation menu with custom cells

5. Google Map SDK integration.  POD data not included.  PodFile available.

6. Sample data load from remote server on Home screen (needs Internet)

7. Basic wrappers to get/put data into SQLlite database  (using FMDB)

8. Data flow (one way) View --> Presenter --> Manager --> Service

9. Third Party libraries - Rights reserved by respective owners
    a) FMDB
    b) AFNetworking
    c) SSKeychain
    d) Reachability
    