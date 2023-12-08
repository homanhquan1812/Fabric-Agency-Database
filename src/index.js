const express = require('express')
const morgan = require('morgan')
const Handlebars = require("express-handlebars");
const path = require('path')
const route = require('./routes')
// const db = require('../config/db')
const oracledb = require('oracledb');
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
const bodyparser = require('body-parser')
const session = require('express-session')
const { v4: uuidv4 } = require('uuid');
const jwt = require('jsonwebtoken');

const app = express()

const port = 5000

// Body-parser
app.use(bodyparser.json())
app.use(bodyparser.urlencoded({  extended: true  }))

app.use(session({
  secret: 'secret',
  resave: false,
  saveUninitialized: true
}))

// db.run()
app.set('views', path.join(__dirname, 'resources\\views'))
app.use(express.static(path.join(__dirname, 'public')))

// "TypeError: Cannot destructure property 'NAME' of 'req.body' as it is undefined" solved
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
//

app.engine('handlebars', Handlebars.engine())
app.set('view engine', 'handlebars')

app.engine('hbs', Handlebars.engine({
    extname: '.hbs',
    helpers: {
        sum: (a, b) => a + b
    }
}))

app.set('view engine', 'hbs')

app.use(morgan('combined'))

/*
app.use(middleware)

  function middleware (req, res, next)
  {
    if (['cheapticket', 'expensiveticket'].includes(req.query.ticket))
    {
      return next()
    }
    else
    {
      res.status(403).json({
        message: 'Access denied'
      })
    }
  }
*/

app.get('/', function (req, res) {
  res.render('login', ({ layout: false }));
})

// Q1a
async function runQ1a() {
  try {
    const connection = await oracledb.getConnection({
      user: "HR",
      password: "12345678",
      connectString: "localhost/xe"
    });

    const query = `
      SELECT
        s.*,
        spn.sup_phone_number
      FROM
        HR.suppliers s
        LEFT JOIN HR.supplier_phone_num spn ON s.sup_id = spn.sup_id
    `;

    const result = await connection.execute(query);
    const DatabaseInfoQ1a = result.rows;

    await connection.close();

    return DatabaseInfoQ1a;
  } catch (error) {
    console.error('Failed to connect or execute query.', error);
    throw error; // Propagate the error to the caller
  }
}

// Q1b
async function runQ1b() {
  try {
      const connection = await oracledb.getConnection ({
          user          : "HR",
          password      : "12345678",
          connectString : "localhost/xe"
      });

      const question1a = await connection.execute(
          `SELECT * FROM HR.supply`
      );

      const DatabaseInfoQ1a = question1a.rows;

      // console.log(DatabaseInfo);

      await connection.close();

      return DatabaseInfoQ1a;
  }
  catch (error) {
      console.log('Failed to connect.')
  }
}

// Q4a
async function runQ4a() {
  try {
      const connection = await oracledb.getConnection ({
          user          : "HR",
          password      : "12345678",
          connectString : "localhost/xe"
      });

      const question4a = await connection.execute(
          `SELECT * FROM HR.customers`
      );

      const DatabaseInfoQ4a = question4a.rows;

      // console.log(DatabaseInfo);

      await connection.close();

      return DatabaseInfoQ4a;
  }
  catch (error) {
      console.log('Failed to connect.')
  }
}

// Q4b
async function runQ4b() {
  try {
      const connection = await oracledb.getConnection ({
          user          : "HR",
          password      : "12345678",
          connectString : "localhost/xe"
      });

      const question4b = await connection.execute(
          `SELECT * FROM HR.orders`
      );

      const DatabaseInfoQ4b = question4b.rows;

      // console.log(DatabaseInfo);

      await connection.close();

      return DatabaseInfoQ4b;
  }
  catch (error) {
      console.log('Failed to connect.')
  }
}

// Q4c
async function runQ4c() {
  try {
      const connection = await oracledb.getConnection ({
          user          : "HR",
          password      : "12345678",
          connectString : "localhost/xe"
      });

      const question4c = await connection.execute(
          `SELECT * FROM HR.bolts`
      );

      const DatabaseInfoQ4c = question4c.rows;

      // console.log(DatabaseInfo);

      await connection.close();

      return DatabaseInfoQ4c;
  }
  catch (error) {
      console.log('Failed to connect.')
  }
}

