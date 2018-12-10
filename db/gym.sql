DROP TABLE IF EXISTS conditions;
DROP TABLE IF EXISTS physios;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS members_lessons;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS members;

CREATE TABLE members (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  premium BOOLEAN
);

CREATE TABLE lessons (
  id SERIAL PRIMARY KEY,
  course VARCHAR(255),
  capacity INT,
  peak BOOLEAN
);

CREATE TABLE members_lessons (
  id SERIAL PRIMARY KEY,
  member_id INT REFERENCES members(id) ON DELETE CASCADE,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE
);

 CREATE TABLE patients (
   id SERIAL PRIMARY KEY,
   patient_name VARCHAR(255),
   member_id INT REFERENCES members(id)
 );

 CREATE TABLE physios (
   id SERIAL PRIMARY KEY,
   physio_name VARCHAR(255)
 );

 CREATE TABLE conditions (
   id SERIAL PRIMARY KEY,
   patient_id INT REFERENCES patients(id) ON DELETE CASCADE,
   physio_id INT REFERENCES physios(id) ON DELETE CASCADE,
   type VARCHAR(255),
   diagnosed DATE,
   resolved BOOLEAN
 );
