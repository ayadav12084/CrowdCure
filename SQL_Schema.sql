CREATE DATABASE CrowdCure;
USE CrowdCure;

CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Role ENUM('PublicUser', 'MedicalProfessional', 'HealthAuthority', 'LaboratoryWorker') NOT NULL,
    Location VARCHAR(255),
    DateJoined DATE NOT NULL DEFAULT CURRENT_DATE()
);

CREATE TABLE PublicUser (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE MedicalProfessional (
    MedicalProfessionalID INT PRIMARY KEY,
    HospitalID INT,
    FOREIGN KEY (MedicalProfessionalID) REFERENCES User(UserID),
    FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);

CREATE TABLE HealthAuthority (
    HealthAuthorityID INT PRIMARY KEY,
    FOREIGN KEY (HealthAuthorityID) REFERENCES User(UserID)
);

CREATE TABLE LaboratoryWorker (
    LaboratoryWorkerID INT PRIMARY KEY,
    FOREIGN KEY (LaboratoryWorkerID) REFERENCES User(UserID)
);

CREATE TABLE SymptomReport (
    SymptomID INT PRIMARY KEY,
    ReportDate DATE,
    SymptomType VARCHAR(255),
    SeverityLevel INT,
    Location VARCHAR(255),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES PublicUser(UserID)
);

CREATE TABLE Disease (
    DiseaseID INT PRIMARY KEY,
    Name VARCHAR(255),
    Type ENUM('Viral', 'Bacterial', 'Fungal', 'Parasitic'),
    Symptoms TEXT,
    IncubationPeriod INT,
    TransmissionMethod VARCHAR(255)
);


CREATE TABLE DiseaseCase (
    CaseID INT PRIMARY KEY,
    DiseaseID INT,
    DateDiagnosed DATE,
    CaseSeverity INT,
    MedicalProfessionalID INT,
    LabTestID INT,
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID),
    FOREIGN KEY (MedicalProfessionalID) REFERENCES MedicalProfessional(MedicalProfessionalID),
    FOREIGN KEY (LabTestID) REFERENCES LabTestReport(LabTestID)
);


CREATE TABLE LabTestReport (
    LabTestID INT PRIMARY KEY,
    TestType VARCHAR(255),
    DateTested DATE,
    Result VARCHAR(255),
    LaboratoryWorkerID INT,
    UserID INT,
    HospitalID INT,
    HealthAuthorityID INT,
    FOREIGN KEY (LaboratoryWorkerID) REFERENCES LaboratoryWorker(LaboratoryWorkerID),
    FOREIGN KEY (UserID) REFERENCES PublicUser(UserID),
    FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID),
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID)
);


CREATE TABLE HealthAlert (
    AlertID INT PRIMARY KEY,
    DateIssued DATE,
    Region VARCHAR(255),
    Description TEXT,
    DiseaseID INT,
    HealthAuthorityID INT,
    AlertSeverity INT,
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID),
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID)
);


CREATE TABLE Hospital (
    HospitalID INT PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255),
    Capacity INT,
    PublicHealthRanking INT,
    DeathToll INT,
    Equipments TEXT,
    Medicine TEXT
);


CREATE TABLE Transmissibility (
    TransmissibilityID INT PRIMARY KEY,
    DiseaseID INT,
    HealthAuthorityID INT,
    SpreadFactor FLOAT,
    TransmissionRate FLOAT,
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID),
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID)
);


CREATE TABLE PandemicSeverityIndex (
    IndexID INT PRIMARY KEY,
    HealthAuthorityID INT,
    DateIssued DATE,
    Region VARCHAR(255),
    DiseaseID INT,
    SeverityFactor INT,
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID),
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID)
);

