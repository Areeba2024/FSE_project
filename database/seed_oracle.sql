-- SCMS Oracle Seed Data — Run AFTER schema_oracle.sql
-- All passwords = Password123

INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Super Admin',     'superadmin@scms.edu', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'superadmin', 'IT',              '03001111111');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Admin User',      'admin@scms.edu',      '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'admin',      'Administration',  '03002222222');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Ali Hassan',      'ali@scms.edu',        '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'technician', 'Maintenance',     '03003333333');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Bilal Ahmed',     'bilal@scms.edu',      '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'technician', 'Maintenance',     '03004444444');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Areeba Imran',    'areeba@scms.edu',     '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Computer Science','03005555555');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Shahzaib Zaheer', 'shahzaib@scms.edu',   '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Computer Science','03006666666');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Sara Khan',       'sara@scms.edu',       '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Electrical Eng',  '03007777777');
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Hamid Ali',       'hamid@scms.edu',      '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Business Admin',  '03008888888');

INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(5, 'Power outage in Computer Lab 3',   'Complete power failure. All 30 computers off. Ongoing for 2 hours.', 'electricity', 'high',   'in_progress', 'Block A, Lab 3');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(6, 'WiFi not working in Library',      'WiFi drops every 10 minutes in reading hall. Very disruptive.',       'internet',    'medium', 'submitted',   'Main Library');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(7, 'AC not cooling in Room 204',       'AC unit is running but temperature stays at 35 degrees.',             'hvac',        'high',   'assigned',    'Block B, Room 204');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(8, 'Water leakage near washroom',      'Pipe burst on ground floor causing water to flood the corridor.',     'plumbing',    'urgent', 'resolved',    'Ground Floor Corridor');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(5, 'Projector bulb burnt in Hall 2',   'Projector shows no image. Bulb needs urgent replacement.',            'electricity', 'medium', 'closed',      'Lecture Hall 2');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(6, 'Classroom not cleaned for 3 days', 'Trash bins overflowing, floor dirty. Health concern.',               'cleaning',    'low',    'under_review','Block C, Room 101');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(7, 'Network switch down in Block D',   'Entire Block D has no internet since yesterday morning.',             'internet',    'urgent', 'assigned',    'Block D, Server Room');
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(8, 'Broken chair in Seminar Room',     'Two chairs have broken legs. Risk of injury to students.',            'furniture',   'medium', 'submitted',   'Seminar Room 1');

INSERT INTO assignments (complaint_id, technician_id, assigned_by, notes) VALUES (1, 3, 2, 'Check main distribution board. Carry replacement fuses.');
INSERT INTO assignments (complaint_id, technician_id, assigned_by, notes) VALUES (3, 4, 2, 'Inspect AC unit in Room 204. May need refrigerant top-up.');
INSERT INTO assignments (complaint_id, technician_id, assigned_by, notes) VALUES (4, 3, 2, 'Fix burst pipe. Bring pipe clamp and sealant.');
INSERT INTO assignments (complaint_id, technician_id, assigned_by, notes) VALUES (5, 4, 2, 'Replace projector bulb. Model: Epson EB-X05.');
INSERT INTO assignments (complaint_id, technician_id, assigned_by, notes) VALUES (7, 3, 2, 'Replace faulty network switch in Block D server room.');

INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (1, 5, NULL, 'submitted', 'Complaint submitted');
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (1, 2, 'submitted', 'assigned', 'Assigned to Ali Hassan');
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (1, 3, 'assigned', 'in_progress', 'Started inspection');
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (4, 8, NULL, 'submitted', 'Complaint submitted');
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (4, 3, 'assigned', 'resolved', 'Pipe repaired and sealed.');
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (5, 4, 'assigned', 'resolved', 'Bulb replaced successfully');
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES (5, 5, 'resolved', 'closed', 'User gave feedback');

INSERT INTO feedback (complaint_id, user_id, rating, comment) VALUES (4, 8, 5, 'Very fast response! Professional and fixed it within an hour.');
INSERT INTO feedback (complaint_id, user_id, rating, comment) VALUES (5, 5, 4, 'Good work, projector is working fine now.');

INSERT INTO notifications (user_id, complaint_id, message) VALUES (5, 1, 'Your complaint #1 has been assigned to Ali Hassan');
INSERT INTO notifications (user_id, complaint_id, message) VALUES (3, 1, 'You have been assigned complaint #1');
INSERT INTO notifications (user_id, complaint_id, message) VALUES (7, 3, 'Your complaint #3 has been assigned to Bilal Ahmed');

COMMIT;
