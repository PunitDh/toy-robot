# Robot Challenge



## How to Run the Application

- You need to have Ruby and the `bundler` gem install to run the application.
- For Linux, use the commands `sudo apt install ruby-full` and `sudo apt install ruby-bundler` to install the applications
- Navigate to the directory where the application is saved, and run `bundle install`. This will install the `rspec` gem.
- To run the application, simply run command `./bin/toyrobot`
- You may need to modify permissions to run the program using `chmod u+x ./bin/toyrobot`
- To run the tests associated with the application, run `rspec`

## Application ARGV Arguments
- You can also run the application with `ARGV` arguments.
- The three valid arguments are: `grid`, `file`, and `visual`
- To run the application using default values, simply run `./bin/toyrobot`
- The default config values can be found in the file `config/environment.rb`
- To run the application using ARGV arguments
  - Running the application with `./bin/toyrobot grid=5,5` will initialize a 5x5 grid
  - Running the application with `./bin/toyrobot grid=4,6` will initialize a 4x6 grid
  - Running the application with `./bin/toyrobot visual` will initialize the default 5x5 grid and enable a visual representation
  - Running the application with `./bin/toyrobot file=test.txt` will run the program with command input from the file `test.txt`. 

    **Note:** The file must be placed in the root directory
  - You can also run the application with any, all or no arguments. For example, `./bin/toyrobot grid=5x5 visual file=test.txt` will initialize the application with a 5x5 grid, enable visuals and take in commands from a file input

## Commands
The following commands can be given to the application:
- `PLACE`: The PLACE command takes in 3 arguments: x,y,f which correspond to the x,y, positions on the grid (starting with 0,0 on the bottom left), and "f" which refers to "facing". The robot can face "NORTH", "SOUTH", "EAST" or "WEST". For example, `PLACE 1,2,NORTH` will place the robot in the grid position 1,2 facing north
  ```
  > Command: PLACE 1,2,north
  Robot has been placed at position 1,2 facing NORTH
  ```
- `MOVE`: MOVE will move the robot in the direction it is facing. If it reaches the edge of the board, it will be unable to move further.
  ```
  > Command: MOVE
  Robot has moved 1 step NORTH and is at position 1,3
  ```
- `LEFT` and `RIGHT`: The LEFT and RIGHT commands will rotate the robot either to the left or right. If the direction is NORTH, LEFT will face the robot to the WEST, while RIGHT will face the robot to the EAST.
  ```
  > Command: RIGHT
  Robot is now facing EAST
  ```
- `REPORT`: REPORT will print out the current position and direction of the robot.
  ```
  > Command: REPORT
  Robot is currently at position 1,4 facing EAST
  ```
- `SHOW`: The SHOW command will show a visual representation of the grid that the robot is placed in.
  ```
  > Command: show
  You entered: SHOW

  ┌──┬──┬──┬──┬──┐
  │  │  │  │  │  │
  ├──┼──┼──┼──┼──┤
  │  │  │  │  │  │
  ├──┼──┼──┼──┼──┤
  │  │  │  │  │  │
  ├──┼──┼──┼──┼──┤
  │  │🤖│  │  │  │
  ├──┼──┼──┼──┼──┤
  │  │  │  │  │  │
  └──┴──┴──┴──┴──┘

  ```
- `EXIT`: EXIT will exit the program

## File Input
- Commands can be given to the application through a file input
- Running `./bin/toyrobot file=test.txt` will run all commands in the file `test.txt`
- The file must be placed in the root directory
- The commands must be given in the format described above. Each command must be on a separate line.
- If the file does not exist, the application will display an error message and exit

## Testing and Error Handling
- The application has been tested using `Rspec`
- Both integration and unit tests have been written and performed
- To run all tests, simply run `rspec` in the command line from the application root directory
- Error handling using `rescue` operations have been written in several places. However, if any unexpected errors occur, please contact the developers.
- If any unexpected problems occur, please contact the developer of this application


## Description

