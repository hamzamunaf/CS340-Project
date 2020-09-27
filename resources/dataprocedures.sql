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