var path = require('path');
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var exphbs = require('express-handlebars');
app.set('port', process.argv[2]);
var mysql = require('./dbcon.js');

app.use(bodyParser.urlencoded({extended: true}));

app.engine('handlebars', exphbs({
  defaultLayout: 'main',
  layoutsDir: path.join(__dirname, "views/layouts/"),
  helpers: {
    ifeq: function(a, b, opts) {
      if(a == b){
          return opts.fn(this);
      }
      else{
          return opts.inverse(this);
      }
    }
  }
}));

app.set('view engine', 'handlebars');

app.get('/', function (req, res) {
  res.status(200).render('mainpage');
});


/*
Handler for the courses (plural) endpoint. Grabs all courses.
*/
app.get('/courses', function (req, res, next) {
  var code = req.query.code;
  var name = req.query.name;
  var topic = parseInt(req.query.topic, 10);
  var offeredby = parseInt(req.query.offeredby, 10);

  let sql = "SELECT crs.ID, crs.Name AS cName, crs.Code, crs.Description, crs.OfferedBy, ct.TID, t.Name AS tName FROM COURSE crs "+
    "LEFT JOIN CATEGORIES ct ON crs.ID = ct.CID "+
    "LEFT JOIN TOPIC t ON ct.TID = t.ID";
  let addOr = false;

  // Jankily construct our query using search params if they were specified
  if (code || name || offeredby > 0 || topic > 0){
    sql += " WHERE";

    if (code) {
      sql += (" crs.Code LIKE '%" + code + "%'");
      addOr = true;
    }

    if (name) {
      if (addOr){
        sql += " OR";
      }
      sql += (" crs.Name LIKE '%" + name + "%'");
      addOr = true;
    }

    if (topic > 0) {
      if (addOr){
        sql += " OR";
      }
      sql += (" TID = " + topic);
      addOr = true;
    }

    if (offeredby > 0){
      if (addOr){
        sql += " OR";
      }
      sql += (" OfferedBy = " + offeredby);
    }
  }

  sql += " GROUP BY CODE";

  mysql.pool.query(sql, function (err, courses, fields) {      
    mysql.pool.query('SELECT * FROM UNIVERSITY', function (err, universities, fields) {
      mysql.pool.query('SELECT * FROM TOPIC', function (err, topics, fields) {      
        res.render('courses', { courses: courses, universities: universities, topics: topics});
      });
    });
  });

});

/*
Handler for the course (singular) endpoint. Grabs all information related to a given course.
Format for this endpoint is /course?id=<courseid>.
*/
app.get('/course', function (req, res) {

  var courseid = parseInt(req.query.id, 10);

  //Check for valid course id parameter
  if(courseid == NaN){
    console.log("Course Id not provided in query");
  }

  //Build query to find course info
  var sql = 'CALL CourseUniData(?)';
  mysql.pool.query(sql, [courseid], function (err, courseinfo, fields) {
    if (err) {
      console.log(err);
    }

    courseinfo = courseinfo[0];

    var sql2 = 'SELECT * FROM VIDEO WHERE CID = ?'
    mysql.pool.query(sql2, [courseid], function (err, videos, fields) {
      if (err) {
        console.log(err);
      }

      var sql3 = 'CALL RelatedCourses(?, 5)';
      mysql.pool.query(sql3, [courseid], function (err, relatedcourses, fields) {
        if (err) {
          console.log(err);
        }

        //Calling a stored Procedure returns other data; we just want the rowDataPacket
        relatedcourses = relatedcourses[0];

        console.log(relatedcourses);
        res.status(200).render('course', { courseinfo: courseinfo[0], videos: videos, relatedcourses: relatedcourses });
     });
    });
  });
});


/*
Handler for the universities endpoint. Creates a data array of universities with their assosiated courses and 
  employed instructors. 
*/
app.get('/universities', function (req, res, next) {

  mysql.pool.query('SELECT * FROM UNIVERSITY', function (err, rows, fields) {
    if (err) {
      console.log(err);
    }

    var Isql = 'CALL InstructorData(NULL)';

    //Assign instructors to the correct university
    mysql.pool.query(Isql, function (err, inst, fields) {
      if (err) {
        console.log(err);
      }

      inst = inst[0];

      for(i = 0;i < rows.length; i++){
        rows[i].instructors = [];
        for(j = 0;j < inst.length; j++){
          if(inst[j].UID == rows[i].ID){
            rows[i].instructors.push(inst[j]);
          }
        }
      }

      var Csql = 'SELECT Name, ID, Code, Offeredby AS UID FROM COURSE';

      //Assign courses to the correct university
      mysql.pool.query(Csql, function (err, course, fields) {
        if (err) {
          console.log(err);
        }

        for(i = 0;i < rows.length; i++){
          rows[i].courses = [];
          for(j = 0;j < course.length; j++){
            if(course[j].UID == rows[i].ID){
              rows[i].courses.push(course[j]);
            }
          }
        }

        console.log(rows);

        res.status(200).render('universities', { data: rows });
      });
      
      
    });
    });
  });

