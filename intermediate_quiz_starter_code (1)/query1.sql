/*
-- Citation for the following code: Code Syntax and Templates provided from CS340 @ OSU Activity 4,5,6, 7, and 8
-- Original work, no AI tools were used.
*/
CREATE TABLE client (
    id int(11) NOT NULL AUTO_INCREMENT,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    CONSTRAINT full_name UNIQUE (first_name, last_name),
    PRIMARY KEY (id)
);

CREATE TABLE employee (
    id int(11) NOT NULL AUTO_INCREMENT,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    start_date date NOT NULL,
    email varchar(255) NOT NULL,
    CONSTRAINT full_name UNIQUE (first_name, last_name),
    PRIMARY KEY (id)
);

CREATE TABLE project (
    id int(11) NOT NULL AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    comments text,
    cid int,
    UNIQUE (title),
    PRIMARY KEY (id),
    FOREIGN KEY (cid) REFERENCES client(id)
);

CREATE TABLE works_on (
    pid int(11),
    eid int(11),
    due_date date NOT NULL,
    
    FOREIGN KEY (pid) REFERENCES project(id),
    FOREIGN KEY (eid) REFERENCES employee(id),
    PRIMARY KEY (eid, pid)
);
