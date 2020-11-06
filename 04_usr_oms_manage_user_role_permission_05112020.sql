/* <<<<<<<<<<<<<<<<<<<<<<<<<<<< Steps to create user role for Administrator >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
--Created a new login
sp_addlogin 'Administrator','@dm!n1234'
GO
USE OMS
GO
--Added a role to our database
sp_addrole 'admin_role'
GO
--Added a database user to the current database.
sp_grantdbaccess 'Administrator'
go
--A member added to a role by using sp_addrolemember inherits the permissions of the role.
sp_addrolemember 'admin_role','Administrator'
go
--Granted read only permission to the admin_role
GRANT SELECT ON [ord].[Order] to admin_role
go
/* <<<<<<<<<<<<<<<<<<<<<<<<<<<< Steps to create user role for application >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
--Created a new login
sp_addlogin 'Application','@pp1234#'
GO
USE OMS
GO
--Added a role to our database
sp_addrole 'app_role'
GO
--Added a database user to the current database.
sp_grantdbaccess 'Application'
go
--A member added to a role by using sp_addrolemember inherits the permissions of the role.
sp_addrolemember 'app_role','Application'
go
--Granted read, write, update and delete permission to the app_role
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::byr TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Ord TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::trn TO app_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON [prdt].[OrderProduct] to app_role
go
/* <<<<<<<<<<<<<<<<<<<<<<<<<<<< Steps to create user role for devops >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
--Created a new login
sp_addlogin 'DevOps','dEv0p3434#'
GO
USE OMS
GO
--Added a role to our database
sp_addrole 'devops_role'
GO
--Added a database user to the current database.
sp_grantdbaccess 'DevOps'
go
--A member added to a role by using sp_addrolemember inherits the permissions of the role.
sp_addrolemember 'devops_role','DevOps'
go
--Granted read permission to the devops_role
GRANT SELECT ON SCHEMA::byr to devops_role
GRANT SELECT ON SCHEMA::Ord to devops_role
GRANT SELECT ON SCHEMA::trn to devops_role
go