app.get('/about', function (req, res) {
  res.status(200).render('about');
});

app.get('/instructors', function (req, res, next) {
  var context = {};

  mysql.pool.query('SELECT * FROM INSTRUCTOR', function (err, rows, fields) {
    if (err) {
      console.log(err);
    }

    console.log(rows);
    res.render('instructors', { data: rows });
  });

});

/*
Handler for the instructor (singular) endpoint. Grabs all information related to a given instructor.
Format for this endpoint is /instructor?id=<instructorid>.
*/
app.get('/instructor', function (req, res) {

  var instructorid = parseInt(req.query.id, 10);

  //Check for valid instructor id parameter
  if(instructorid == NaN){
    console.log("Instructor Id not provided in query");
  }

  //Build query to find instructor info
  var sql = 'SELECT * FROM INSTRUCTOR WHERE Id = ?';
  mysql.pool.query(sql, [instructorid], function (err, instructorinfo, fields) {
    if (err) {
      console.log(err);
    }

    var sql2 = 'SELECT * FROM COURSE c ' +
     'INNER JOIN TEACHES t on t.CID = c.Id ' +
     'WHERE t.IID = ?'

    mysql.pool.query(sql2, [instructorid], function (err, courses, fields) {
      if (err) {
        console.log(err);
      }

      var sql3 = 'CALL InstructorData(?)'

      mysql.pool.query(sql3, [instructorid], function (err, universities, fields) {
        if (err) {
          console.log(err);
        }

        universities = universities[0];
        
        console.log(instructorinfo);
        console.log(courses);
        console.log(universities);

        res.status(200).render('instructor', { instructorinfo: instructorinfo[0], courses: courses, universities:  universities[0]});
      });
    });
  });
});

/*
Handler for the relatedcourses endpoint. Creates a data array of courses which have topics that are listed in the related to table
  for the topic(s) of the provided course id query parameter. Format for this endpoint is /relatedcourses?id=<courseid>.
*/
app.get('/relatedcourses', function (req, res) {

  var courseid = parseInt(req.query.id, 10);

  //Check for valid course id parameter
  if(courseid == NaN){
    console.log("Course Id not provided in query");
  }

  //Build query to find all related courses
  var sql = 'CALL RelatedCourses(?, 10000)';
  mysql.pool.query(sql, [courseid], function (err, relCourses, fields) {
    if (err) {
      console.log(err);
    }

    //Calling a stored Procedure returns other data; we just want the rowDataPacket
    relCourses = relCourses[0];

    console.log(relCourses);

    res.status(200).render('relatedcourses', { relCourses: relCourses });
  });
});

app.get('/editcourse', function (req, res) {
  mysql.pool.query('SELECT * FROM UNIVERSITY', function (err, unis, fields) {
    if (err) {
      console.log(err);
    }

    console.log(unis);
    mysql.pool.query('SELECT * FROM COURSE', function (err, cs, fields) {
      if (err) {
        console.log(err);
      }

      console.log(cs);
      res.status(200).render('editcourse', { universities: unis, courses: cs });
    });
  });
});

app.post('/addCourse', function (req, res) {
  var requestBody = req.body;
  var sqlString = `INSERT INTO COURSE (Code, Name, Description, OfferedBy) VALUES ('${requestBody.code}', '${requestBody.name}', '${requestBody.description}', ${requestBody.offeredBy})`;
  console.log(sqlString);
  mysql.pool.query(sqlString, function (err, unis, fields) {
    if (err) {
      console.log(err);
    }
    res.redirect('/editcourse');
  });  
});

app.get('/updateCourse', function (req, res) {

  let id = parseInt(req.query.id, 10);

  let sql = `CALL CourseUniData(${id})`;
  mysql.pool.query(sql, function (err, info, fields) {
    if (err) {
      console.log(err);
    }
    info = info[0];

    mysql.pool.query(`SELECT * FROM UNIVERSITY`, function (err, universities, fields) {
      console.log(info[0])
      res.status(200).render('updatecourse', { info: info[0], universities: universities, id: id });
    });
  });
});

app.post('/updateCourse', function (req, res) {
  console.log("hello")
  var requestBody = req.body;

  let sql = `UPDATE COURSE
  SET Name = '${requestBody.name}', Code = '${requestBody.code}', Description = '${requestBody.description}', Offeredby = '${requestBody.university}'
  WHERE ID = ${requestBody.id}`

  mysql.pool.query(sql, function (err, e, fields) {
    if (err) {
      console.log(err);
    }
    console.log(e)
    res.redirect('/courses');
  });
});

