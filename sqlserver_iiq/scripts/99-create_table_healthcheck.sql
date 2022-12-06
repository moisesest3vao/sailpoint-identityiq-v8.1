USE identityiq
GO
CREATE LOGIN [healthcheck] WITH PASSWORD='Change@123',
DEFAULT_DATABASE=identityiq
--create a user in our db associated with our server login and our schema
CREATE USER healthcheck FOR LOGIN healthcheck WITH DEFAULT_SCHEMA =
identityiq
GO
