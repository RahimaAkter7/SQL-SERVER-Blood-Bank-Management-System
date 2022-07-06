 /*
Projectname: Blood  Bank  management systems
Trainee Name : Rahima Akter  
Trainee ID : 1269510      
Batch ID : ESAD-CS/PNTL-A/51/01 

																															
*/------ START OF DDL SCRIPT --------

--=============create a database name (BloodBankManagement)==============--

 use master
 go

drop database if exists BloodBankManagement
go

create database BloodBankManagement
on
(
	Name='BloodBankManagement_data_1',
	FileName='E:\project file\bloodbank project file\BloodBankManagement_data_1.mdf',
	Size=50mb,
	MaxSize=100mb,
	FileGrowth=10mb
)

log on


(

Name='BloodBankManagement_log_1',
	FileName='E:\project file\bloobank project file\BloodBankManagement_log_1.ldf',
	Size=20mb,
	MaxSize=30mb,
	FileGrowth=2%
)
go


--=================================modify database name===========================================

alter database  BloodBankManagement
 modify name=BBManagementSystems
 go

 --==================== delete database name   ===========================================

drop database BloodBankManagement
go

-------=====================use database  ======================================================

use BloodBankManagement
go


---==========================create a table ==============================================           

create  table BloodGroup
(
	Blood_ID int primary key identity ,
	Blood_Group_Name varchar(15) not null

)
go


create table Donor
(
	Donor_ID int primary key identity,
	Donor_Name varchar(30) not null,
	Donor_age int  not null ,
	Blood_ID int references  BloodGroup (Blood_ID),
	Donor_contactNo varchar (20) not null,
	Donor_address varchar(35) not null,
	Donor_Email varchar(25)  not null default 'N/A'  
)
go



create table  Recipient
(
	Recipient_ID int  primary key  identity not null,
	recipient_Name varchar(30) not null,
	Recipient_age int not null,
	Blood_ID int references  BloodGroup (Blood_ID),
	Recipient_address varchar(100) not null,
    Recipient_contactNo varchar(15) not null,
	Recipient_Email varchar(30)   null,
)
go

create table BloodBank 
 (
		BloodBank_ID int primary key identity,
		BloodBank_Name varchar(30) not null,
		Blood_ID int references BloodGroup (Blood_ID),
		Donor_ID  int references Donor(Donor_ID),
		Recipient_ID int references Recipient(Recipient_ID),
 )
 go

create table  BloodCollection

(
	Blood_collection_ID int primary key identity,
	No_of_bags int NOT NULL,
	Date_of_collection datetime NOT NULL,
	Blood_ID int references  BloodGroup (Blood_ID),
	Donor_ID  int references   Donor(Donor_ID)
)
go
  
create table BloodStock
(
	Stock_ID int primary key identity not null,
	Blood_ID int references  BloodGroup (Blood_ID),
	Donor_ID  int references   Donor(Donor_ID),
	Stock_Date  datetime not null ,
	Status varchar(5)not null,
	Quantity nvarchar(20) not null default 0,

)

go


 create table BloodRequest
(
	BloodRequest_ID int primary key  identity not null,
	No_of_bags int NOT NULL,
	Blood_ID int references  BloodGroup (Blood_ID),
	Amount_per_bag money NOT NULL,
	Request_status char(5) NOT NULL,
	Date_of_request datetime NOT NULL 
)
go



  --============  = alter table( add,delete,drop)column  ===============--

-- add column
alter table Donor
ADD NID  varchar(10)
GO
--delete column
alter table Donor
drop column NID 
go

--drop table
 if object_id ('Donor') IS NOT NULL
drop table Donor
GO

---======Created  Non-Clustered Index=======---

create  nonclustered index ix_Recipient
on  Recipient (Recipient_ID)
go

----===================index==========================---
CREATE INDEX in_BB
ON BloodBank ( BloodBank_Name)

alter table BloodBank
drop index in_BB
go
-----====================Create a view for update, insert and delete data====----
 create view VRecipient
 as
 select Recipient_Name,Recipient_age,Recipient_contactNo ,Recipient_address,Recipient_Email from Recipient
 go
			


 
 ----delete---
DELETE FROM VRecipient
WHERE recipient_Name ='Rupa'
GO

---=============================sequence=========================---

create sequence [dbo].[sequence_BBMS ]
as int
start with 1
increment by 1
minvalue 0
maxvalue 100
cache 10

