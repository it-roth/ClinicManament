-- Create Database                               
CREATE DATABASE ClinicManagement;                                                                               
GO

USE ClinicManagement;
GO 

-- Doctors table
CREATE TABLE Doctors (
    DocID VARCHAR(10) PRIMARY KEY,
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female')),
    Specialize VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) CHECK (LEN(DPhone) BETWEEN 10 AND 15),
    Email VARCHAR(100) CHECK (DEmail LIKE '%@%.%')
);

-- FullTime table
CREATE TABLE FullTime (
    DocID VARCHAR(10) PRIMARY KEY,
    Qualification VARCHAR(100) NOT NULL,
    CONSTRAINT FK_FullTime_DocID FOREIGN KEY (DocID) REFERENCES Doctors(DocID)
);

-- PartTime table
CREATE TABLE PartTime (
    DocID VARCHAR(10) PRIMARY KEY,
    Hour_worked INTEGER NOT NULL CHECK (Hour_worked > 0),
    CONSTRAINT FK_PartTime_DocID FOREIGN KEY (DocID) REFERENCES Doctors(DocID)
);

-- Patients table
CREATE TABLE Patients (
    PatID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female')),
    PatDOB DATE NOT NULL,
    CONSTRAINT chk_PatDOB CHECK (PatDOB <= GETDATE())
);

-- PatPhone table
CREATE TABLE PatPhone (
    PatID VARCHAR(10) PRIMARY KEY,
    PatPhone VARCHAR(15),
    CHECK (LEN(PatPhone) BETWEEN 10 AND 15),
    CONSTRAINT FK_PatPhone_PatID FOREIGN KEY (PatID) REFERENCES Patients(PatID)
);

-- PatAddress table
CREATE TABLE PatAddress (
    PatID VARCHAR(10) PRIMARY KEY,
    PatAddress VARCHAR(50) NOT NULL,
    CONSTRAINT FK_PatAddress_PatID FOREIGN KEY (PatID) REFERENCES Patients(PatID)
);

-- Appointments table
CREATE TABLE Appointments (
    AppID INT PRIMARY KEY IDENTITY,
    DocID VARCHAR(10),
    PatID VARCHAR(10),
    AppDate DATE NOT NULL,
    Reason VARCHAR(255) CHECK (LEN(Reason) > 0),
    CONSTRAINT FK_Appointments_DocID FOREIGN KEY (DocID) REFERENCES Doctors(DocID),
    CONSTRAINT FK_Appointments_PatID FOREIGN KEY (PatID) REFERENCES Patients(PatID),
    CONSTRAINT chk_AppDate CHECK (AppDate >= GETDATE())
);

-- Rooms table
CREATE TABLE Rooms (
    RoomID VARCHAR(10) PRIMARY KEY,
    PatID VARCHAR(10),
    RoomType VARCHAR(50) CHECK (RoomType IN ('Single', 'Double', 'Suite')),
    AvailableStatus CHAR(1) CHECK (AvailableStatus IN ('A', 'O')),
    CONSTRAINT FK_Rooms_PatID FOREIGN KEY (PatID) REFERENCES Patients(PatID)
);

-- MedicalHistorys table
CREATE TABLE MedicalHistorys (
    HistoryID INT PRIMARY KEY IDENTITY,
    PatID VARCHAR(10) NOT NULL,
    Diagnosis VARCHAR(255) NOT NULL CHECK (LEN(Diagnosis) > 0),
    Treatment VARCHAR(255) NOT NULL CHECK (LEN(Treatment) > 0), 
    VisitDate DATE NOT NULL CHECK (VisitDate <= GETDATE()),
    CONSTRAINT FK_MedicalHistorys_PatID FOREIGN KEY (PatID) REFERENCES Patients(PatID)
);