// Q4d
async function runQ4d() {
  try {
      const connection = await oracledb.getConnection ({
          user          : "HR",
          password      : "12345678",
          connectString : "localhost/xe"
      });

      const question4d = await connection.execute(
          `SELECT * FROM HR.fabric_categories`
      );

      const DatabaseInfoQ4d = question4d.rows;

      // console.log(DatabaseInfo);

      await connection.close();

      return DatabaseInfoQ4d;
  }
  catch (error) {
      console.log('Failed to connect.')
  }
}

// Q4e_1
async function runQ4e() {
  try {
    const connection = await oracledb.getConnection({
      user: "HR",
      password: "12345678",
      connectString: "localhost/xe"
    });

    const query = `
      SELECT
        s.*,
        spn.sup_phone_number
      FROM
        HR.suppliers s
        LEFT JOIN HR.supplier_phone_num spn ON s.sup_id = spn.sup_id
    `;

    const result = await connection.execute(query);
    const DatabaseInfoQ4e = result.rows;

    await connection.close();

    return DatabaseInfoQ4e;
  } catch (error) {
    console.error('Failed to connect or execute query.', error);
    throw error; // Propagate the error to the caller
  }
}

// Q4f
async function runQ4f() {
  try {
      const connection = await oracledb.getConnection ({
          user          : "HR",
          password      : "12345678",
          connectString : "localhost/xe"
      });

      const question4f = await connection.execute(
          `SELECT * FROM HR.payments`
      );

      const DatabaseInfoQ4f = question4f.rows;

      // console.log(DatabaseInfo);

      await connection.close();

      return DatabaseInfoQ4f;
  }
  catch (error) {
      console.log('Failed to connect.')
  }
}

// Q4g_a
async function runQ4g_a() {
  try {
    const connection = await oracledb.getConnection({
      user: "HR",
      password: "12345678",
      connectString: "localhost/xe"
    });

    const query = `
      SELECT
        s.*,
        epn.emp_phone_number
      FROM
        HR.office_staff s
        LEFT JOIN HR.off_phone_num epn ON s.emp_id = epn.emp_id
    `;

    const result = await connection.execute(query);
    const DatabaseInfoQ4g_a = result.rows;

    await connection.close();

    return DatabaseInfoQ4g_a;
  } catch (error) {
    console.error('Failed to connect or execute query.', error);
    throw error; // Propagate the error to the caller
  }
}

// Q4g_b
async function runQ4g_b() {
  try {
    const connection = await oracledb.getConnection({
      user: "HR",
      password: "12345678",
      connectString: "localhost/xe"
    });

    const query = `
      SELECT
        s.*,
        epn.emp_phone_number
      FROM
        HR.operational_staff s
        LEFT JOIN HR.ope_phone_num epn ON s.emp_id = epn.emp_id
    `;

    const result = await connection.execute(query);
    const DatabaseInfoQ4g_b = result.rows;

    await connection.close();

    return DatabaseInfoQ4g_b;
  } catch (error) {
    console.error('Failed to connect or execute query.', error);
    throw error; // Propagate the error to the caller
  }
}

// Q4g_c
async function runQ4g_c() {
  try {
    const connection = await oracledb.getConnection({
      user: "HR",
      password: "12345678",
      connectString: "localhost/xe"
    });

    const query = `
      SELECT
        s.*,
        epn.emp_phone_number
      FROM
        HR.partner_staff s
        LEFT JOIN HR.par_phone_num epn ON s.emp_id = epn.emp_id
    `;

    const result = await connection.execute(query);
    const DatabaseInfoQ4g_c = result.rows;

    await connection.close();

    return DatabaseInfoQ4g_c;
  } catch (error) {
    console.error('Failed to connect or execute query.', error);
    throw error; // Propagate the error to the caller
  }
}

