-- Smart Complaint & Service Management System
-- Database Schema

CREATE DATABASE IF NOT EXISTS scms_db;
USE scms_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('user','technician','admin','superadmin') DEFAULT 'user',
  department VARCHAR(100),
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE complaints (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  category ENUM('electricity','internet','plumbing','cleaning','hvac','furniture','security','other') NOT NULL,
  priority ENUM('low','medium','high','urgent') DEFAULT 'medium',
  status ENUM('submitted','under_review','assigned','in_progress','resolved','closed','rejected') DEFAULT 'submitted',
  location VARCHAR(200),
  attachment_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE assignments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  complaint_id INT NOT NULL,
  technician_id INT NOT NULL,
  assigned_by INT NOT NULL,
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  notes TEXT,
  FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
  FOREIGN KEY (technician_id) REFERENCES users(id),
  FOREIGN KEY (assigned_by) REFERENCES users(id)
);

CREATE TABLE status_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  complaint_id INT NOT NULL,
  changed_by INT NOT NULL,
  old_status VARCHAR(50),
  new_status VARCHAR(50) NOT NULL,
  remarks TEXT,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
  FOREIGN KEY (changed_by) REFERENCES users(id)
);

CREATE TABLE feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  complaint_id INT UNIQUE NOT NULL,
  user_id INT NOT NULL,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  complaint_id INT,
  message VARCHAR(300) NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE SET NULL
);

-- Indexes
CREATE INDEX idx_complaints_user ON complaints(user_id);
CREATE INDEX idx_complaints_status ON complaints(status);
CREATE INDEX idx_complaints_category ON complaints(category);
CREATE INDEX idx_assignments_complaint ON assignments(complaint_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);

-- Seed admin user (password: admin123)
INSERT INTO users (name, email, password_hash, role) VALUES
('Super Admin', 'admin@scms.edu', '$2b$10$examplehashedpassword', 'superadmin');
