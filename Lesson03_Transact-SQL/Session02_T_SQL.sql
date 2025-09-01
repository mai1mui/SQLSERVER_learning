/* A. DDL */
	--1. CREATE 
	-- Syntax: [CREATE DATABASE] [DB_NAME]
	--Ex: 
		create database ABC
		--Option 
		Go
		USE ABC 
		Go 

		--
	--2. ALTER 
		--Syntax: [ALTER DATABASE] [DB_NAME]
		--Ex:
			alter database ABC 
			modify name = NewABC 
			-------
			GO
			USE NewABC 
			GO
	--3. DROP
		--Syntax: [DROP DATABASE] [DB_NAME]
		--Ex: 
			use master 
			go 
			drop database Google 
			go 
			drop database NewABC 