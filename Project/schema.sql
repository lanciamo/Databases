#

DROP TABLE IF EXISTS relations;

CREATE TABLE relations ( #любые отношения, в т.ч. родственные, влияния, компромат))
  id SERIAL PRIMARY KEY, 
  human_entiti_id int(10) unsigned NOT NULL,  #если есть, то сильный узел отношения
  item_id int(10) unsigned NOT NULL, #на что или кого он влияет
  item_type bit NOT NULL, #0 - human_entities, 1 - legal_entities
  record_status bit NOT NULL, # 0 - for history, 1 - active
  name_of_relation varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  note varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

#

DROP TABLE IF EXISTS positions;

CREATE TABLE positions ( #должности, но не только... это сущность, как бы "разъем" компании, "место" в компании у которого может быть телефон и email и адрес, но может не быть человека
  id SERIAL PRIMARY KEY,      
  legal_entitie_id int(10) unsigned NOT NULL,
  record_status bit NOT NULL, # 0 - for history, 1 - active
  name varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  human_entitie_id int(10) unsigned DEFAULT NULL,
  parent_position_id varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

#

DROP TABLE IF EXISTS legal_entities;

CREATE TABLE legal_entities (
  id SERIAL PRIMARY KEY,
  name varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  pseudoname varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,    
  shortname varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  record_status bit NOT NULL, # 0 - for history, 1 - active    
  registration_date datetime DEFAULT NULL,
  INN varchar(20) DEFAULT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() 
);

#

DROP TABLE IF EXISTS emails;

CREATE TABLE emails (
  id SERIAL PRIMARY KEY,      
  item_id int(10) unsigned NOT NULL,
  item_type bit NOT NULL, #0 - human_entities, 1 - legal_entities
  record_status bit NOT NULL, # 0 - for history, 1 - active
  email varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  name_of_email varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

#

DROP TABLE IF EXISTS addresses;

CREATE TABLE addresses (
  id SERIAL PRIMARY KEY,      
  item_id int(10) unsigned NOT NULL,
  item_type bit NOT NULL, #0 - human_entities, 1 - legal_entities
  record_status bit NOT NULL, # 0 - for history, 1 - active
    -- address
  country varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  post_index varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  locality varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL, #or city   
  parent_locality varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  Addr01 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  Addr02 varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  to_whom varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,    
    -- address
  name_of_address varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

#

DROP TABLE IF EXISTS phones;

CREATE TABLE phones (
  id SERIAL PRIMARY KEY,      
  item_id int(10) unsigned NOT NULL,
  item_type bit NOT NULL, #0 - human_entities, 1 - legal_entities
  record_status bit NOT NULL, # 0 - for history, 1 - active
  number varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  name_of_number varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

#

DROP TABLE IF EXISTS human_entities;

CREATE TABLE human_entities (  # people
  id SERIAL PRIMARY KEY,
  firstname varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  midname varchar(100) COLLATE utf8_unicode_ci,    
  lastname varchar(100) COLLATE utf8_unicode_ci,
  sex bit, # 0 - female, 1 - male    
  birthday date,
  INN varchar(20),
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);


DROP TABLE IF EXISTS tracker;

CREATE TABLE tracker (
  id SERIAL PRIMARY KEY,      
  user_id int(10) unsigned NOT NULL,
  contact_through int(10) unsigned NOT NULL, # 
  contact_type int(10) unsigned NOT NULL, #phone, email, messengers, a meeting... etc.
  contact_status bit NOT NULL, # 0 - incoming, 1 - outcoming
  content_id int(10) unsigned DEFAULT NULL, # content or note about the conversation
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

DROP TABLE IF EXISTS tasks;

CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,      
  user_id int(10) unsigned NOT NULL,
  contact_through int(10) unsigned NOT NULL, # 
  contact_type int(10) unsigned NOT NULL, #phone, email, messengers, a meeting... etc.
  contact_status bit NOT NULL, # 0 - incoming, 1 - outcoming
  content_id int(10) unsigned DEFAULT NULL, # content or note about the conversation
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

DROP TABLE IF EXISTS users;

CREATE TABLE users (  # copmany workers
  id SERIAL PRIMARY KEY,
  firstname varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  midname varchar(100) COLLATE utf8_unicode_ci,    
  lastname varchar(100) COLLATE utf8_unicode_ci,
  sex bit, # 0 - female, 1 - male    
  birthday date,
  INN varchar(20),
  role_enum ENUM('manager', 'admin', 'SDO'),  worker_since_at datetime DEFAULT NULL,
  worker_until_at datetime DEFAULT NULL,
  created_at datetime DEFAULT current_timestamp(),
  updated_at datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
);

ALTER TABLE relations
  ADD CONSTRAINT relations_human_id_fk 
    FOREIGN KEY (human_entiti_id) REFERENCES human_entities(id)
      ON DELETE CASCADE;

