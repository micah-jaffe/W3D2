PRAGMA foreign_keys = ON;

create table users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

create table questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

create table question_follows(
  user_id INTEGER,
  question_id INTEGER,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

create table replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

create table question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Micah', 'Jaffe'),
  ('Chase', 'Lim');
  
INSERT INTO
  questions (title, body, author_id)
VALUES
  ('How do you do Ruby good???',
  'How do ruby????????',
  (SELECT id FROM users WHERE fname = 'Micah')),
  
  ('How do u turn on computer?!',
  'computer not turn on how turn on screen all black :(',
  (SELECT id FROM users WHERE fname = 'Chase'));
  
INSERT INTO 
  question_follows (user_id, question_id)
VALUES
  (2, 1),
  (1, 2);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 2, 'do app academy u dummy'),
  (1, 1, 1, 'thanks Chase u da man!!!!!!!!');
  
INSERT INTO 
  question_likes (user_id, question_id)
VALUES
  (1, 1),
  (2, 1);
  

  