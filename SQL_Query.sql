
Create database TimeClockMachine
go
﻿use TimeClockMachine
go

CREATE TABLE Departments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL
);
go

CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeCode VARCHAR(50) UNIQUE,
    FullName NVARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    PasswordHash VARCHAR(500),
    Role VARCHAR(50) CHECK (Role IN ('Admin','HR','Leader','Employee')),
    DepartmentId INT,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Users_Department FOREIGN KEY (DepartmentId)
        REFERENCES Departments(Id)
);
go

CREATE TABLE FaceData (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Embedding VARBINARY(MAX), -- lưu vector AI
    ImagePath NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_FaceData_User FOREIGN KEY (UserId)
        REFERENCES Users(Id)
        ON DELETE CASCADE
);
go

CREATE TABLE Attendances (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Time DATETIME NOT NULL,
    Type VARCHAR(10) CHECK (Type IN ('CheckIn','CheckOut')),
    Source VARCHAR(20) CHECK (Source IN ('Machine','Manual')) DEFAULT 'Machine',
    Status VARCHAR(20) NULL, -- Late, Early, Valid, OT

    CONSTRAINT FK_Attendance_User FOREIGN KEY (UserId)
        REFERENCES Users(Id)
        ON DELETE CASCADE
);
go

CREATE TABLE LeaveRequests (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    FromDate DATE NOT NULL,
    ToDate DATE NOT NULL,
    Reason NVARCHAR(500),
    Status VARCHAR(20) DEFAULT 'Pending'
        CHECK (Status IN ('Pending','Approved','Rejected')),
    ApprovedBy INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Leave_User FOREIGN KEY (UserId)
        REFERENCES Users(Id),

    CONSTRAINT FK_Leave_ApprovedBy FOREIGN KEY (ApprovedBy)
        REFERENCES Users(Id)
);
go

CREATE TABLE AttendanceAdjustments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Date DATE NOT NULL,
    CheckInTime DATETIME NULL,
    CheckOutTime DATETIME NULL,
    Reason NVARCHAR(500),
    Status VARCHAR(20) DEFAULT 'Pending'
        CHECK (Status IN ('Pending','Approved','Rejected')),
    ApprovedBy INT NULL,

    CONSTRAINT FK_Adjust_User FOREIGN KEY (UserId)
        REFERENCES Users(Id),

    CONSTRAINT FK_Adjust_ApprovedBy FOREIGN KEY (ApprovedBy)
        REFERENCES Users(Id)
);
go

CREATE TABLE OvertimeRecords (
    Id INT IDENTITY PRIMARY KEY,
    UserId INT,
    Date DATE,
    StartTime DATETIME,
    EndTime DATETIME,
    TotalHours FLOAT,
    Status VARCHAR(20) DEFAULT 'Pending', -- Pending, Approved
    ApprovedBy INT NULL,

    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (ApprovedBy) REFERENCES Users(Id)
);
go

CREATE TABLE SystemConfigs (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    [Key] NVARCHAR(100) UNIQUE,
    [Value] NVARCHAR(500)
);
go

CREATE TABLE Logs (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NULL,
    Action NVARCHAR(255),
    Description NVARCHAR(1000),
    CreatedAt DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Log_User FOREIGN KEY (UserId)
        REFERENCES Users(Id)
);
