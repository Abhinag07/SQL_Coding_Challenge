
-- SQL CODING CHALLENGE
-- CRIME MANAGEMENT SYSTEM



CREATE DATABASE CrimeManagement;

USE CrimeManagement;


--Creating tables

CREATE TABLE Crime (
CrimeID INT PRIMARY KEY,
IncidentType VARCHAR(255),
IncidentDate DATE,
Location VARCHAR(255),
Description TEXT,
Status VARCHAR(20)
);

CREATE TABLE Victim (
VictimID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
ContactInfo VARCHAR(255),
Injuries VARCHAR(255),
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
SuspectID INT PRIMARY KEY,
CrimeID INT,
Name VARCHAR(255),
Description TEXT,
CriminalHistory TEXT,
FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);


-- Insert sample data

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under
Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'),
(4, 'Robbery', '2023-02-15', '123 pine St, Newville', 'Armed robbery', 'Open'),
(8, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open');


INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES
(1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
(2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
(3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None'),
(4, 4, 'Robber 1', 'johndoe@example.com', 'Minor injuries');


INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES 
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
(2, 2, 'Unknown', 'Investigation ongoing', NULL),
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests'),
(4, 4, 'John Doe', 'Armed and masked robber', 'Previous robbery convictions'),
(5, 4, 'John Doe', 'Armed and masked robber', 'Previous robbery convictions');

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

--SOLVED QUERIES


-- 1. Select all open incidents.
SELECT * FROM CRIME WHERE Status='open';

--2. Find the total number of incidents.
SELECT COUNT(*) as TotalIncident FROM CRIME;

--3. List all unique incident types.
SELECT Distinct(IncidentType) as AllTypeOfIncidents from crime;

--4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.
SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' and '2023-09-10';

--ALTERING TABLE TO ADD A AGE COLUMN IN VICTIM AND SUSPECT TABLE
ALTER TABLE VICTIM
ADD Age int;
UPDATE Victim Set Age=20 where VictimID=1;
UPDATE Victim Set Age=30 where VictimID=2;
UPDATE Victim Set Age=40 where VictimID=3;
UPDATE Victim Set Age=35 where VictimID=4;

ALTER TABLE SUSPECT
ADD Age int;

UPDATE Suspect Set Age=18 where SuspectID=1;
UPDATE Suspect Set Age=19 where SuspectID=2;
UPDATE Suspect Set Age=32 where SuspectID=3;
UPDATE Suspect Set Age=33 where SuspectID=4;
UPDATE Suspect Set Age=23 where SuspectID=5;


--5. List persons involved in incidents in descending order of age.
SELECT Name, Age FROM Victim UNION SELECT Name, Age FROM Suspect ORDER BY Age;

--6. Find the average age of persons involved in incidents.
SELECT AVG(Age) as AvgAge FROM (
SELECT Name, Age FROM Victim UNION SELECT Name, Age FROM Suspect ) as Age;


--7. List incident types and their counts, only for open cases.
SELECT IncidentType, COUNT(*) AS OpenCaseCount FROM Crime WHERE Status = 'Open' GROUP BY IncidentType;

--8. Find persons with names containing 'Doe'.
SELECT Name FROM Victim where Name LIKE '%doe%' 
UNION SELECT Name FROM Suspect where Name LIKE '%doe%';

--9. Retrieve the names of persons involved in open cases and closed cases.

--for open cases
SELECT name from Victim join Crime on Crime.CrimeID=Victim.CrimeID WHERE Status='open'
UNION SELECT name from Suspect join Crime on Crime.CrimeID=Suspect.CrimeID WHERE Status='open' ;

--for closed cases
SELECT name from Victim join Crime on Crime.CrimeID=Victim.CrimeID WHERE Status='closed'
UNION SELECT name from Suspect join Crime on Crime.CrimeID=Suspect.CrimeID WHERE Status='closed' ;


--AND if combined than

SELECT name from Victim join Crime on Crime.CrimeID=Victim.CrimeID WHERE Status='open'
UNION SELECT name from Suspect join Crime on Crime.CrimeID=Suspect.CrimeID WHERE Status='open' 
UNION
SELECT name from Victim join Crime on Crime.CrimeID=Victim.CrimeID WHERE Status='closed'
UNION SELECT name from Suspect join Crime on Crime.CrimeID=Suspect.CrimeID WHERE Status='closed' ;


--10. List incident types where there are persons aged 30 or 35 involved.
SELECT DISTINCT c.IncidentType FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE v.Age IN (30, 35) OR s.Age IN (30, 35);


--11. Find persons involved in incidents of the same type as 'Robbery'.
SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery')
UNION
SELECT Name FROM Suspect WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery');

--12. List incident types with more than one open case.
SELECT IncidentType, COUNT(*) AS OpenCaseCount FROM Crime
WHERE Status = 'Open' GROUP BY IncidentType HAVING COUNT(*) > 1;

--13. List all incidents with suspects whose names also appear as victims in other incidents.
SELECT c.*, v.Name AS VictimName, s.Name AS SuspectName
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.Name IS NOT NULL AND s.Name IN (SELECT Name FROM Victim );

--14. Retrieve all incidents along with victim and suspect details.
SELECT c.*, v.Name AS VName, v.ContactInfo, v.Injuries, s.Name AS SName, s.Description AS Description, s.CriminalHistory
FROM Crime c JOIN Victim v ON c.CrimeID = v.CrimeID JOIN Suspect s ON c.CrimeID = s.CrimeID;

--15. Find incidents where the suspect is older than any victim.
SELECT * from crime join suspect on Suspect.CrimeID=crime.CrimeID  Where Age>(Select min(Age) from Victim);

--16. Find suspects involved in multiple incidents:
SELECT Name, COUNT(*) AS IncidentCount FROM Suspect
GROUP BY Name HAVING COUNT(*) >1;

--17. List incidents with no suspects involved.
SELECT * FROM Crime WHERE CrimeID NOT IN (SELECT DISTINCT CrimeID FROM Suspect);

--18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type 'Robbery'.
SELECT CrimeID,incidenttype from
(SELECT TOP 1 CrimeID, IncidentType FROM Crime WHERE IncidentType IN ('Homicide') UNION
SELECT CrimeID, IncidentType FROM Crime WHERE IncidentType IN ('Robbery')) as A;

--19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 'No Suspect' if there are none.
SELECT c.CrimeID, c.IncidentType, COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c JOIN Suspect s ON c.CrimeID = s.CrimeID;


--20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'
SELECT s.SuspectID, s.Name FROM Suspect s JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');