CREATE TABLE TBL_BBMS
( 
	ID int,
	Name varchar(50)
)
go
  


  --===================A STORED PROCEDURE FOR QUERY  DATA=================================

create proc sp_Recipient
with encryption
as
select* from Recipient
where Recipient_address='Zigatola'
go

exec sp_Recipient

--A Stored Procedure for inserting DATA


CREATE PROC sp_InsertRecipient
	
					@recipient_Name varchar(100),
					@Recipient_age int ,
					@Recipient_address varchar(40),
					@Recipient_contactNo varchar(15),
					@Recipient_Email varchar(30)

as
	insert into Recipient(recipient_Name,Recipient_age,Recipient_address,Recipient_contactNo,Recipient_Email)
	values ( @recipient_Name,@Recipient_age,@Recipient_address,@Recipient_contactNo,@Recipient_Email)
go

--A Stored procedure for deleting data 

create proc sp_deleteRecipient
						@recipient_Name varchar(100)  not null
as
	delete  from Recipient where  recipient_Name=@recipient_Name
go

--A Stored procedure for inserting data with return values

CREATE PROC sp_InsertDonorWithReturn
						@Donor_ID int ,
						@Donor_Name varchar(30) not null,
						@Donor_age int  not null ,
						@Donor_contactNo varchar (20) not null,
						@Donor_address varchar(35) not null,
						@Donor_Email varchar(25)  not null 
as						
declare  @id INT 
insert into  Donor values (@Donor_ID ,@Donor_Name,@Donor_age,@Donor_address,@Donor_contactNo,@Donor_Email)
select @id=ident_current('Donor')
return @id
go


--test with data insert

declare  @id int
exec @id= sp_InsertDonorWithReturn 21,'Maya','45','shymoli','01770000','maya@gmail.com'
print  'New product inserted with Id : '+STR(@id)
go

--A Stored procedure for inserting data with output parameter

create proc  sp_InsertDonorWithOutPutParameter
						@Donor_ID int ,
						@Donor_Name varchar(30) not null,
						@Donor_age int  not null ,
						@Donor_contactNo varchar (20) not null,
						@Donor_address varchar(35) not null,
						@Donor_Email varchar(25)  not null 
as
insert into  Donor values (@Donor_ID ,@Donor_Name,@Donor_age,@Donor_address,@Donor_contactNo,@Donor_Email)
select @Donor_ID=ident_current('Donor')

go


--test with data insert

declare @Donor_ID  int 
exec sp_InsertDonorWithOutPutParameter 21,'Maya','45','shymoli','01770000','maya@gmail.com',@Donor_ID OUTPUT
select  @Donor_ID 'New Id'
go


-- Create an AFTER TRIGGER for  Prevent update or delete

CREATE TRIGGER tr_BloodBankUpdateDelete
ON BloodBank
AFTER UPDATE,DELETE
AS
BEGIN
    PRINT 'Update Or delete  is not possible'
    ROLLBACK TRANSACTION
END
GO

-----for insert trigger

CREATE TRIGGER tr_BloodStock
ON BloodStock
FOR INSERT
AS
BEGIN
    DECLARE @Stock_ID INT,
            @Quantity INT
    SELECT @Stock_ID =Stock_ID, @Quantity =Quantity FROM inserted
    
    UPDATE BloodStock
    SET Quantity = Quantity + @Quantity
    WHERE Stock_ID =@Stock_ID

END
GO

-- Trigger For Delete 

CREATE TRIGGER  TRBloodStockDelete
ON BloodStock
FOR DELETE
AS
BEGIN
    DECLARE @Stock_ID INT,
            @Quantity INT
    SELECT @Stock_ID =Stock_ID, @Quantity =Quantity FROM inserted
    
    UPDATE BloodStock
    SET Quantity = Quantity + @Quantity
    WHERE Stock_ID =@Stock_ID

END
GO

-- Trigger Created for Preventing Delete Employee From [tblEmployee]

CREATE TRIGGER trBloodRequestDelete
    ON BloodRequest
    FOR DELETE
AS
    PRINT 'You can''t delete '
	ROLLBACK TRANSACTION
GO

-- Trigger Created for Preventing Delete

CREATE TRIGGER trBloodCollectionDelete
    ON BloodCollection
    FOR DELETE
AS
    PRINT 'You can''t delete No_of_bags from BloodCollection '
	ROLLBACK TRANSACTION
GO




