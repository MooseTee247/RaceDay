USE master;

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'RaceDay')
BEGIN
    ALTER DATABASE RaceDay SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDay;
END


CREATE DATABASE RaceDay;


USE RaceDay;


-- 1. Create Tables
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL DEFAULT 'Participant'
);
CREATE TABLE Events (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    EventDate DATETIME NOT NULL,
    Location NVARCHAR(100) NOT NULL,
    OrganiserId INT FOREIGN KEY REFERENCES Users(UserId)
);
CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT FOREIGN KEY REFERENCES Events(EventId) ON DELETE CASCADE,
    CategoryName NVARCHAR(50) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Enrolments (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId INT FOREIGN KEY REFERENCES Categories(CategoryId),
    ParticipantId INT FOREIGN KEY REFERENCES Users(UserId),
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Registered'
);

CREATE TABLE Results (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT FOREIGN KEY REFERENCES Enrolments(EnrolmentId) ON DELETE CASCADE,
    ParticipantId INT FOREIGN KEY REFERENCES Users(UserId),
    FinishTime TIME NOT NULL,
    Position INT NOT NULL
);

CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT FOREIGN KEY REFERENCES Enrolments(EnrolmentId) ON DELETE CASCADE,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(50) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Completed'
);



INSERT INTO Users (Username, Email, PasswordHash, Role) VALUES 
('ThaboOrganiser', 'thabo@raceday.co.za', 'hashed_pass_1', 'Organiser'),
('LeratoManager', 'lerato@raceday.co.za', 'hashed_pass_2', 'Organiser'),
('SibusisoRunner', 'sibusiso@gmail.com', 'hashed_pass_3', 'Participant'),
('PalesaAthlete', 'palesa@gmail.com', 'hashed_pass_4', 'Participant');

INSERT INTO Events (Title, Description, EventDate, Location, OrganiserId) VALUES 
('Joburg City Marathon', 'Annual road running marathon through downtown Johannesburg.', '2026-10-15 06:00:00', 'Johannesburg', 1),
('Soweto Spring Trail', 'Scenic trail run crossing historical landmarks.', '2026-11-05 07:00:00', 'Soweto', 1),
('Pretoria Capital Classic', 'Fast road race around the Union Buildings.', '2026-12-01 06:30:00', 'Pretoria', 2);

INSERT INTO Categories (EventId, CategoryName, DistanceKm, Price) VALUES 
(1, 'Full Marathon', 42.20, 350.00),
(1, 'Half Marathon', 21.10, 250.00),
(2, 'Trail 10K', 10.00, 180.00),
(3, 'Capital 5K Fun Run', 5.00, 100.00);

INSERT INTO Enrolments (CategoryId, ParticipantId, Status) VALUES 
(1, 3, 'Confirmed'),
(3, 4, 'Confirmed');

INSERT INTO Payments (EnrolmentId, Amount, PaymentMethod, Status) VALUES 
(1, 350.00, 'Credit Card', 'Completed'),
(2, 180.00, 'EFT', 'Completed');

INSERT INTO Results (EnrolmentId, ParticipantId, FinishTime, Position) VALUES 
(1, 3, '03:15:40', 12);


SELECT * FROM Users;
SELECT * FROM Events;