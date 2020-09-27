-- a) Create tables

CREATE TABLE UNIVERSITY
(ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Country VARCHAR(255) NOT NULL,
Region VARCHAR(255) NOT NULL);

CREATE TABLE INSTRUCTOR
(ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Degree VARCHAR(255) NOT NULL);

CREATE TABLE EMPLOYEDBY(
UID INT,
IID INT,
FOREIGN KEY (UID) REFERENCES UNIVERSITY(ID) ON DELETE CASCADE,
FOREIGN KEY (IID) REFERENCES INSTRUCTOR(ID) ON DELETE CASCADE,
PRIMARY KEY (UID, IID)
);

CREATE TABLE COURSE
(ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
Code VARCHAR(255) NOT NULL,
Name VARCHAR(255) NOT NULL,
Description TEXT,
Offeredby INT,
FOREIGN KEY (Offeredby) REFERENCES UNIVERSITY(ID) ON DELETE CASCADE
);

CREATE TABLE TEACHES(
CID INT,
IID INT,
FOREIGN KEY (CID) REFERENCES COURSE(ID) ON DELETE CASCADE,
FOREIGN KEY (IID) REFERENCES INSTRUCTOR(ID) ON DELETE CASCADE,
PRIMARY KEY (CID, IID)
);

CREATE TABLE VIDEO
(URL VARCHAR(255) NOT NULL PRIMARY KEY,
Length VARCHAR(255) NOT NULL,
Title VARCHAR(255) NOT NULL,
CID INT,
FOREIGN KEY (CID) REFERENCES COURSE(ID) ON DELETE CASCADE

);

CREATE TABLE TOPIC(
ID INT (11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Description TEXT
);

CREATE TABLE CATEGORIES(
CID INT,
TID INT,
FOREIGN KEY (CID) REFERENCES COURSE(ID) ON DELETE CASCADE,
FOREIGN KEY (TID) REFERENCES TOPIC(ID) ON DELETE CASCADE,
PRIMARY KEY (CID, TID)
);

CREATE TABLE RELATEDTO(
RTID INT,
RTID2 INT,
FOREIGN KEY (RTID) REFERENCES TOPIC(ID) ON DELETE CASCADE,
FOREIGN KEY (RTID2) REFERENCES TOPIC(ID) ON DELETE CASCADE,
PRIMARY KEY (RTID, RTID2)
);

-- b) Sample data

INSERT INTO `UNIVERSITY` (`Name`, `Country`, `Region`) VALUES
('Stanford University', 'USA', 'North America'),
('UC Berkeley', 'USA', 'North America'),
('Massachusetts Institute of Technology', 'USA', 'North America'),
('Harvard University', 'USA', 'North America'),
('University of British Columbia', 'Canada', 'North America'),
('IIT DELHI', 'India', 'South Asia'),
('University of Utah', 'USA', 'North America'),
('University of Edinburgh', 'Scotland', 'Europe'),
('University of Washington', 'USA', 'North America'),
('Virginia Tech', 'USA', 'North America'),
('University of Waterloo', 'Canada', 'North America');

INSERT INTO `INSTRUCTOR` (`Name`, `Degree`) VALUES 
('Prof. Dan Garcia', 'PhD in EECS 2009'),
('Prof. Aditya Bhaskara', 'PhD in CS 2012'),
("Prof. Tim Roughgarden", "PhD in CS 2011"),
("Prof. Erik Demaine", "PhD in CS 2001"),
("Prof. Wheeler Anderson", "Masters in Data strctures 2001"),
("Prof. Mike Max", "Masters in CS 2001"),
("Prof. Max SchmIDth", "Bachelors in CS 2008"),
("Prof.  Erica Max", "PhD in CS 2008"),
("Prof.  Clayton Tim", "PhD in CS 2009"),
("Prof.  Jay Patarali", "PhD in CS 2002"),
("Prof.  Tim Cook", "PhD in CS 2009");

INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY WHERE Name="Stanford University"), (SELECT ID FROM INSTRUCTOR WHERE Name="Prof. Dan Garcia"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="UC Berkeley"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Aditya Bhaskara"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="Harvard University"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Erik Demaine"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="University of British Columbia"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Wheeler Anderson"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="IIT DELHI"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Mike Max"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="University of Utah"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Max SchmIDth"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="University of Edinburgh"), (SELECT ID FROM INSTRUCTOR where Name="Prof.  Erica Max"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="University of Washington"), (SELECT ID FROM INSTRUCTOR where Name="Prof.  Clayton Tim"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="University of Waterloo"), (SELECT ID FROM INSTRUCTOR where Name="Prof.  Tim Cook"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="Virginia Tech"), (SELECT ID FROM INSTRUCTOR where Name="Prof.  Jay Patarali"));
INSERT INTO EMPLOYEDBY(UID, IID) VALUES( (SELECT ID FROM UNIVERSITY where Name="Massachusetts Institute of Technology"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Tim Roughgarden"));

INSERT INTO COURSE(Code, Name, Description, Offeredby) VALUES
('CS161', 'Introduction to Programming', 'Programming language introduction to C and C++.', (SELECT ID FROM UNIVERSITY where Name='Stanford University')),
("CS261", "Introduction to Data Structures", "A beginner's look at various data structures and their advantages and drawbacks.", (SELECT ID FROM UNIVERSITY where Name="UC Berkeley")),
("CS361", "Introduction to Software Engineering", "Agile methodologies in CS and unit testing.", (SELECT ID FROM UNIVERSITY where Name="Massachusetts Institute of Technology")),
("CS 6.890", "Algorithmic Lower Bounds", "Fun with Hardness Proofs.", (SELECT ID FROM UNIVERSITY where Name="Harvard University")),
("CS444", "Operating Systems II", "Further exploration of the functions of operation systems.", (SELECT ID FROM UNIVERSITY where Name="University of British Columbia")),
("CS264", "PMP Distributed Systems", "Distributed systems.", (SELECT ID FROM UNIVERSITY where Name="IIT DELHI")),
("CS387", "Real time Systems", "Systems that are real-time.", (SELECT ID FROM UNIVERSITY where Name="University of Utah")),
("CS468", "Aritificial Intelligence Analysis", "Analysis of the algorithms behind AI and how they can be optimized.", (SELECT ID FROM UNIVERSITY where Name="University of Edinburgh")),
("CS789", "Machine Learning", "A comprehensive overview of what makes machine learning different from conventional problem solving.", (SELECT ID FROM UNIVERSITY where Name="University of Washington")),
("CS544", "Advanced PHP and Databases", "In-depth look at the use of PHP with database systems.", (SELECT ID FROM UNIVERSITY where Name="Virginia Tech")),
("CS784", "Signal Processing on Databases", "How various signal processing methods affect database performance.", (SELECT ID FROM UNIVERSITY where Name="University of Waterloo"));

INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS161"), (SELECT ID FROM INSTRUCTOR WHERE Name="Prof. Dan Garcia"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS261"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Aditya Bhaskara"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS361"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Erik Demaine"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS 6.890"),  (SELECT ID FROM INSTRUCTOR where Name="Prof. Wheeler Anderson"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS444"),  (SELECT ID FROM INSTRUCTOR where Name="Prof. Mike Max"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS264"), (SELECT ID FROM INSTRUCTOR where Name="Prof. Max SchmIDth"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS387"), (SELECT ID FROM INSTRUCTOR where Name="Prof.  Erica Max"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS468"),  (SELECT ID FROM INSTRUCTOR where Name="Prof.  Clayton Tim"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS789"),  (SELECT ID FROM INSTRUCTOR where Name="Prof.  Tim Cook"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS544"),  (SELECT ID FROM INSTRUCTOR where Name="Prof.  Jay Patarali"));
INSERT INTO TEACHES(CID, IID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS784"),  (SELECT ID FROM INSTRUCTOR where Name="Prof. Tim Roughgarden"));

INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PL07B3F10B48592010', "26:10:30", "COMP3000", (SELECT ID FROM COURSE WHERE Code="CS161"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PLbuogVdPnkCp8X9FHOglnLqFjyvqGLftx', "25:15:30", "Data Structures", (SELECT ID FROM COURSE WHERE Code="CS261"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PLBdajHWwi0JCn87QuFT3e58mekU0-6WUT', "10:15:30", "Software Engineering II", (SELECT ID FROM COURSE WHERE Code="CS361"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-890-algorithmic-lower-bounds-fun-with-hardness-proofs-fall-2014/', "10:15:30", "Algorithmic Lower Bounds: Fun with Hardness Proofs", (SELECT ID FROM COURSE WHERE Code="CS 6.890"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PL3swII2vlVoVbav6FV98pIDq6BsTN4u56', "12:50:30", "Operating Systems 2", (SELECT ID FROM COURSE WHERE Code="CS444"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/watch?v=1QZDe28peZk&list=PLRdD1c6QbAqJn0606RlOR6T3yUqFWKwmX&index=1', "12:50:30", "Distributed Systems", (SELECT ID FROM COURSE WHERE Code="CS264"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/watch?v=fd5P-8IQwMY&list=PLkFD6_40KJIx8lWWbE-Uk069aZ1R-W-VU&index=2&t=0s', "12:50:30", "Real time Systems", (SELECT ID FROM COURSE WHERE Code="CS387"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PL2SOU6wwxB0v1kQTpqpuu5kEJo2i-iUyf', "12:50:30", "Aritificial Intelligence Analysis", (SELECT ID FROM COURSE WHERE Code="CS468"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PLb4G5axmLqiuneCqlJD2bYFkBwHuOzKus', "12:50:30", "Machine Learning", (SELECT ID FROM COURSE WHERE Code="CS789"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/channel/UC_Oao2FYkLAUlUVkBfze4jg/vIDeos', "12:50:30", "PHP", (SELECT ID FROM COURSE WHERE Code="CS544"));
INSERT INTO VIDEO(URL,Length, Title, CID) VALUES
('https://www.youtube.com/playlist?list=PLFE776F2C513A744E', "12:50:30", "Signal Processing on database", (SELECT ID FROM COURSE WHERE Code="CS784"));

INSERT INTO TOPIC (Name, Description) VALUES 
('Data Structures', 'The basic structures that programmers use to solve problems.'),
('Software Engineering', 'The business side of developing software.'),
('Operating Systems', 'The layer of software that lies between the hardware of a computer and the software.'),
('Distributed Systems', 'A system in which components are distributed across multiple machines but appear as a single machine to a user.'),
('Real Time Systems', 'Systems in which responses must occur within real-world time constraints.'),
('Artificial Intelligence', 'The branch of CS that hopes to simulate human ability to recognize patterns.'),
('Machine Learning', 'The application of Artificial Intelligence in order to solve problems.'),
('PHP', 'A general-purpose scripting programming language, often used in web applications.'),
('Algorithms', 'A series of steps that can be repeated to obtain the same result.'),
('Kernel Development', 'Code that builds the foundation of an Operating System.'),
('The Basics', 'Courses that are good starting points for beginners.'),
('Databases', 'Structured sets of data that are stored in a computer.');

INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS161"), (SELECT ID FROM TOPIC WHERE Name="The Basics"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS261"), (SELECT ID FROM TOPIC WHERE Name="Data Structures"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS361"), (SELECT ID FROM TOPIC WHERE Name="Software Engineering"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS 6.890"), (SELECT ID FROM TOPIC WHERE Name="Algorithms"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS444"), (SELECT ID FROM TOPIC WHERE Name="Operating Systems"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS264"), (SELECT ID FROM TOPIC WHERE Name="Distributed Systems"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS387"), (SELECT ID FROM TOPIC WHERE Name="Real Time Systems"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS468"), (SELECT ID FROM TOPIC WHERE Name="Artificial Intelligence"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS789"), (SELECT ID FROM TOPIC WHERE Name="Machine Learning"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS544"), (SELECT ID FROM TOPIC WHERE Name="PHP"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS544"), (SELECT ID FROM TOPIC WHERE Name="Databases"));
INSERT INTO CATEGORIES(CID, TID) VALUES( (SELECT ID FROM COURSE WHERE Code="CS784"), (SELECT ID FROM TOPIC WHERE Name="Databases"));

INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Data Structures"), (SELECT ID FROM TOPIC WHERE Name="Software Engineering"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Data Structures"), (SELECT ID FROM TOPIC WHERE Name="The Basics"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Software Engineering"), (SELECT ID FROM TOPIC WHERE Name="Data Structures"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Operating Systems"), (SELECT ID FROM TOPIC WHERE Name="Distributed Systems"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Distributed Systems"), (SELECT ID FROM TOPIC WHERE Name="Real time Systems"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Real Time Systems"), (SELECT ID FROM TOPIC WHERE Name="Distributed Systems"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Algorithms"), (SELECT ID FROM TOPIC WHERE Name="Artificial Intelligence"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Kernel Development"), (SELECT ID FROM TOPIC WHERE Name="Operating Systems"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Machine Learning"), (SELECT ID FROM TOPIC WHERE Name="Artificial Intelligence"));
INSERT INTO RELATEDTO(RTID, RTID2) VALUES((SELECT ID FROM TOPIC WHERE Name="Artificial Intelligence"), (SELECT ID FROM TOPIC WHERE Name="Machine Learning"));

--RelatedCourses(course_id, limit_value) selects the first [limit_value] courses that have topics related to the course specified 
--by the course_id variable
--Courses are considered related when one or more topics assigned to a course has an entry in the RELATEDTO table that matches one or
--more of the topics on the specified course.  
--Returns a list of related courses with Topic name TName, Course name CName, Course code Code, and Course ID. 
DELIMITER //
CREATE PROCEDURE RelatedCourses(IN course_id INT(11), IN limit_value INT)
BEGIN
	SELECT T.Name AS TName, Crs.Name AS CName, Crs.Code, Crs.ID FROM COURSE Crs
    LEFT JOIN CATEGORIES Cat ON Cat.CID = Crs.ID
    LEFT JOIN TOPIC T ON T.ID = Cat.TID WHERE T.ID IN
    ( SELECT RT.RTID2 FROM RELATEDTO RT
    LEFT JOIN TOPIC TInner ON TInner.ID = RT.RTID
    LEFT JOIN CATEGORIES CatInner ON CatInner.TID = TInner.ID
    WHERE CatInner.CID = course_id) LIMIT limit_value;
END //
DELIMITER ;

--InstructorData(id) selects data about instructors and the university they are employed at for all instructors (if id is NULL) or a 
--single instructor by id (if id in not NULL) 
--Returns a list of instructor data with Instructor name Name, Instructor id IID, university id UID, and university name UName. 
DELIMITER //
CREATE PROCEDURE InstructorData(id INT(11))
BEGIN
	IF id IS NULL THEN
        SELECT i.Name, i.ID as IID, u.ID as UID, u.Name as UName
        FROM INSTRUCTOR i
        INNER JOIN EMPLOYEDBY e ON e.IID = i.Id
        INNER JOIN UNIVERSITY u ON e.UID = u.Id;
    ELSE
    	SELECT i.Name, i.ID as IID, u.ID as UID, u.Name as UName
        FROM INSTRUCTOR i
        INNER JOIN EMPLOYEDBY e ON e.IID = i.Id
        INNER JOIN UNIVERSITY u ON e.UID = u.Id
        WHERE i.ID = id;
    END IF;       
END //
DELIMITER ;

--CourseUniData(id) selects data about courses and the university they are offered by for the course specified by the id parameter.
--Returns a list of course data with University id UID, Course name CName, Course description Description, Course code Code,
--Course id CID, University name UName, and Course offered by OfferedBy.
DELIMITER //
CREATE PROCEDURE CourseUniData(id INT(11))
BEGIN
	SELECT u.ID as UID, c.Name as CName, c.Description, c.Code, c.ID as CID, u.Name as UName, c.OfferedBy FROM UNIVERSITY u
    INNER JOIN COURSE c ON c.Offeredby = u.ID
    WHERE c.ID = id;       
END //
DELIMITER ;