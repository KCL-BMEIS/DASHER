// Anonymisaton Script v1, Secure DICOM Uploader
// Daniel Beasley October 2019
// All Times, Dates and UIDs performed seperately - do not include in anon.das


// All UIDs are subsequently rewritten  - do nto delete or generate new UIDs

// (0008,0014)       // Instance Creator UID
// (0008,0018)       // SOP Instance UID
// (0008,1150)       // RT TSructure Set Storage
// (0008,1155)       // Referenced SOP Instance UID
// (0020,0010)
// (0002,0003)       // Media Storage SOP Instance UID
// (0020,000D)       // Study Instance UID
// (0020,000E)       // Series Instance UID
// (0020,0052)       // Frame of Reference UID
// (0020,0200)       // Synchronization FofR UID
// (0020,9161)       // Concatenation UID
// (0088,0140)       // Storage Media File-Set UID
// STRUCTURE SETs - (3006,XXXX) - DO NOT DELETE ANY OF THESE


// LEAVE DATES and times - DONE BY PYDICOM
// (0008,0012) := "19000101"       // instance creation date
// (0008,0020) := "19000101"       // Study Date
// (0008,0021) := "19000101"       // Series Date
// (0008,0023) := "19000101"       // Content date
//(0008,0013) := "120000"         // instance creation time
//(0008,0030) := "120000"         // Study time
//(0008,0031) := "120000"         // Series time
//(0008,0033) := "120000"         // Content Time


- (0008,0050)       // Accession Number
- (0008,0080)       // Institution Name         
- (0008,0081)
(0008,0090) := "clinical trial id"       // Referring Physician's Name
- (0008,0092)
- (0008,0094)
- (0008,0096)       // Referring Physician Identification SQ
- (0008,1010)
- (0008,1030)      // Study Description
(0008,103E) := "DASHER anonymised"       // SERIES DSECRITPTION

- (0008,1040)
- (0008,1048)
- (0008,1050)
- (0008,1060)
- (0008,1070)
- (0008,1080)
- (0008,1111)       // Referenced Performed Procedure Step SQ
- (0008,1120)       // Referenced Patient SQ
- (0008,1032)       // Procedure Code SQ
- (0008,1140)       // Referenced Image SQ
- (0008,1048)       // Physician(s) of Record
- (0008,1049)       // Physician(s) of Record Identification SQ
- (0008,1050)       // Performing Physicians' Name
- (0008,1052)       // Performing Physician Identification SQ
- (0008,1060)       // Name of Physician(s) Reading Study
- (0008,1062)       // Physician(s) Reading Study Identification SQ
- (0008,1110)       // Referenced Study SQ
- (0008,1111)       // Referenced Performed Procedure Step SQ
- (0008,1250)       // Related Series SQ
- (0008,2111)
- (0008,9092)       // Referenced Image Evidence SQ
(0010,0010) := "ct subject id"       // Patient's Name
(0010,0020) := "ct session id"       // Patient ID
- (0010,0021)       // Issuer of Patient ID
- (0010,0030)       // Patient's Birth Date
- (0010,0032)       // Patient's Birth Time
- (0010,0040)
- (0010,0050)       // Patient's Insurance Plan Code SQ
- (0010,0101)       // Patient's Primary Language Code SQ
- (0010,1000)       // Other Patient IDs
- (0010,1001)       // Other Patient Names
- (0010,1002)       // Other Patient IDs SQ
- (0010,1005)       // Patient's Birth Name
- (0010,1010)       // Patient's Age
- (0010,1020)
- (0010,1030)
- (0010,1040)       // Patient's Address
- (0010,1060)       // Patient's Mother's Birth Name
- (0010,1080)       // Military Rank
- (0010,1081)       // Branch of Service
- (0010,1090)       // Medical Record Locator
- (0010,2000)       // Medical Alerts
- (0010,2110)       // Allergies
- (0010,2150)       // Country of Residence
- (0010,2152)       // Region of Residence
- (0010,2154)       // Patient's Telephone Numbers
- (0010,2160)       // Ethnic Group
- (0010,2180)       // Occupation
- (0010,21A0)       // Smoking Status
- (0010,21B0)       // Additional Patient History
- (0010,21C0)       // Pregnancy Status
// - (0010,21D0)       // Last Menstrual Date
- (0010,21F0)       // Patient's Religious Preference
- (0010,2203)       // Patient's Sex Neutered
- (0010,2297)       // Responsible Person
- (0010,2298)       // Responsible Person Role
- (0010,2299)       // Responsible Organization
- (0010,4000)
(0012,0063) := "Secure DICOM Uploader deidentification v001"     // IMPORTANT! DO NOT CHANGE!
- (0018,1000)
- (0018,1030)

- (0020,4000)
- (0020,9221)       // Dimension Organization SQ
- (0020,9222)       // Dimension Index SQ
- (0038,0010)       // Admission ID
- (0038,0011)       // Issuer of Admission ID
- (0038,0060)       // Service Episode ID
- (0038,0061)       // Issuer of Service Episode ID
- (0038,0062)       // Service Episode Description
- (0038,0500)       // Patient State
- (0038,0100)       // Pertinent Documents SQ
- (0040,0260)       // Performed Protocol Code SQ
- (0040,1400)       // Requested Procedure Comments
- (0040,0275)
- (0040,A124)
- (0040,A730)
- (0088,0130)       // Storage Media File-Set ID
- (3006,00C2)
- (5200,9229)       // Shared Functional Groups SQ