-- AdminCheckOut table
CREATE TABLE AdminCheckOut (
    CheckOutID INT PRIMARY KEY IDENTITY,
    PatID VARCHAR(10) NOT NULL,
    RoomID VARCHAR(10) NOT NULL,
    TotalAmount DECIMAL(10, 2) CHECK (TotalAmount >= 0),
    Payment DECIMAL(10, 2) CHECK (Payment >= 0), 
    DischargeDate DATE NOT NULL CHECK (DischargeDate <= GETDATE()), 
    CHECK (Payment = TotalAmount),
    CONSTRAINT FK_AdminCheckOut_PatID FOREIGN KEY (PatID) REFERENCES Patients(PatID),
    CONSTRAINT FK_AdminCheckOut_RoomID FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- Insert data into Doctors table
INSERT INTO Doctors (DocID, Fname, Lname, Gender, Specialize, DPhone, DEmail)
VALUES
('D001', 'John', 'Doe', 'Male', 'Cardiologist', '1234567890', 'john.doe@example.com'),
('D002', 'Alice', 'Smith', 'Female', 'Pediatrician', '1234567891', 'alice.smith@example.com'),
('D003', 'Robert', 'Brown', 'Male', 'Dermatologist', '1234567892', 'robert.brown@example.com'),
('D004', 'Emma', 'Jones', 'Female', 'Neurologist', '1234567893', 'emma.jones@example.com'),
('D005', 'William', 'Taylor', 'Male', 'Orthopedic', '1234567894', 'william.taylor@example.com'),
('D006', 'Sophia', 'Johnson', 'Female', 'Psychiatrist', '1234567895', 'sophia.johnson@example.com'),
('D007', 'James', 'Williams', 'Male', 'Surgeon', '1234567896', 'james.williams@example.com'),
('D008', 'Chris', 'Evans', 'Male', 'Endocrinologist', '1234567897', 'chris.evans@example.com'),
('D009', 'Emma', 'Watson', 'Female', 'Gastroenterologist', '1234567898', 'emma.watson@example.com'),
('D010', 'Ryan', 'Reynolds', 'Male', 'Oncologist', '1234567899', 'ryan.reynolds@example.com'),
('D011', 'Sophia', 'Loren', 'Female', 'Gynecologist', '1234567800', 'sophia.loren@example.com'),
('D012', 'David', 'Beckham', 'Male', 'Sports Medicine', '1234567801', 'david.beckham@example.com'),
('D013', 'Mila', 'Kunis', 'Female', 'Pulmonologist', '1234567802', 'mila.kunis@example.com'),
('D014', 'Brad', 'Pitt', 'Male', 'Radiologist', '1234567803', 'brad.pitt@example.com'),
('D015', 'Angelina', 'Jolie', 'Female', 'Pediatric Surgeon', '1234567804', 'angelina.jolie@example.com');

-- Insert data into FullTime table
INSERT INTO FullTime (DocID, Qualification)
VALUES
('D001', 'MD in Cardiology'),
('D002', 'MD in Pediatrics'),
('D003', 'MD in Dermatology'),
('D006', 'PhD in Psychiatry'),
('D008', 'MD in Endocrinology'),
('D009', 'MD in Gastroenterology'),
('D010', 'MD in Oncology'),
('D011', 'MD in Gynecology');

-- Insert data into PartTime table
INSERT INTO PartTime (DocID, Hour_worked)
VALUES
('D004', 20),
('D005', 15),
('D007', 25),
('D012', 30),
('D013', 18),
('D014', 22),
('D015', 16);

-- Insert data into Patients table
INSERT INTO Patients (PatID, Name, Gender, PatDOB)
VALUES
('P001', 'Michael Green', 'Male', '1990-05-15'),
('P002', 'Sophia White', 'Female', '1985-07-20'),
('P003', 'James Black', 'Male', '1978-02-12'),
('P004', 'Emily Rose', 'Female', '2000-09-30'),
('P005', 'David Hill', 'Male', '1995-11-25'),
('P006', 'Olivia Brown', 'Female', '1992-03-10'),
('P007', 'Daniel Wilson', 'Male', '1988-08-05'),
('P008', 'Jessica Alba', 'Female', '1983-04-14'),
('P009', 'Chris Pratt', 'Male', '1979-06-21'),
('P010', 'Scarlett Johansson', 'Female', '1984-11-22'),
('P011', 'Hugh Jackman', 'Male', '1968-10-12'),
('P012', 'Anne Hathaway', 'Female', '1982-11-12'),
('P013', 'Tom Cruise', 'Male', '1962-07-03'),
('P014', 'Natalie Portman', 'Female', '1981-06-09');

-- Insert data into PatPhone table
INSERT INTO PatPhone (PatID, PatPhone)
VALUES
('P002', '9876543211'),
('P003', '9876543212'),
('P004', '9876543213'),
('P005', '9876543214'),
('P006', '9876543215'),
('P007', '9876543216'),
('P008', '9876543217'),
('P009', '9876543218'),
('P010', '9876543219'),
('P011', '9876543220'),
('P012', '9876543221'),
('P013', '9876543222'),
('P014', '9876543223');

-- Insert data into PatAddress table
INSERT INTO PatAddress (PatID, PatAddress)
VALUES
('P002', '456 Maple Ave'),
('P003', '789 Oak Dr'),
('P004', '321 Pine Ln'),
('P005', '654 Elm Blvd'),
('P006', '987 Birch Rd'),
('P007', '741 Cedar Ct'),
('P008', '369 Cypress Pl'),
('P009', '159 Fir St'),
('P010', '753 Willow Dr'),
('P011', '951 Spruce Ct'),
('P012', '357 Alder Rd'),
('P013', '753 Pineapple Blvd'),
('P014', '951 Lemon Ln');

-- Insert data into Appointments table
INSERT INTO Appointments (DocID, PatID, AppDate, Reason)
VALUES
('D001', 'P001', GETDATE() + 10, 'Routine Checkup'),
('D002', 'P002', GETDATE() + 11, 'Fever and Cold'),
('D003', 'P003', GETDATE() + 12, 'Skin Rash'),
('D004', 'P004', GETDATE() + 13, 'Migraine'),
('D005', 'P005', GETDATE() + 14, 'Knee Pain'),
('D006', 'P006', GETDATE() + 15, 'Stress Management'),
('D007', 'P007', GETDATE() + 16, 'Post-Surgery Follow-up'),
('D008', 'P008', GETDATE() + 17, 'Hormonal Imbalance'),
('D009', 'P009', GETDATE() + 18, 'Gastric Issue'),
('D010', 'P010', GETDATE() + 19, 'Cancer Consultation'),
('D011', 'P011', GETDATE() + 20, 'Pregnancy Checkup'),
('D012', 'P012', GETDATE() + 21, 'Sports Injury'),
('D013', 'P013', GETDATE() + 22, 'Breathing Problems'),
('D014', 'P014', GETDATE() + 23, 'Radiology Report Discussion');

-- Insert data into Rooms table with unique RoomID values
INSERT INTO Rooms (RoomID, PatID, RoomType, AvailableStatus)
VALUES
('R001', 'P002', 'Double', 'O'),
('R002', 'P003', 'Single', 'O'),  
('R004', NULL, 'Single', 'A'),
('R005', 'P005', 'Double', 'O'),
('R006', 'P006', 'Single', 'O'),
('R007', 'P007', 'Suite', 'O'),
('R008', 'P008', 'Double', 'O'),
('R009', 'P009', 'Single', 'O'),
('R010', 'P010', 'Suite', 'O'),
('R011', 'P011', 'Single', 'O'),
('R012', 'P012', 'Double', 'O'),
('R013', 'P013', 'Suite', 'O'),
('R014', 'P014', 'Single', 'O');

-- Insert data into AdminCheckOut table with valid RoomID references
INSERT INTO AdminCheckOut (PatID, RoomID, TotalAmount, Payment, DischargeDate)
VALUES
('P001', 'R001', 500.00, 500.00, '2024-01-15'),
('P002', 'R002', 300.00, 300.00, '2024-01-16'),
('P003', 'R005', 400.00, 400.00, '2024-01-17'), 
('P006', 'R006', 600.00, 600.00, '2024-01-18'),
('P007', 'R007', 800.00, 800.00, '2024-01-19'),
('P008', 'R008', 700.00, 700.00, '2024-01-20'),
('P009', 'R009', 450.00, 450.00, '2024-01-21');

-- Insert data into MedicalHistories table
INSERT INTO MedicalHistorys (PatID, Diagnosis, Treatment, VisitDate)
VALUES
('P001', 'Hypertension', 'Lifestyle Modification', '2023-12-20'),
('P002', 'Influenza', 'Antiviral Medication', '2023-12-21'),
('P003', 'Eczema', 'Topical Cream', '2023-12-22'),
('P004', 'Chronic Migraine', 'Medication and Therapy', '2023-12-23'),
('P005', 'Arthritis', 'Physiotherapy', '2023-12-24'),
('P006', 'Depression', 'Cognitive Behavioral Therapy', '2023-12-25'),
('P007', 'Post-Surgical Recovery', 'Rehabilitation Program', '2023-12-26'),
('P008', 'Thyroid Disorder', 'Hormone Therapy', '2023-12-27'),
('P009', 'Gastritis', 'Dietary Changes', '2023-12-28'),
('P010', 'Lung Cancer', 'Chemotherapy', '2023-12-29'),
('P011', 'Pregnancy Monitoring', 'Prenatal Care', '2023-12-30'),
('P012', 'Sprained Ankle', 'Physical Therapy', '2023-12-31'),
('P013', 'Asthma', 'Inhaler Prescription', '2024-01-01'),
('P014', 'Fractured Arm', 'Cast Application', '2024-01-02');
