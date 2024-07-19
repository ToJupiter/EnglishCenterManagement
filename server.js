const express = require('express');
const pg = require('pg');
const path = require('path');
const session = require('express-session'); // Add for session management

const app = express();
const port = 3000;

// PostgreSQL configuration
const pool = new pg.Pool({
  user: 'postgres',
  host: 'localhost', 
  database: 'TTTA',
  password: 'admin',
  port: 5432, 
});

// Set EJS as the template engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(session({
  secret: 'your_secret_key', // Replace with a strong, randomly generated secret!
  resave: false,
  saveUninitialized: true
}));

// Routes

// Login page (GET)
app.get('/', (req, res) => {
  res.render('login'); 
});

// Login logic (POST)
app.post('/login', async (req, res) => {
  try {
    const studentId = req.body.student_id;

    if (!studentId) {
      return res.status(400).send('Student ID is required');
    }

    const result = await pool.query('SELECT * FROM student WHERE studentid = $1', [studentId]);

    if (result.rows.length > 0) {
      // Store student ID in the session
      req.session.studentId = studentId; 
      res.redirect('/dashboard'); 
    } else {
      res.send('Invalid student ID'); 
    }
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).send('An error occurred');
  }
});

// Dashboard page (GET)
app.get('/dashboard', async (req, res) => {
  try {
    // Check if the user is logged in (has studentId in session)
    if (!req.session.studentId) {
      return res.redirect('/'); // Redirect to login if not logged in
    }

    const studentId = req.session.studentId;
    const result = await pool.query('SELECT studentname FROM student WHERE studentid = $1', [studentId]);
    const studentName = result.rows.length > 0 ? result.rows[0].studentname : 'Guest'; 
    
    const progressResult = await pool.query('SELECT * FROM get_student_lesson_schedule10($1)', [studentId]);
    const progressData = progressResult.rows;

    res.render('dashboard', { 
      studentName: studentName,
      progressData: progressData  // Pass progress data to the template
    });
  } catch (error) {
    console.error('Error fetching student name:', error);
    res.status(500).send('An error occurred');
  }
});

// Logout route (add more routes as needed)
app.get('/logout', (req, res) => {
  req.session.destroy(err => { // Destroy the session
    if (err) {
      console.error('Error destroying session:', err);
    }
    res.redirect('/'); // Redirect to login after logout
  });
});

app.get('/view-status', async (req, res) => {
    try {
      // Check if the user is logged in
      if (!req.session.studentId) {
        return res.redirect('/');
      }
  
      const studentId = req.session.studentId;
  
      // Fetch student status from the database
      const result = await pool.query(
        `
        SELECT midtermscore, finaltermscore, absence, unpaidfees 
        FROM student_status_at_class
        WHERE studentid = $1
        `,
        [studentId]
      );
  
      const statusData = result.rows.length > 0 ? result.rows[0] : null;
  
      res.render('view-status', { statusData: statusData }); 
    } catch (error) {
      console.error('Error fetching student status:', error);
      res.status(500).send('An error occurred');
    }
  });

  app.get('/view-entrance-test', async (req, res) => {
    try {
      // Check if the user is logged in
      if (!req.session.studentId) {
        return res.redirect('/');
      }
  
      const studentId = req.session.studentId;
  
      // Fetch entrance test results
      const result = await pool.query(
        `
        SELECT testid, generalscore, speakingscore, meetinglink
        FROM entrance_test
        WHERE studentid = $1
        `,
        [studentId]
      );
  
      const testData = result.rows; // Get all results (could be multiple tests)
  
      res.render('view-entrance-test', { testData: testData });
    } catch (error) {
      console.error('Error fetching entrance test results:', error);
      res.status(500).send('An error occurred');
    }
  });

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});