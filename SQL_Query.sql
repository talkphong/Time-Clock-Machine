
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




-- Departments
INSERT INTO Departments (Name) VALUES
(N'IT'),
(N'Nhân sự'),
(N'Kế toán'),
(N'Kinh doanh');

-- Users
INSERT INTO Users (EmployeeCode, FullName, Email, PasswordHash, Role, DepartmentId)
VALUES
('EMP001', N'Nguyễn Văn A', 'a@gmail.com', 'hash1', 'Admin', 1),
('EMP002', N'Trần Thị B', 'b@gmail.com', 'hash2', 'HR', 2),
('EMP003', N'Lê Văn C', 'c@gmail.com', 'hash3', 'Leader', 1),
('EMP004', N'Phạm Văn D', 'd@gmail.com', 'hash4', 'Employee', 1),
('EMP005', N'Hoàng Thị E', 'e@gmail.com', 'hash5', 'Employee', 3);

-- FaceData
INSERT INTO FaceData (UserId, Embedding, ImagePath)
VALUES
(4, 0x1234, N'/images/user4.jpg'),
(5, 0x5678, N'/images/user5.jpg');

-- Attendances
INSERT INTO Attendances (UserId, Time, Type, Source, Status)
VALUES
(4, GETDATE(), 'CheckIn', 'Machine', 'Valid'),
(4, DATEADD(HOUR, 8, GETDATE()), 'CheckOut', 'Machine', 'Valid'),
(5, GETDATE(), 'CheckIn', 'Machine', 'Late');

-- LeaveRequests
INSERT INTO LeaveRequests (UserId, FromDate, ToDate, Reason, Status, ApprovedBy)
VALUES
(4, '2026-04-10', '2026-04-12', N'Nghỉ ốm', 'Approved', 2),
(5, '2026-04-15', '2026-04-16', N'Việc gia đình', 'Pending', NULL);

-- AttendanceAdjustments
INSERT INTO AttendanceAdjustments (UserId, Date, CheckInTime, CheckOutTime, Reason, Status, ApprovedBy)
VALUES
(4, '2026-04-05', '2026-04-05 08:05:00', '2026-04-05 17:00:00', N'Quên chấm công', 'Approved', 3),
(5, '2026-04-05', NULL, NULL, N'Quên checkin', 'Pending', NULL);

-- OvertimeRecords
INSERT INTO OvertimeRecords (UserId, Date, StartTime, EndTime, TotalHours, Status, ApprovedBy)
VALUES
(4, '2026-04-06', '2026-04-06 18:00:00', '2026-04-06 21:00:00', 3, 'Approved', 3),
(5, '2026-04-06', '2026-04-06 18:30:00', '2026-04-06 20:00:00', 1.5, 'Pending', NULL);

-- SystemConfigs
INSERT INTO SystemConfigs ([Key], [Value])
VALUES
(N'WorkStartTime', N'08:00'),
(N'WorkEndTime', N'17:00'),
(N'AllowLateMinutes', N'15');

-- Logs
INSERT INTO Logs (UserId, Action, Description)
VALUES
(1, N'Login', N'Admin đăng nhập hệ thống'),
(4, N'CheckIn', N'Nhân viên checkin'),
(5, N'LeaveRequest', N'Gửi yêu cầu nghỉ phép');




select * from Logs
select * from Attendances
select * from users 