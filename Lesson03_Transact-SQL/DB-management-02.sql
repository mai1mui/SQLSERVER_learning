/*Review-2*/
--create DB abc
/*Review-1*/
--without FileGroup
--Syntax: create database [DB-Name] on primary (Attribute_list) log on (Attribute_list)
create database ABC
on primary (
	name		=ABC_dat,
	filename	='C:\Users\mai\OneDrive\Máy tính\DMS\session_class\session03_Transact-SQL\DB\ABC_dat.mdf',
	size		=5MB,
	maxsize		=10MB,--unlimted
	filegrowth	=1mB

)
log on (
	name		=ABC_Log,
	filename	='C:\Users\mai\OneDrive\Máy tính\DMS\session_class\session03_Transact-SQL\DB\ABC_log.ldf',
	size		=5MB,
	maxsize		=10MB,--unlimted
	filegrowth	=1mB
)