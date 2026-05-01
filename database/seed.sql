-- SCMS Seed Data — Run AFTER schema.sql
USE scms_db;

-- Seed Users (passwords are all: Password123)
-- Hash generated with bcrypt rounds=10
INSERT INTO users (name, email, password_hash, role, department, phone) VALUES
('Super Admin',    'superadmin@scms.edu', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'superadmin', 'IT',          '03001111111'),
('Admin User',     'admin@scms.edu',      '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'admin',      'Administration','03002222222'),
('Ali Hassan',     'ali@scms.edu',        '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'technician', 'Maintenance',   '03003333333'),
('Bilal Ahmed',    'bilal@scms.edu',      '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'technician', 'Maintenance',   '03004444444'),
('Areeba Imran',   'areeba@scms.edu',     '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Computer Science','03005555555'),
('Shahzaib Zaheer','shahzaib@scms.edu',   '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Computer Science','03006666666'),
('Sara Khan',      'sara@scms.edu',       '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Electrical Eng',  '03007777777'),
('Hamid Ali',      'hamid@scms.edu',      '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHmy', 'user',       'Business Admin',  '03008888888');

-- Seed Complaints
INSERT INTO complaints (user_id, title, description, category, priority, status, location) VALUES
(5, 'Power outage in Computer Lab 3',    'Complete power failure. All 30 computers off. Ongoing for 2 hours.', 'electricity', 'high',   'in_progress', 'Block A, Lab 3'),
(6, 'WiFi not working in Library',       'WiFi drops every 10 minutes in reading hall. Very disruptive.',       'internet',    'medium', 'submitted',   'Main Library'),
(7, 'AC not cooling in Room 204',        'AC unit is running but temperature stays at 35 degrees Celsius.',     'hvac',        'high',   'assigned',    'Block B, Room 204'),
(8, 'Water leakage near washroom',       'Pipe burst on ground floor causing water to flood the corridor.',     'plumbing',    'urgent', 'resolved',    'Ground Floor Corridor'),
(5, 'Projector bulb burnt in Hall 2',    'Projector shows no image. Bulb needs urgent replacement.',            'electricity', 'medium', 'closed',      'Lecture Hall 2'),
(6, 'Classroom not cleaned for 3 days', 'Trash bins overflowing, floor dirty. Health concern.',                'cleaning',    'low',    'under_review','Block C, Room 101'),
(7, 'Network switch down in Block D',    'Entire Block D has no internet since yesterday morning.',             'internet',    'urgent', 'assigned',    'Block D, Server Room'),
(8, 'Broken chair in Seminar Room',      'Two chairs have broken legs. Risk of injury to students.',            'furniture',   'medium', 'submitted',   'Seminar Room 1');

-- Assignments
INSERT INTO assignments (complaint_id, technician_id, assigned_by, notes) VALUES
(1, 3, 2, 'Check main distribution board in Lab 3. Carry replacement fuses.'),
(3, 4, 2, 'Inspect AC unit in Room 204. May need refrigerant top-up.'),
(4, 3, 2, 'Fix burst pipe. Bring pipe clamp and sealant.'),
(5, 4, 2, 'Replace projector bulb. Model: Epson EB-X05.'),
(7, 3, 2, 'Replace faulty network switch in Block D server room.');

-- Update statuses
UPDATE complaints SET status='in_progress' WHERE id=1;
UPDATE complaints SET status='resolved'    WHERE id=4;
UPDATE complaints SET status='closed'      WHERE id=5;

-- Status logs
INSERT INTO status_logs (complaint_id, changed_by, old_status, new_status, remarks) VALUES
(1, 5, NULL,           'submitted',    'Complaint submitted by user'),
(1, 2, 'submitted',    'under_review', 'Admin reviewing'),
(1, 2, 'under_review', 'assigned',     'Assigned to Ali Hassan'),
(1, 3, 'assigned',     'in_progress',  'Started inspection of distribution board'),
(3, 7, NULL,           'submitted',    'Complaint submitted'),
(3, 2, 'submitted',    'assigned',     'Assigned to Bilal Ahmed'),
(4, 8, NULL,           'submitted',    'Complaint submitted'),
(4, 2, 'submitted',    'assigned',     'Assigned to Ali Hassan'),
(4, 3, 'assigned',     'in_progress',  'On site, fixing pipe'),
(4, 3, 'in_progress',  'resolved',     'Pipe repaired and sealed. Corridor cleaned.'),
(5, 5, NULL,           'submitted',    'Complaint submitted'),
(5, 2, 'submitted',    'assigned',     'Assigned to Bilal Ahmed'),
(5, 4, 'assigned',     'resolved',     'Bulb replaced successfully'),
(5, 5, 'resolved',     'closed',       'User gave feedback');

-- Feedback
INSERT INTO feedback (complaint_id, user_id, rating, comment) VALUES
(4, 8, 5, 'Very fast response! The technician was professional and fixed it within an hour.'),
(5, 5, 4, 'Good work, projector is working fine now. Took a bit longer than expected.');

-- Notifications
INSERT INTO notifications (user_id, complaint_id, message) VALUES
(5, 1, 'Your complaint #1 has been assigned to Ali Hassan'),
(5, 1, 'Your complaint #1 status updated to: in_progress'),
(3, 1, 'You have been assigned complaint #1 - Power outage in Computer Lab 3'),
(7, 3, 'Your complaint #3 has been assigned to Bilal Ahmed'),
(3, 7, 'You have been assigned complaint #7 - Network switch down in Block D');
