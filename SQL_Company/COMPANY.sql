
--Disconnects and drops database before use
use master;
IF DB_ID('COMPANY 2') IS NOT NULL
ALTER DATABASE COMPANY2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
go
IF DB_ID('COMPANY2') IS NOT NULL
	DROP DATABASE COMPANY2;
	
--Create Company database
CREATE DATABASE COMPANY2;
GO
use COMPANY2;

--Create employee table
IF OBJECT_ID('Employee') IS NULL 
	CREATE TABLE Employee(
		FName VARCHAR(15) NOT NULL,
		Minit CHAR,
		LName VARCHAR(15) NOT NULL,
		SSN CHAR(9) NOT NULL, --primary key
		BDate DATE,
		[Address] VARCHAR(30),
		Sex CHAR NOT NULL,
		Salary DECIMAL(10,2),
		Super_ssn CHAR(9),
		Dno INT NOT NULL DEFAULT(1), --participation in dept is mandatory
		--PRIMARY KEY(SSN), --setting primary key
		--FOREIGN KEY (Super_ssn) --making Super_ssn a forgien key referencing itself 1 to many (unary relationship)
			--REFERENCES Employee(SSN)
	);
--creating department table
IF OBJECT_ID('Department') IS NULL
	CREATE TABLE Department(
		DName VARCHAR(15) NOT NULL, --unique
		DNumber INT NOT NULL, --key
		Mgr_SSN CHAR(9) NOT NULL, --foreign key
		Mgr_Start_Date DATE,
		--PRIMARY KEY (DNumber), --setting primary key
		--FOREIGN KEY (Mgr_SSN) --making Mgr_SSN a Foreign Key referencing Employee's SSN
			--REFERENCES Employee(SSN) 
		);


--make department locations table for the multivalued attribute, deptlocations
IF OBJECT_ID('Dept_Locations') IS NULL
	CREATE TABLE Dept_Locations(
		DNumber INT NOT NULL, --link to department
		DLocation VARCHAR(15) NOT NULL,
		--PRIMARY KEY (DNumber, DLocation), --composite primary key has link to Department
		--FOREIGN KEY (DNumber) --foreign key referencing department's DNumber
			--REFERENCES Department(DNumber)
	);
IF OBJECT_ID('Project') IS NULL
	CREATE TABLE Project( --Many to many relationship with Employee
		PName VARCHAR(15) NOT NULL,--Unique
		PNumber INT NOT NULL,--Primary key
		PLocation VARCHAR(15),
		DNum INT NOT NULL, --link to department one to many relationship with dept
		--PRIMARY KEY(PNumber), -- setting primaryh key
		--FOREIGN KEY(DNum) --setting foreign key link to the dept controlling it
			--REFERENCES Department(DNumber)
	);
IF OBJECT_ID('Works_On') IS NULL
	CREATE TABLE Works_On( --table between employee and project
		ESSN CHAR(9) NOT NULL,
		PNO INT NOT NULL,
		[Hours] DECIMAL(3,1),
		--PRIMARY KEY(ESSN,PNO), --composite key employee ssn and project number together are unique
		--FOREIGN KEY (ESSN) --foreign key ref to employee
		--	REFERENCES Employee,
		--FOREIGN KEY(Pno) --foreign key ref to project
		--	REFERENCES Project
	);
IF OBJECT_ID('DEPENDENT') IS NULL
	CREATE TABLE [Dependent]( --many to one relationship w/ employee weak entity only relationship to company is employee
		ESSN CHAR(9) NOT NULL, --every dependent must have an employee
		Dependent_Name VARCHAR(15) NOT NULL,
		Sex CHAR,
		BDate DATE,
		Relationship VARCHAR(8),
		--PRIMARY KEY(ESSN,Dependent_Name),--composite primary key
		--FOREIGN KEY(ESSN) 
			--REFERENCES EMPLOYEE(SSN)
	);