app.get('/editinstructor', function (req, res) {
  mysql.pool.query('SELECT * FROM INSTRUCTOR', function (err, instructors, fields) {
    if (err) {
      console.log(err);
    }
    mysql.pool.query('SELECT * FROM UNIVERSITY', function (err, universities, fields) {
      if (err) {
        console.log(err);
      }
      res.status(200).render('editinstructor', { instructors: instructors, universities: universities });
    });
  });
});

app.post('/removecourse', function(req, res){
 var requestBody = req.body;
 console.log(requestBody);
 let query3= `DELETE FROM COURSE WHERE ID = ${requestBody.id}`

    mysql.pool.query(query3, function (err, i, fields) {
      if (err){
        console.log(err);
      }
      res.redirect('/courses');
    });
  });

app.get('/updateinstructor', function (req, res) {

  let id = parseInt(req.query.id, 10);

  let sql = `SELECT u.ID as uID, i.Name as iName, i.Degree FROM UNIVERSITY u
  INNER JOIN EMPLOYEDBY e ON e.UID = u.ID
  INNER JOIN INSTRUCTOR i ON i.ID = e.IID
  WHERE i.ID = ${id}`
  mysql.pool.query(sql, function (err, info, fields) {
    if (err) {
      console.log(err);
    }
    mysql.pool.query(`SELECT * FROM UNIVERSITY`, function (err, universities, fields) {
      console.log(info[0]);
      res.status(200).render('updateinstructor', { info: info[0], universities: universities, id: id });
    });
  });
});

app.post('/updateinstructor', function (req, res) {

  var requestBody = req.body;

  let sql = `UPDATE INSTRUCTOR
  SET Name = '${requestBody.name}', Degree = '${requestBody.degree}'
  WHERE ID = ${requestBody.id}`

  let sql2 = `UPDATE EMPLOYEDBY
  SET UID = ${requestBody.university}
  WHERE IID = ${requestBody.id}`

  mysql.pool.query(sql, function (err, e, fields) {
    if (err) {
      console.log(err);
    }
    mysql.pool.query(sql2, function (err, i, fields) {
      res.redirect('/instructors');
    });
  });
});

app.post('/addInstructor', function (req, res) {
  var requestBody = req.body;
  var sqlString = `INSERT INTO INSTRUCTOR (Name, Degree) VALUES ('${requestBody.name}', '${requestBody.degree}')`
  var sqlString2 = `INSERT INTO EMPLOYEDBY (IID, UID) VALUES ((SELECT ID FROM INSTRUCTOR WHERE Name = '${requestBody.name}' AND Degree = '${requestBody.degree}' LIMIT 1), ${requestBody.university})`
  console.log(sqlString)
  mysql.pool.query(sqlString, function (err, unis, fields) {
    if (err) {
      console.log(err);
    }
    mysql.pool.query(sqlString2, function (err, unis, fields) {
      if (err) {
        console.log(err);
      }

      res.redirect('/editinstructor');
    });
  });
});

app.post('/removeInstructor', function(req, res){
 var requestBody = req.body;
 console.log(requestBody);
 let query3= `DELETE FROM INSTRUCTOR WHERE ID = ${requestBody.id}`

    mysql.pool.query(query3, function (err, i, fields) {
      if (err){
        console.log(err);
      }
      res.redirect('/instructors');
    });
  });

app.get('/adduniversity', function (req, res) {
  res.status(200).render('adduniversity');
  });

// app.post('/addUniversity', function(req, res){
//   var requestBody = req.body;
//   var sqlString = `INSERT INTO UNIVERSITY (Name, Country, Region) VALUES ('${requestBody.name}', '${requestBody.country}','${requestBody.region}')`;
//     console.log(sqlString);
//   mysql.pool.query(sqlString, function (err, unis, fields) {
//     if (err) {
//       console.log(err);
//     }
//     res.redirect('universities');
// });


app.post('/addUniversity', function (req, res) {
  var requestBody = req.body;
  var sqlString = `INSERT INTO UNIVERSITY (Name, Country, Region) VALUES ('${requestBody.name}', '${requestBody.country}','${requestBody.region}')`
  console.log(sqlString)
  mysql.pool.query(sqlString, function (err, unis, fields) {
    if (err) {
      console.log(err);
    }
      res.redirect('/universities');
    });
  });


app.use(express.static('public'));

app.listen(app.get('port'), function(){
  console.log('Express started on http://localhost/:' + app.get('port') + '; press Ctrl-C to terminate.');
});


