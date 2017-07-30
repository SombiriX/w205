DROP DATABASE IF EXISTS tcount;
CREATE DATABASE tcount;

\connect tcount

DROP TABLE IF EXISTS tweetwordcount;
CREATE TABLE tweetwordcount(
   word text PRIMARY KEY NOT NULL,
   count integer NOT NULL  
);
