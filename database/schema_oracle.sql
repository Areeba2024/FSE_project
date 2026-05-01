-- SCMS Oracle SQL Schema
-- Run in SQL*Plus or SQL Developer

-- Drop tables if exist (run only if resetting)
BEGIN EXECUTE IMMEDIATE 'DROP TABLE notifications CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE feedback CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE status_logs CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE assignments CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE complaints CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE users CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE users_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE complaints_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE assignments_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE status_logs_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE feedback_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE notifications_seq'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Sequences (auto-increment replacement)
CREATE SEQUENCE users_seq         START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE complaints_seq    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE assignments_seq   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE status_logs_seq   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE feedback_seq      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE notifications_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- USERS
CREATE TABLE users (
    id            NUMBER PRIMARY KEY,
    name          VARCHAR2(100)  NOT NULL,
    email         VARCHAR2(150)  NOT NULL UNIQUE,
    password_hash VARCHAR2(255)  NOT NULL,
    role          VARCHAR2(20)   DEFAULT 'user' NOT NULL
                  CONSTRAINT chk_user_role CHECK (role IN ('user','technician','admin','superadmin')),
    department    VARCHAR2(100),
    phone         VARCHAR2(20),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE TRIGGER users_bir
BEFORE INSERT ON users FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT users_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- COMPLAINTS
CREATE TABLE complaints (
    id             NUMBER PRIMARY KEY,
    user_id        NUMBER        NOT NULL,
    title          VARCHAR2(200) NOT NULL,
    description    CLOB          NOT NULL,
    category       VARCHAR2(30)  NOT NULL
                   CONSTRAINT chk_category CHECK (category IN ('electricity','internet','plumbing','cleaning','hvac','furniture','security','other')),
    priority       VARCHAR2(10)  DEFAULT 'medium'
                   CONSTRAINT chk_priority CHECK (priority IN ('low','medium','high','urgent')),
    status         VARCHAR2(20)  DEFAULT 'submitted'
                   CONSTRAINT chk_status CHECK (status IN ('submitted','under_review','assigned','in_progress','resolved','closed','rejected')),
    location       VARCHAR2(200),
    attachment_url VARCHAR2(255),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_complaint_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER complaints_bir
BEFORE INSERT ON complaints FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT complaints_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER complaints_bur
BEFORE UPDATE ON complaints FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- ASSIGNMENTS
CREATE TABLE assignments (
    id            NUMBER PRIMARY KEY,
    complaint_id  NUMBER NOT NULL,
    technician_id NUMBER NOT NULL,
    assigned_by   NUMBER NOT NULL,
    assigned_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes         CLOB,
    CONSTRAINT fk_assign_complaint   FOREIGN KEY (complaint_id)  REFERENCES complaints(id) ON DELETE CASCADE,
    CONSTRAINT fk_assign_technician  FOREIGN KEY (technician_id) REFERENCES users(id),
    CONSTRAINT fk_assign_by          FOREIGN KEY (assigned_by)   REFERENCES users(id)
);

CREATE OR REPLACE TRIGGER assignments_bir
BEFORE INSERT ON assignments FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT assignments_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- STATUS LOGS
CREATE TABLE status_logs (
    id           NUMBER PRIMARY KEY,
    complaint_id NUMBER        NOT NULL,
    changed_by   NUMBER        NOT NULL,
    old_status   VARCHAR2(20),
    new_status   VARCHAR2(20)  NOT NULL,
    remarks      CLOB,
    changed_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    CONSTRAINT fk_log_user      FOREIGN KEY (changed_by)   REFERENCES users(id)
);

CREATE OR REPLACE TRIGGER status_logs_bir
BEFORE INSERT ON status_logs FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT status_logs_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- FEEDBACK
CREATE TABLE feedback (
    id           NUMBER PRIMARY KEY,
    complaint_id NUMBER UNIQUE NOT NULL,
    user_id      NUMBER        NOT NULL,
    rating       NUMBER(1)     CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
    comment      CLOB,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fb_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
    CONSTRAINT fk_fb_user      FOREIGN KEY (user_id)      REFERENCES users(id)
);

CREATE OR REPLACE TRIGGER feedback_bir
BEFORE INSERT ON feedback FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT feedback_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- NOTIFICATIONS
CREATE TABLE notifications (
    id           NUMBER PRIMARY KEY,
    user_id      NUMBER        NOT NULL,
    complaint_id NUMBER,
    message      VARCHAR2(300) NOT NULL,
    is_read      NUMBER(1)     DEFAULT 0 CONSTRAINT chk_is_read CHECK (is_read IN (0,1)),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user      FOREIGN KEY (user_id)      REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_notif_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE SET NULL
);

CREATE OR REPLACE TRIGGER notifications_bir
BEFORE INSERT ON notifications FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT notifications_seq.NEXTVAL INTO :NEW.id FROM dual;
    END IF;
END;
/

-- Indexes
CREATE INDEX idx_complaints_user     ON complaints(user_id);
CREATE INDEX idx_complaints_status   ON complaints(status);
CREATE INDEX idx_complaints_category ON complaints(category);
CREATE INDEX idx_assignments_comp    ON assignments(complaint_id);
CREATE INDEX idx_notif_user          ON notifications(user_id);

COMMIT;