- The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.
- There are no other obstructions on the table surface.
- The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement
  that would result in the robot falling from the table must be prevented, however further valid movement commands must still
  be allowed.

Create an application that can read in commands of the following form:

```plain
PLACE X,Y,F
MOVE
LEFT
RIGHT
REPORT
```

- PLACE will put the toy robot on the table in position X,Y and facing NORTH, SOUTH, EAST or WEST.
- The origin (0,0) can be considered to be the SOUTH WEST most corner.
- The first valid command to the robot is a PLACE command, after that, any sequence of commands may be issued, in any order, including another PLACE command. The application should discard all commands in the sequence until a valid PLACE command has been executed.
- MOVE will move the toy robot one unit forward in the direction it is currently facing.
- LEFT and RIGHT will rotate the robot 90 degrees in the specified direction without changing the position of the robot.
- REPORT will announce the X,Y and orientation of the robot.
- A robot that is not on the table can choose to ignore the MOVE, LEFT, RIGHT and REPORT commands.
- Provide test data to exercise the application.

## Constraints

The toy robot must not fall off the table during movement. This also includes the initial placement of the toy robot.
Any move that would cause the robot to fall must be ignored.

Example Input and Output:

```plain
PLACE 0,0,NORTH
MOVE
REPORT
Output: 0,1,NORTH
```

```plain
PLACE 0,0,NORTH
LEFT
REPORT
Output: 0,0,WEST
```

```plain
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
Output: 3,3,NORTH
```

## Deliverables

The source files, the test data and any test code (as well as explanations of how to run everything).

## Expectations

- There is no time limit for the test, you can take as long as you like, but a reasonable thing that most people do is to take a weekend to do it and send the solution back (i.e. turn it around within a week). If you need more time that's fine, just send us a quick message to let us know.
- You're welcome to use whatever language you like, our tech stack is Ruby and Typescript so either one of those would be well regarded, but if you want to use a different language you're welcome to, just make sure we can easily run it (e.g. docker image). It's also worthwhile to make sure that the language you pick (if something other than Ruby or TS) is the best way to showcase your skills. Remember you will be pairing and extending this solution if you get to that part of the interview process.
- The expectation is that you will create a command line application, please don't build a web ui/api etc.
- You will use this coding test as a showcase of your skills as a developer, we should be able to look at this code and learn something about the way you think and about how you solve problems.

We're not just looking for a minimal solution that would solve the problem. We're looking for:

- production quality code
- good OO and/or functional practices
- a solid testing approach
- well thought out naming
- solid error handling
- extensibility/maintainability/\*ility
- good design from a software engineering perspective
- separation of concerns, i.e. low coupling high cohesion
- sensible breakdown of code into files/modules
- use of best practices/idioms when it comes to language, testing etc.
- appropriate use of tools/frameworks
- performant code, i.e. memory/cpu efficient
- etc

Basically treat the coding test as if it's a larger problem, a little bit of over-engineering is likely a good idea.

## Common issues to avoid/think about

- edge case inputs break the application
- a large amount of input data will kill the application/cause it to be slow/cause it to be unresponsive
- it requires a lot of effort to add new commands to the application
- it requires a lot of effort to change the dimensions of the table
- the application is not resilient to changes in the format of the input
- the application is not resilient to changes in the source of the input
- the application is not resilient to changes in the format of the output
- elements of the design clearly violate SOLID (if OO)
- the solution doesn't invert any dependencies
- the solution violates DRY

## Self-assessment checklist

- Does the submission exhibit a good understand of OO and/or functional priniciples
- Does the submission exhibit a solid testing approach (good mix of unit and integration tests etc.)
- Does the submission exhibit well thought out variable/function/class naming
- Does the submission exhibit a solid approach to error handling (can't easily get a stack trace on the command line)
- Does the submission exhibit low coupling/high cohesion
- Is the code easy to read/understand/extend
- Would I be happy to have code of a similar standard in production
- Would I be happy to inherit/modify/extend/maintain code of a similar standard