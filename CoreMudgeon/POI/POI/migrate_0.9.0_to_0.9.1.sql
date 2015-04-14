ALTER TABLE PointsOfInterest ADD COLUMN type VARCHAR(32);

DELETE FROM Version;
INSERT INTO Version (version) VALUES('0.9.1');
