Email Visualization
==================
Excitement Radar
----------------

An email visualization made using Processing.

Used as a project for the Spring 2013 CS 467 class at the University of Illinoisat Urbana-Champaign.

ToDo:

1) Split up EmailResult's getDate method into smaller getMonth(), getYear(), getDay(), getTime() [should return integers] 

2) Have a timeline vs total excitement level at the bottom 

3) Zoom into a circle to show email detail

How to export/use java library:
- Open Eclipse with the ClassificationWrapper project
- Right click the Project in the package explorer
	- >Export
	- >Runnable JAR file
	- >Extract required libraries into generated JAR
	- >Save to Processing (usually located in MyDocuments)/libraries/classifyWrapper/library/classifyWrapper.jar
- To use, re-open the Processing GUI. At the top insert: "import ClassificationWrapper.*;

To use the EmailResult class:
- EmailResult emailResult = new EmailResult("<Path to email file>");
- String[] from = emailResult.getFrom();	// returns an array of senders
- String[] to = emailResult.getTo();
- String subject = emailResult.getSubject();
- Boolean isReply = emailResult.isReply();	// Checks to see whether this email is part of a thread
