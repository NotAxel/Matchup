# Matchup #

A cross-compatible Super Smash Bros Ultimate Matchmaking service.

## testing strategy document $$
https://docs.google.com/document/d/1QvZtGZR3PCzE3iM-k-qfzkhvzPBWfQeZCFPb8Vx6zY8/edit?usp=sharing

## code coverage report ##
https://drive.google.com/drive/folders/1Ac-K151A7M6a5iAO6YHbC12P8aj9mlXX?usp=sharing

## Acceptance Tests ##
See document for how to run flutter driver tests that serve as acceptance tests
https://docs.google.com/document/d/1QvZtGZR3PCzE3iM-k-qfzkhvzPBWfQeZCFPb8Vx6zY8/edit?usp=sharing
Acceptance criteria: https://docs.google.com/document/d/1rXT-mYxFa7P5AgCAggB8yFHaVm2buM19ksA2qcYQPFE/edit?usp=sharing

## Continuous Integration ##
CI is run using the Travis CI server that runs unit and widget tests
\nTravis CI Server
https://travis-ci.com/github/NotAxel/Matchup/builds

## requirements ##
  * flutter version 1.15.21
  * firebase library
 
## set-up ##
  * follow flutter devs getting started guide: https://flutter.dev/docs/get-started/install
  
  summary of steps
  * install all requirements to system
  * code can be built in Xcode or Android Studio
  * clone code into a directory
  * build using Xcode or Android Studio or launch debug emulator

### style guide ### 
https://dart.dev/guides/language/effective-dart/style

### Static Code Analysis ###
to run:
   flutter analyze lib > static_code_analysis.txt
\nsee static_code_analysis.txt for results