async function store(formData) {
  try {
    const connection = await oracledb.getConnection({
      user: "HR",
      password: "12345678",
      connectString: "localhost/xe"
    });

    // Insert data into the database
    const insertQuery = `
      INSERT INTO HR.suppliers (SUP_ID, SUP_NAME, SUP_ADDR, SUP_BANKACC, SUP_TAXCODE, E_ID)
      VALUES (:SUP_ID, :SUP_NAME, :SUP_ADDR, :SUP_BANKACC, :SUP_TAXCODE, :E_ID)
    `;

    const insertQuery2 = `
      INSERT INTO HR.supplier_phone_num (SUP_ID, SUP_PHONE_NUMBER)
      VALUES (:SUP_ID, :SUP_PHONE_NUMBER)
    `;

    const result = await connection.execute(insertQuery, {
      SUP_ID: formData.SUP_ID,
      SUP_NAME: formData.SUP_NAME,
      SUP_ADDR: formData.SUP_ADDR,
      SUP_BANKACC: formData.SUP_BANKACC,
      SUP_TAXCODE: formData.SUP_TAXCODE,
      E_ID: formData.E_ID
    }, { autoCommit: true });

    const result2 = await connection.execute(insertQuery2, {
      sup_id: formData.SUP_ID,
      sup_phone_number: formData.SUP_PHONE_NUMBER
    }, { autoCommit: true });

    // Close the connection
    await connection.close();
  } catch (error) {
    console.error('Failed to connect or execute SQL:', error);
    throw error; // Re-throw the error to propagate it to the caller
  }
}

runQ1a()
runQ1b()
runQ4a()
runQ4b()
runQ4c()
runQ4d()
runQ4e()
runQ4f()
runQ4g_a()
runQ4g_b()
runQ4g_c()

// app.get('/info', middleware, async(req, res) => {
app.get('/info', async(req, res) => {
      const DatabaseInfoQ1a = await runQ1a();
      const DatabaseInfoQ1b = await runQ1b();
      res.render('info', {
        styles: ['../css/infosStyle.css'],
        DatabaseInfoQ1a,
        DatabaseInfoQ1b
})})

app.get('/report', async(req, res) => {
  const DatabaseInfoQ4a = await runQ4a()
  const DatabaseInfoQ4b = await runQ4b()
  const DatabaseInfoQ4c = await runQ4c()
  const DatabaseInfoQ4d = await runQ4d()
  const DatabaseInfoQ4e = await runQ4e()
  const DatabaseInfoQ4f = await runQ4f()
  const DatabaseInfoQ4g_a = await runQ4g_a()
  const DatabaseInfoQ4g_b = await runQ4g_b()
  const DatabaseInfoQ4g_c = await runQ4g_c()
  res.render('report', {
    styles: ['../css/infosStyle.css'],
    DatabaseInfoQ4a,
    DatabaseInfoQ4b,
    DatabaseInfoQ4c,
    DatabaseInfoQ4d,
    DatabaseInfoQ4e,
    DatabaseInfoQ4f,
    DatabaseInfoQ4g_a,
    DatabaseInfoQ4g_b,
    DatabaseInfoQ4g_c
})})

app.get('/categories', async(req, res) => {
  const DatabaseInfoQ4d = await runQ4d()
  res.render('categories', {
    styles: ['../css/infosStyle.css'],
    DatabaseInfoQ4d
})})

app.post('/info/store', async (req, res) => {
  try {
    const formData = req.body;
    await store(formData);

    // Run the function to get database info
    const DatabaseInfoQ1a = await runQ1a();
    const DatabaseInfoQ1b = await runQ1b();

    res.render('info', {
      styles: ['../css/infosStyle.css'],
      DatabaseInfoQ1a,
      DatabaseInfoQ1b
    });
  } catch (error) {
    res.status(500).send('Internal Server Error');
  }
});

// Middleware
  function middleware (req, res, next)
  {
    // Extract the token from the request header or query parameter
    const token = req.query.token

    // If no token is provided, deny access
    if (!token) {
      return res.render('error', { layout: false })
    }

    // Verify the token using the secret key
    try {
      const payload = jwt.verify(token, 'secret'); // Replace 'secret' with your actual secret key
      req.user = payload.email;
      next(); // Allow access if the token is valid
    } catch (error) {
      // Invalid token
      return res.status(401).json({ message: 'Invalid token' });
    }
  }

// Login
app.get('/login', function(req, res)
{
  res.render('login', { 
    layout: false
  })
})

// Routes
route(app)

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})