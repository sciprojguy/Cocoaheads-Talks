ALTER TABLE PointsOfInterest ADD COLUMN description VARCHAR(128);

DELETE FROM Version;
INSERT INTO Version (version) VALUES('1.0.0');
