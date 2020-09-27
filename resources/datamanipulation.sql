-- /courses
-- Select filtered courses and topics
-- This query is built in the server.js file based on query parameters
SELECT crs.ID, crs.Name AS cName, crs.Code, crs.Description, crs.OfferedBy, ct.TID, t.Name AS tName FROM COURSE crs
    LEFT JOIN CATEGORIES ct ON crs.ID = ct.CID
    LEFT JOIN TOPIC t ON ct.TID = t.ID
-- Otional additions
WHERE crs.Code LIKE '%[code]%' OR 
crs.Name LIKE '%[name]%' OR
TID = '[topic]' OR
OfferedBy = '[offeredby]'
-- End optional additions
GROUP BY CODE

-- Select all universities
SELECT * FROM UNIVERSITY

-- Select all topics
SELECT * FROM TOPIC
-------------------------------------------------------
-- /course
-- Select the course with offering universities
CALL CourseUniData('[courseId]')

-- Select videos related to the course
SELECT * FROM VIDEO WHERE CID = '[courseId]'

-- Get top 5 related courses
CALL RelatedCourses('[courseId]', 5)

-------------------------------------------------------
-- /universities
-- Select all universities
SELECT * FROM UNIVERSITY

-- Get instructor data for all instructors
CALL InstructorData(NULL)

-- Select data for all courses
SELECT Name, ID, Code, Offeredby AS UID FROM COURSE

-------------------------------------------------------
-- /instructors
-- Select all instructors
SELECT * FROM INSTRUCTOR

-------------------------------------------------------
-- /instructor
-- Select instructor
SELECT * FROM INSTRUCTOR WHERE Id = '[instructorId]'

-- Select courses taught by instructor
SELECT * FROM COURSE c
     INNER JOIN TEACHES t on t.CID = c.Id
     WHERE t.IID = '[instructorId]'

-- Select data for instructor
CALL InstructorData('[instructorId]')

-------------------------------------------------------
-- /relatedcourses
-- Get a very large number of related courses
CALL RelatedCourses('[courseId]', 10000)

-------------------------------------------------------
-- /editcourse
-- Select all universities
SELECT * FROM UNIVERSITY

-- Select all courses
SELECT * FROM COURSE

-------------------------------------------------------
-- /addcourse
-- Insert course with provided values
INSERT INTO COURSE (Code, Name, Description, OfferedBy) 
VALUES ('${requestBody.code}', '${requestBody.name}', '${requestBody.description}', '${requestBody.offeredBy}')

-------------------------------------------------------
-- /updateCourse get
-- Select data for course and university it is at
CALL CourseUniData('${id}')

-- Select all universities
SELECT * FROM UNIVERSITY

-------------------------------------------------------
-- /updateCourse post
-- Update course with the provided values
UPDATE COURSE
  SET Name = '${requestBody.name}', Code = '${requestBody.code}', Description = '${requestBody.description}', Offeredby = '${requestBody.university}'
  WHERE ID = ${requestBody.id}
 
-------------------------------------------------------
-- /editinstructor
-- Select all instructors
SELECT * FROM INSTRUCTOR

--Select all universities
SELECT * FROM UNIVERSITY

-------------------------------------------------------
-- /removecourse
-- Delete the provided course
DELETE FROM COURSE WHERE ID = ${requestBody.id}

-------------------------------------------------------
-- /updateinstructor get
-- Get Instructor and related university data
SELECT u.ID as uID, i.Name as iName, i.Degree FROM UNIVERSITY u
  INNER JOIN EMPLOYEDBY e ON e.UID = u.ID
  INNER JOIN INSTRUCTOR i ON i.ID = e.IID
  WHERE i.ID = ${id}

-- Select all universities
SELECT * FROM UNIVERSITY

-------------------------------------------------------
-- /updateinstructor post
-- Update instructor with provided values
UPDATE INSTRUCTOR
  SET Name = '${requestBody.name}', Degree = '${requestBody.degree}'
  WHERE ID = ${requestBody.id}

-- Update employed by table with provided values
UPDATE EMPLOYEDBY
  SET UID = ${requestBody.university}
  WHERE IID = ${requestBody.id}

-------------------------------------------------------
-- /addInstructor
-- Insert instructor with provided values
INSERT INTO INSTRUCTOR (Name, Degree) 
VALUES ('${requestBody.name}', '${requestBody.degree}')

-- Add employed by entry for new instructor
INSERT INTO EMPLOYEDBY (IID, UID) 
VALUES ((SELECT ID FROM INSTRUCTOR 
    WHERE Name = '${requestBody.name}' AND 
    Degree = '${requestBody.degree}' LIMIT 1), ${requestBody.university})

-------------------------------------------------------
-- /removeInstructor
-- Delete the provided instructor
DELETE FROM INSTRUCTOR WHERE ID = ${requestBody.id}

-------------------------------------------------------
-- /addUniversity post
-- Insert university with provided values
INSERT INTO UNIVERSITY (Name, Country, Region) 
VALUES ('${requestBody.name}', '${requestBody.country}','${requestBody.region}')

