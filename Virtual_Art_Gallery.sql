CREATE DATABASE Virtual_Art_Gallery;
USE Virtual_Art_Gallery;

CREATE TABLE Artwork (
    ArtworkID INT PRIMARY KEY,
    Title VARCHAR(255),
    Description VARCHAR(MAX),
    CreationDate DATE,
    Medium VARCHAR(255),
    ImageURL VARCHAR(MAX),
);

-- Create Artist table
CREATE TABLE Artist (
    ArtistID INT PRIMARY KEY,
    Name VARCHAR(255),
    Biography TEXT,
    BirthDate DATE,
    Nationality VARCHAR(100),
    Website VARCHAR(255),
    ContactInformation VARCHAR(255)
);


-- Create User table
CREATE TABLE [User] (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50),
    Password VARCHAR(50),
    Email VARCHAR(100),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    ProfilePicture VARCHAR(255),
);

-- Create Gallery table
CREATE TABLE Gallery (
    GalleryID INT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    Location VARCHAR(255),
    Curator INT, -- Reference to ArtistID
    OpeningHours VARCHAR(100),
    FOREIGN KEY (Curator) REFERENCES Artist(ArtistID)
);

--Artwork - Artist (Many-to-One)
ALTER TABLE Artwork
ADD ArtistID INT;

ALTER TABLE Artwork
ADD CONSTRAINT FK_Artwork_Artist
FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID);


-- Create User_Favorite_Artwork junction table
CREATE TABLE User_Favorite_Artwork (
    UserID INT,
    ArtworkID INT,
    PRIMARY KEY (UserID, ArtworkID),
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID)
);


-- Create Artwork_Gallery junction table
CREATE TABLE Artwork_Gallery (
    ArtworkID INT,
    GalleryID INT,
    PRIMARY KEY (ArtworkID, GalleryID),
    FOREIGN KEY (ArtworkID) REFERENCES Artwork(ArtworkID),
    FOREIGN KEY (GalleryID) REFERENCES Gallery(GalleryID)
);