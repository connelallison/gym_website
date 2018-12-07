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
  name VARCHAR(255),
  capacity INT,
  peak BOOLEAN
);

CREATE TABLE members_lessons (
  id SERIAL PRIMARY KEY,
  member_id INT REFERENCES members(id) ON DELETE CASCADE,
  lesson_id INT REFERENCES lessons(id) ON DELETE CASCADE
);
