CREATE TABLE IF NOT EXISTS PointsOfInterest (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    type VARCHAR(32),
    name VARCHAR(48),
    description VARCHAR(128),
    address VARCHAR(48),
    city VARCHAR(48),
    state VARCHAR(3),
    zip VARCHAR(10),
    latitude DOUBLE,
    longitude DOUBLE
);

CREATE TABLE IF NOT EXISTS Version (
    version VARCHAR(16) NOT NULL
);
DELETE FROM Version;
INSERT INTO Version (version) VALUES('1.0.0');
