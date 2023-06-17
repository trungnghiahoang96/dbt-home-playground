CREATE SCHEMA IF NOT EXISTS postgres;

CREATE TABLE IF NOT EXISTS postgres.customer
(
   id         BIGSERIAL PRIMARY KEY,
   email      TEXT                                   NOT NULL,
   username   TEXT                                   NOT NULL,
   activated  BOOLEAN                  DEFAULT FALSE,
   created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);


INSERT INTO postgres.customer (id, email, username, activated, created_at) VALUES (2, 'asm0dey@jetbrains.com', 'asm0dey', true, '2022-01-13 13:59:38.029016 +00:00');
INSERT INTO postgres.customer (id, email, username, activated, created_at) VALUES (3, 'pavel.finkelshteyn@jetbrains.com', 'asm0dey', true, '2022-01-13 18:05:22.305746 +00:00');


CREATE TABLE IF NOT EXISTS postgres.post
(
   id         BIGSERIAL PRIMARY KEY,
   author     BIGINT                                 NOT NULL REFERENCES postgres.customer,
   content    TEXT,
   created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

INSERT INTO postgres.post (id, author, content, created_at) VALUES (1, 2, 'Hello, world!', '2022-01-13 13:59:59.911324 +00:00');



CREATE TABLE IF NOT EXISTS postgres.comment
(
   id         BIGSERIAL PRIMARY KEY,
   author     BIGINT                                 NOT NULL REFERENCES postgres.customer,
   content    TEXT,
   created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
   post       BIGINT                                 NOT NULL REFERENCES postgres.post
);


INSERT INTO postgres.comment (id, author, content, created_at, post) VALUES (1, 3, 'Test Comment', '2022-01-13 18:06:08.872014 +00:00', 1);
