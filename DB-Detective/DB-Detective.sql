CREATE TABLE `Client` (
  `ClientId` int NOT NULL,
  `FirstName` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LastName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Company` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Address` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `City` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `State` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Country` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PostalCode` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Phone` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Fax` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Email` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AccountRepId` int DEFAULT NULL,
  PRIMARY KEY (`ClientId`),
  KEY `IFK_CustomerSupportRepId` (`AccountRepId`),
  CONSTRAINT `FK_CustomerSupportRepId` FOREIGN KEY (`AccountRepId`) REFERENCES `Staff` (`StaffId`)
);

CREATE TABLE `Collection` (
  `CollectionId` int NOT NULL,
  `Name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`CollectionId`)
);

CREATE TABLE `CollectionItem` (
  `CollectionId` int NOT NULL,
  `RecordingId` int NOT NULL,
  PRIMARY KEY (`CollectionId`,`RecordingId`),
  KEY `IFK_PlaylistTrackPlaylistId` (`CollectionId`),
  KEY `IFK_PlaylistTrackTrackId` (`RecordingId`),
  CONSTRAINT `FK_PlaylistTrackPlaylistId` FOREIGN KEY (`CollectionId`) REFERENCES `Collection` (`CollectionId`),
  CONSTRAINT `FK_PlaylistTrackTrackId` FOREIGN KEY (`RecordingId`) REFERENCES `Recording` (`RecordingId`)
);

CREATE TABLE `Creator` (
  `CreatorId` int NOT NULL,
  `Name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`CreatorId`)
);

CREATE TABLE `Format` (
  `FormatId` int NOT NULL,
  `Name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`FormatId`)
);

CREATE TABLE `Recording` (
  `RecordingId` int NOT NULL,
  `Name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ReleaseId` int DEFAULT NULL,
  `FormatId` int NOT NULL,
  `StyleId` int DEFAULT NULL,
  `Writer` varchar(220) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DurationMs` int NOT NULL,
  `SizeBytes` int DEFAULT NULL,
  `ItemPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`RecordingId`),
  KEY `IFK_TrackAlbumId` (`ReleaseId`),
  KEY `IFK_TrackGenreId` (`StyleId`),
  KEY `IFK_TrackMediaTypeId` (`FormatId`),
  CONSTRAINT `FK_TrackAlbumId` FOREIGN KEY (`ReleaseId`) REFERENCES `Release` (`ReleaseId`),
  CONSTRAINT `FK_TrackGenreId` FOREIGN KEY (`StyleId`) REFERENCES `Style` (`StyleId`),
  CONSTRAINT `FK_TrackMediaTypeId` FOREIGN KEY (`FormatId`) REFERENCES `Format` (`FormatId`)
);

CREATE TABLE `Sale` (
  `SaleId` int NOT NULL,
  `ClientId` int NOT NULL,
  `InvoiceDate` datetime NOT NULL,
  `BillAddress` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillCity` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillRegion` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillCountry` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillPostal` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SaleTotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`SaleId`),
  KEY `IFK_InvoiceCustomerId` (`ClientId`),
  CONSTRAINT `FK_InvoiceCustomerId` FOREIGN KEY (`ClientId`) REFERENCES `Client` (`ClientId`)
);

CREATE TABLE `SaleItem` (
  `SaleItemId` int NOT NULL,
  `SaleId` int NOT NULL,
  `RecordingId` int NOT NULL,
  `ItemPrice` decimal(10,2) NOT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`SaleItemId`),
  KEY `IFK_InvoiceLineInvoiceId` (`SaleId`),
  KEY `IFK_InvoiceLineTrackId` (`RecordingId`),
  CONSTRAINT `FK_InvoiceLineInvoiceId` FOREIGN KEY (`SaleId`) REFERENCES `Sale` (`SaleId`),
  CONSTRAINT `FK_InvoiceLineTrackId` FOREIGN KEY (`RecordingId`) REFERENCES `Recording` (`RecordingId`)
);

CREATE TABLE `Release` (
  `ReleaseId` int NOT NULL,
  `Title` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CreatorId` int NOT NULL,
  PRIMARY KEY (`ReleaseId`),
  KEY `IFK_AlbumArtistId` (`CreatorId`),
  CONSTRAINT `FK_AlbumArtistId` FOREIGN KEY (`CreatorId`) REFERENCES `Creator` (`CreatorId`)
);

CREATE TABLE `Staff` (
  `StaffId` int NOT NULL,
  `LastName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FirstName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Title` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ManagerId` int DEFAULT NULL,
  `BirthDate` datetime DEFAULT NULL,
  `HireDate` datetime DEFAULT NULL,
  `Address` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `City` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `State` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Country` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PostalCode` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Phone` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Fax` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Email` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`StaffId`),
  KEY `IFK_EmployeeReportsTo` (`ManagerId`),
  CONSTRAINT `FK_EmployeeReportsTo` FOREIGN KEY (`ManagerId`) REFERENCES `Staff` (`StaffId`)
);

CREATE TABLE `Style` (
  `StyleId` int NOT NULL,
  `Name` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`StyleId`)
);