Go
--inserting employees with super_ssn NULL because super_ssn needs employee's SSN's
INSERT INTO Employee VALUES('John','B','Smith','123456789','9-Jan-1955','731
Fondren, Houston, TX','M',30000,NULL,5);
INSERT INTO Employee VALUES('Franklin', 'T', 'Wong','333445555', '8-Dec-1945', '638 Voss, Houston, TX',
'M', 40000,NULL, 5 );
INSERT INTO Employee VALUES('Joyce', 'A', 'English', '453453453', '31-Jul-1962', '5361 Rice, Houston, TX',
'F', 25000, NULL, 5);
INSERT INTO Employee VALUES('Ramesh', 'K', 'Narayan', '666884444', '15-Sep-1952', '975 Fire Oak, Humble, TX',
'M', 38000, NULL, 5 );
INSERT INTO Employee VALUES('James', 'E', 'Borg', '888665555', '10-Nov-1927', '450 Stone, Houston, TX',
'M', 55000, NULL, 1 );
INSERT INTO Employee VALUES('Jennifer', 'S', 'Wallace', '987654321', '20-Jun-1931', '291 Berry, Bellaire, TX',
'F', 43000, NULL, 4);
INSERT INTO Employee VALUES('Ahmad', 'V', 'Jabbar', '987987987', '29-Mar-1959', '980 Dallas, Houston, TX',
'M', 25000, NULL, 4 );
INSERT INTO Employee VALUES('Alicia', 'J', 'Zelaya', '999887777', '19-Jul-1958', '3321 Castle, Spring, TX',
'F', 25000, NULL, 4);

--updating table with supervisor values
--Updating employee's super_ssn values
UPDATE Employee SET Super_ssn='987654321' WHERE SSN='123456789';
UPDATE Employee SET Super_ssn='888665555' WHERE SSN='333445555';
UPDATE Employee SET Super_ssn='333445555' WHERE SSN='453453453';
UPDATE Employee SET Super_ssn='333445555' WHERE SSN='666884444';
UPDATE Employee SET Super_ssn=NULL		  WHERE SSN='888665555';
UPDATE Employee SET Super_ssn='888665555' WHERE SSN='987654321';
UPDATE Employee SET Super_ssn='987654321' WHERE SSN='987987987';
UPDATE Employee SET Super_ssn='987654321' WHERE SSN='999887777';
--inserting departments into the department table

--Inserting into department
INSERT INTO Department VALUES('Headquarters', 1, '888665555', '19-Jun-71');
INSERT INTO Department VALUES('Administration', 4, '987654321', '01-Jan-85');
INSERT INTO Department VALUES('Research', 5, '333445555', '22-May-78');
INSERT INTO Department VALUES('Automation', 7, '123456789', '06-Oct-05');


--insert dependents
INSERT INTO [Dependent] VALUES('123456789', 'Alice', 'F', '31-Dec-78', 'Daughter');
INSERT INTO [Dependent] VALUES('123456789', 'Elizabeth', 'F', '05-May-57', 'Spouse');
INSERT INTO [Dependent] VALUES('123456789', 'Michael', 'M', '01-Jan-78', 'Son');
INSERT INTO [Dependent] VALUES('333445555', 'Alice', 'F', '05-Apr-76', 'Daughter');
INSERT INTO [Dependent] VALUES('333445555', 'Joy', 'F', '03-May-48', 'Spouse');
INSERT INTO [Dependent] VALUES('333445555', 'Theodore', 'M', '25-Oct-73', 'Son');
INSERT INTO [Dependent] VALUES('987654321', 'Abner', 'M', '29-Feb-32', 'Spouse');
--insert department locations
INSERT INTO Dept_Locations VALUES(1, 'Houston');
INSERT INTO Dept_Locations VALUES(4, 'Stafford');
INSERT INTO Dept_Locations VALUES(5, 'Bellaire');
INSERT INTO Dept_Locations VALUES(5, 'Sugarland');
INSERT INTO Dept_Locations VALUES(5, 'Houston');
--insert projects
INSERT INTO Project VALUES('ProductX', 1, 'Bellaire', 5);
INSERT INTO Project VALUES('ProductY', 2, 'Sugarland', 5);
INSERT INTO Project VALUES('ProductZ', 3, 'Houston', 5);
INSERT INTO Project VALUES('Computerization', 10, 'Stafford', 4);
INSERT INTO Project VALUES('Reorganization', 20, 'Houston', 1);
INSERT INTO Project VALUES('Newbenefits', 30, 'Stafford', 4);
--insert works on relationship
INSERT INTO Works_On VALUES('123456789', 1, 32.5);
INSERT INTO Works_On VALUES('123456789', 2, 7.5);
INSERT INTO Works_On VALUES('333445555', 2, 10);
INSERT INTO Works_On VALUES('333445555', 3,10);
INSERT INTO Works_On VALUES('333445555', 10, 10);
INSERT INTO Works_On VALUES('333445555', 20, 10);
INSERT INTO Works_On VALUES('453453453', 1, 20);
INSERT INTO Works_On VALUES('453453453', 2, 20);
INSERT INTO Works_On VALUES('666884444', 3, 40);
INSERT INTO Works_On VALUES('888665555', 20, NULL);
INSERT INTO Works_On VALUES('987654321', 20, 15);
INSERT INTO Works_On VALUES('987654321', 30, 20);
INSERT INTO Works_On VALUES('987987987', 10, 35);
INSERT INTO Works_On VALUES('987987987', 30, 5);
INSERT INTO Works_On VALUES('999887777', 10, 10);
INSERT INTO Works_On VALUES('999887777', 30, 30);

--Inserting myself into the works_on table
INSERT INTO Works_On VALUES('012345678', 3,40);

--inserting new dependents
INSERT INTO [Dependent] VALUES('453453453', 'Joe', 'M', NULL, 'Spouse');
INSERT INTO [Dependent] VALUES('987654321', 'Erica', 'F', NULL, 'Daughter');
--inserting into works_on with 0 hours
INSERT INTO Works_On VALUES('987654321', 10, 0);
GO --create view can be only statement in batch
CREATE VIEW VDept_Budget --creating view to show Department name number and employee count
	AS(SELECT D.DName As Dept_Name, D.DNumber AS Dept_Number, COUNT(E.SSN) AS No_Emp
	   FROM DEPARTMENT D
	   LEFT OUTER JOIN EMPLOYEE E ON E.Dno = D.DNumber --include values for depts with no employees
	   GROUP BY D.DName, D.DNumber
	  );
GO
--selecting view (everyone from the Employee table is inserted except myself)
SELECT * FROM VDept_Budget;
--Inserting myself into the Employee table
INSERT INTO Employee VALUES('Sean', 'C', 'Surtz', '012345678', '28-Mar-1999', '7518 Hollycroft Ln, Mentor, OH',
'M', 25000, '333445555', 5);
--Checking updated View table (Research amount increased from 4 to 5)
SELECT * FROM VDept_Budget;
GO--view can be only statement in batch
ALTER VIEW VDept_Budget --altering vdept_budget to show sum of salaries and average salaries
	AS(SELECT D.DName As Dept_Name, D.DNumber AS Dept_Number, COUNT(E.SSN) AS No_Emp, SUM(E.Salary) AS Sum_Salary, AVG(E.Salary) as Ave_Salary 
	   FROM DEPARTMENT D
	   LEFT OUTER JOIN EMPLOYEE E ON E.Dno = D.DNumber --include values for depts with no employees
	   GROUP BY D.DName, D.DNumber
	  );
GO
SELECT * FROM VDept_Budget;
GO
CREATE PROCEDURE SP_Report_NEW_Budget
AS
DECLARE @NEW_Dept_Budget TABLE(
	Dept_No INT,
	Dept_Name CHAR(30),
	COUNT_Emp INT,
	New_SUM_Salary INT,
	New_AVE_Salary INT
)
	--declaring local variables
DECLARE	@Dept_No INT
DECLARE	@Dept_Name CHAR(30)
DECLARE	@COUNT_Emp INT
DECLARE	@New_SUM_Salary INT
DECLARE	@New_AVE_Salary INT
DECLARE @Count as smallint

SELECT @Count=COUNT(*) FROM VDept_Budget

--if there are rows in the table
IF @Count>0
	BEGIN
	DECLARE Get_Dept_Info_Cursor CURSOR
		FOR SELECT V.Dept_Number, V.Dept_Name, V.No_Emp, V.Sum_Salary, V.Ave_Salary FROM VDept_Budget V
	OPEN Get_Dept_Info_Cursor
	FETCH NEXT FROM Get_Dept_Info_Cursor INTO @Dept_No, @Dept_Name, @COUNT_Emp, @New_SUM_Salary, @New_AVE_Salary
	--update department 1 salary
	IF @Dept_No = 1
	BEGIN
		SET @New_AVE_Salary = @New_AVE_Salary*1.1
		SET @New_SUM_Salary = @New_SUM_Salary*1.1
	END
	--update department 4 salary
	IF @Dept_No = 4
	BEGIN
		SET @New_AVE_Salary = @New_AVE_Salary*1.2
		SET @New_SUM_Salary = @New_SUM_Salary*1.2
	END
	--update department 5 salary
	IF @Dept_No = 5
	BEGIN
		SET @New_AVE_Salary = @New_AVE_Salary*1.3
		SET @New_SUM_Salary = @New_SUM_Salary*1.3
	END
	--update department 7 salary
	IF @Dept_No = 7
	BEGIN
		SET @New_AVE_Salary = @New_AVE_Salary*1.4
		SET @New_SUM_Salary = @New_SUM_Salary*1.4
	END
	--insert into table with new salary values
	INSERT INTO @NEW_Dept_Budget
	SELECT @Dept_No, @Dept_Name, @COUNT_Emp, @New_SUM_Salary, @New_AVE_Salary
	CLOSE GET_DEPT_INFO_CURSOR
	DEALLOCATE GET_DEPT_INFO_CURSOR
END
SELECT * FROM @NEW_DEPT_BUDGET
GO
--EXECUTE SP_Report_NEW_Budget
GO
--creating table to hold audits (above trigger and SP_Audit_Dept so it can be used in them)
CREATE TABLE Audit_Dept_Table(
	date_of_change DATE,
	old_Dname VARCHAR(15),
	new_Dname VARCHAR(15),
	old_Dnumber INT,
	new_Dnumber INT,
	old_Mgrssn CHAR(9),
	new_Mgrssn CHAR(9)
);
GO
--Creating procedure (Before trigger so it is recognized when it is called in the trigger)
CREATE PROCEDURE SP_Audit_Dept
	@old_Dname VARCHAR(15),
	@new_Dname VARCHAR(15),
	@old_Dnumber INT,
	@new_Dnumber INT,
	@old_Mgrssn CHAR(9),
	@new_Mgrssn CHAR(9)
AS
BEGIN
	DECLARE @date_of_change DATE
	SET @date_of_change = cast(GETDATE() as DATE)
	INSERT INTO Audit_Dept_Table
	SELECT @date_of_change, @old_Dname, @new_Dname, @old_Dnumber, @new_Dnumber, @old_Mgrssn,@new_Mgrssn;
END
GO
--Creating Trigger Trigger checks for update or delete of Department table member
CREATE TRIGGER [dbo].[EMPDEPTFK]
    ON [dbo].[DEPARTMENT]
    FOR DELETE, UPDATE
AS
BEGIN
	--saving variables for use in updating information
	DECLARE @oldDNO INT
	DECLARE @newDNO INT
	DECLARE @oldName CHAR(15)
	DECLARE @newName CHAR(15)
	DECLARE @oldMGR_SSN CHAR(9)
	DECLARE @newMGR_SSN CHAR(9);
	--assiging values to variables
	SELECT @oldDNO = D.DNumber, @oldName = d.DName, @oldMGR_SSN = d.Mgr_SSN FROM DELETED D
	SELECT @newDNO = I.DNumber, @newName = I.DName, @newMGR_SSN = I.Mgr_SSN FROM INSERTED I

	IF @newDNO IS NULL --If department is deleted set employees to default DNO
	BEGIN
		UPDATE EMPLOYEE SET DNO = DEFAULT
		FROM EMPLOYEE AS E
		JOIN DELEtED D ON D.DNUMBER = E.Dno;
	END
	IF @newDNO IS NOT NULL --If department is updated, update employees department
	BEGIN
		UPDATE EMPLOYEE SET DNO = @newDNO
		FROM EMPLOYEE E
		WHERE E.Dno = @oldDNO
	END
	--executing stored procedure to add to audit table
	EXECUTE SP_Audit_Dept @oldname, @newname, @oldDNO, @newDNO, @oldMGR_SSN, @newMGR_SSN
END
GO
--showing information before update/Deletion
SELECT * FROM Audit_Dept_Table;
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

--updating department number 4 to 99.
--Since the UPDATE keyword was used on department the Trigger will be called and employee's
--DNO's will be updated.
UPDATE DEPARTMENT SET DNUMBER = 99
WHERE DNUMBER = 4;

--reading updated info from audit_dept_table
--new row will be added to auditdepttable since the trigger was executed and the trigger calls the stored procedure which
--puts information into AUDIT_DEPT_TABLE
-- putting new and old info of dept into the table
SELECT *
FROM Audit_Dept_Table;

--reading updated info from employee table
--this will update Employee's who have DNO 4 to 99 since the trigger was called and an update was made
SELECT * FROM Employee;

--Since Department 4's dnumber was updated obviously it will change to 99
SELECT * FROM DEPARTMENT;

--deleting department 5, this will cause the trigger to run since the DELETE keyword was used
--it will update employee's in departmen 5's DNO to 1 since the department was deleted
--it will also execute the stored procedure to add info into the audit table
--since the stored procedure is located insided of the audit
DELETE D
FROM DEPARTMENT D
WHERE D.DNUMBER = 5;

--reading updated info from audit_dept_table
--it will show null values now for the new values since the department is being deleted.  
--Like before the trigger was called but this time a dept was deleted so new values will be NULL
SELECT *
FROM Audit_Dept_Table;

--reading updated info from employee table
--This time newdno (Department's Dnumber) will be null so it will set all employee's DNO to the defualt value which is 1
SELECT * FROM Employee;

--now department 5 will no longer exist
SELECT * FROM DEPARTMENT;
(SELECT E.ssn, COUNT(E.ssn) FROM WORKS_ON W, EMPLOYEE E WHERE W.essn = E.ssn GROUP BY E.ssn HAVING (COUNT(ESSN)>2) );
SELECT * FROM WORKS_ON;