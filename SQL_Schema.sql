CREATE DATABASE CrowdCure;
USE CrowdCure;

CREATE TABLE User (
    UserID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Role ENUM('PublicUser', 'MedicalProfessional', 'HealthAuthority', 'LaboratoryWorker') NOT NULL,
    Location VARCHAR(255) NOT NULL,  -- Assuming every user has a location
    DateJoined DATE NOT NULL DEFAULT CURRENT_DATE()
);

CREATE TABLE PublicUser (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE MedicalProfessional (
    MedicalProfessionalID INT PRIMARY KEY,
    HospitalID INT NOT NULL,  -- Assuming every MedicalProfessional must be linked to a Hospital
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
    ReportDate DATE NOT NULL,
    SymptomType VARCHAR(255) NOT NULL,  -- Symptom type must be specified
    SeverityLevel INT NOT NULL,  -- Severity level is essential for tracking
    Location VARCHAR(255) NOT NULL,  -- Location is critical for tracking outbreaks
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES PublicUser(UserID)
);

CREATE TABLE Disease (
    DiseaseID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,  -- Every disease must have a name
    Type ENUM('Viral', 'Bacterial', 'Fungal', 'Parasitic') NOT NULL,  -- Type is crucial for classification
    Symptoms TEXT NOT NULL,  -- A disease must have symptoms listed
    IncubationPeriod INT NOT NULL,  -- Incubation period is important for disease tracking
    TransmissionMethod VARCHAR(255) NOT NULL  -- How the disease spreads is critical
);

CREATE TABLE DiseaseCase (
    CaseID INT PRIMARY KEY,
    DiseaseID INT NOT NULL,
    DateDiagnosed DATE NOT NULL,
    CaseSeverity INT NOT NULL,  -- Severity of the case must be tracked
    MedicalProfessionalID INT NOT NULL,
    LabTestID INT NOT NULL,
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID),
    FOREIGN KEY (MedicalProfessionalID) REFERENCES MedicalProfessional(MedicalProfessionalID),
    FOREIGN KEY (LabTestID) REFERENCES LabTestReport(LabTestID)
);

CREATE TABLE LabTestReport (
    LabTestID INT PRIMARY KEY,
    TestType VARCHAR(255) NOT NULL,  -- The type of test must be defined
    DateTested DATE NOT NULL,  -- The date of the test must be provided
    Result VARCHAR(255) NOT NULL,  -- The result of the test must be provided
    LaboratoryWorkerID INT NOT NULL,
    UserID INT NOT NULL,
    HospitalID INT NOT NULL,
    HealthAuthorityID INT NOT NULL,
    FOREIGN KEY (LaboratoryWorkerID) REFERENCES LaboratoryWorker(LaboratoryWorkerID),
    FOREIGN KEY (UserID) REFERENCES PublicUser(UserID),
    FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID),
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID)
);

CREATE TABLE HealthAlert (
    AlertID INT PRIMARY KEY,
    DateIssued DATE NOT NULL,
    Region VARCHAR(255) NOT NULL,  -- The region where the alert applies must be specified
    Description TEXT NOT NULL,  -- The description of the alert must be provided
    DiseaseID INT NOT NULL,
    HealthAuthorityID INT NOT NULL,
    AlertSeverity INT NOT NULL,  -- The severity of the alert must be recorded
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID),
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID)
);

CREATE TABLE Hospital (
    HospitalID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,  -- Every hospital must have a name
    Location VARCHAR(255) NOT NULL,  -- Every hospital must have a location
    Capacity INT NOT NULL,  -- The capacity of the hospital is important for resource tracking
    PublicHealthRanking INT NOT NULL,  -- Ranking helps in assessing the quality of service
    DeathToll INT NOT NULL,  -- Tracking the number of deaths at the hospital is critical
    Equipments TEXT NOT NULL,  -- Hospitals must have a list of equipment
    Medicine TEXT NOT NULL  -- Hospitals must have details of available medicines
);

CREATE TABLE Transmissibility (
    TransmissibilityID INT PRIMARY KEY,
    DiseaseID INT NOT NULL,
    HealthAuthorityID INT NOT NULL,
    SpreadFactor FLOAT NOT NULL,  -- Spread factor must be tracked to assess transmissibility
    TransmissionRate FLOAT NOT NULL,  -- Transmission rate is essential for tracking
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID),
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID)
);

CREATE TABLE PandemicSeverityIndex (
    IndexID INT PRIMARY KEY,
    HealthAuthorityID INT NOT NULL,
    DateIssued DATE NOT NULL,
    Region VARCHAR(255) NOT NULL,  -- The region must be identified
    DiseaseID INT NOT NULL,
    SeverityFactor INT NOT NULL,  -- The severity of the pandemic must be tracked
    FOREIGN KEY (HealthAuthorityID) REFERENCES HealthAuthority(HealthAuthorityID),
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID)
);


