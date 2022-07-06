
/*
Projectname: Blood  Bank  management systems
Trainee Name : Rahima Akter  
Trainee ID : 1269510      
Batch ID : ESAD-CS/PNTL-A/51/01 

																															
*/

use BloodBankManagement
go


----=========select,insert values ====----


-----select---
select*from  BloodGroup
go
 select*from Donor
 go
 select*from Recipient
 go
  select*from BloodBank
 go
 select*from BloodCollection
 go
 select*from BloodStock
 go
 select*from BloodRequest
 go



 ----=========insert values===========
 --table BloodGroup--
 insert into BloodGroup values
 
 ('A+'),
 ('B+'),
 ('O+'),
 ('AB+'),
 ('A-'),
 ('B-'),
 ('O-'),
 ('AB-')

 go

 ---table Donor---

insert into Donor values
('Asha',30,1,0123456777,'Mirpur','Asha@gmail.com'),
('kona',34,2,0133456889,'Saver','kona@gmail.com'),
('Sima',36,3,014356989,'Dhamondi','Sima@gmail.com'),
('Pinki',38,4,0153456689,'Mohammmodpur','Pinki@gmail.com'),
('Sumi',40,5,0163456589,' Uttara','Sumi@gmail.com'),
('Jui',45,6,0173456489,'Gazipur','Jui@gmail.com'),
('tanu',30,7,0183456799,'Basila','N/A'),
('toma',42,7,0183457896,'lalmatia','N/A')


go


---table Recipient---

insert into Recipient  values
('Amira',25,1,017013015,'Gulshan','Amira@gmail.com'),
('Salma',26,2,018017013,'Tejgaon','Salma@gmail.com'),
('Rubi',27,3,012013015,'Zigatola','Rubi@gmail.com'),
('Zara',29,4,019018016,' Jartabari','Zara@gmail.com'),
('Alia',30,5,013015018,'Farmgate','Alia@gmail.com'),
('Noor',33,6,014015012,' Agargaon','Noor@gmail.com'),
('Maria',35,7,015012013,'Badda','Maria@gmail.com')
go

---table BloodBank----

  insert  into   BloodBank values
 ('Mahila_BloodBank',1,1,1),
('Rajdhani_BloodBank',2,2,2),
('Nicd_BloodBank',3,3,3),
('Alif_BloodBank',4,4,4),
('Lions_BloodBank',5,5,5),
('Dhaka_BloodBank',6,6,6),
('Mukti_BloodBank',7,7,7)
  go


    ----table BloodCollection ---

insert into  BloodCollection values
  (10,'2022-02-02',1,1),
  (15,'2022-03-03',2,2),
  (20,'2022-04-04',3,3),
  (12,'2022-05-05',4,4),
  (23,'2022-05-06',5,5),
  (25,'2022-02-07',6,6),
  (13,'2022-03-08',7,7),
  (7,'2022-04-09',8,8)
  go


  ----table BloodStock---

 insert into BloodStock values
  (1,1,'2022-02-04',1,'4 units'),
  (2,2,'2022-03-05',4,'3 units'),
  (3,3,'2022-04-06',0,'5 units'),
  (4,4,'2022-05-08',2,'2 units'),
  (5,5,'2022-05-09',0, '0'),
  (6,6,'2022-02-08',2,'1 units'),
  (7,7,'2022-03-10',3,'2 units'),
  (8,8,'2022-04-11',1,'7 units')
  go

    ----table BloodRequest---

insert into BloodRequest values
(2,1,5000.00,1,'2022-02-05'),
(2,2,7000.00,2,'2022-03-06'),
(1,4,4000.00,1,'2022-05-10'),
 (3,6,5000.00,1,'2022-02-08'),
 (5,7, 1400.500,3,'2022-03-11')
  go

  ---simple query---
 select* from Recipient
where recipient_Name IN ('Salma','Rubi' )
go
--
  ----===check view--====
  
INSERT VRecipient VALUES('Rupa',48,01801502596,'lalbagh','Rupa@gmail.com')
go	
   select*from VRecipient
 go

 drop view  VRecipient
go
  ----======sequence===--
 insert into TBL_BBMS values
  (next  value for[dbo].[sequence_BBMS],' first')
  go

  select current_value from sys.sequences where  name=' sequence_BBMS '

select* from TBL_BBMS

  --====update ,delete====---
   update Donor
   set Donor_Name='bina'
   where Donor_age= 30

   delete from Donor
   where Donor_age =30
   go


-----====using union ,union all===----


select*from BloodStock
union
select*from BloodRequest
go

select*from BloodBank
union all
select*from BloodRequest
go
----======= simple subquery ========---

select * from BloodRequest 
where  Blood_ID in (select  Blood_ID from BloodGroup where Blood_Group_Name='A+' )
go

select * from BloodRequest 
where  not exists (select  Blood_ID from BloodGroup where Blood_Group_Name='AB+' )
go

----====(between,and,in, like )using---=====

select* from BloodStock
where Stock_Date between '2022-02-04' and '2022-05-08'
go

select*from  Recipient
where recipient_Name like'A%'
GO

select* from Recipient
where recipient_Name IN ('Salma','Rubi' )
go
---===top ,distinct,===--


select top 3*from Recipient
 where Recipient_age  in (select distinct  Recipient_age from  Recipient)
 order by recipient_Name desc
  go 

  
-- =====Count Row number,Rank & Dense_Rank& Partition &  ntile=====----


--count row  number-
select Donor_ID,Donor_Name,Donor_age,

row_number() over (order by Donor_Name) as row_number
from Donor



----****Rank & Dense_Rank& Partition &  ntile *****

select Donor_ID,Donor_Name,Donor_age,
rank()  over (order by Donor_Name) as rank,
 dense_rank ()  over (order by Donor_Name) as dense_rank ,
rank() over ( partition by Donor_age order by name) as rank,
ntile (3)  over (order by Donor_age) as ntile
 from Donor


---=====aggrigate function=======--

select  Recipient_age,
count(recipient_Name),
avg(Recipient_age),
max(recipient_Name ),
min(recipient_Name )
from Recipient
group  by Recipient_age
go



-----===  groupby,having,orderby using

select R.Recipient_ID, BB.BloodBank_ID,BB.BloodBank_Name,
count(BB.BloodBank_Name)as BB_Name
from Recipient R
inner join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
inner join BloodGroup BG ON BB.Recipient_ID=BG.Blood_ID
group by  R.Recipient_ID
having  count(BB.BloodBank_Name)>3
order by  R.Recipient_ID desc
go


  -----========join( inner,left ,right,full,cross)---====
  ---inner join
 
select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name
from Recipient R
 inner join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID

go

---left join
select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name
from Recipient R
 left join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID

go

---right join

select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name
from Recipient R
 right join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
 go

 ---full join
 select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name
 from Recipient R
 full join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
go

--cross join

 select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name
 from Recipient R
 cross join BloodBank BB   where R.Recipient_ID=BB.Recipient_ID
go

  /*  =========Rollup,cube,grouping sets ==========  */


  select R.Recipient_ID,coalesce(R.recipient_Name ,'Name')as R_Name ,BB.BloodBank_ID,BB.BloodBank_Name from Recipient R
 join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
 group by R.Recipient_ID with rollup
 go

 select R.Recipient_ID,( R.recipient_Name+' ,'+ R.Recipient_age) as  Name_age,BB.BloodBank_ID,BB.BloodBank_Name from Recipient R
  join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
 group by R.Recipient_ID with cube
 go
  select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name from Recipient R
  join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
 group by  grouping sets(R.Recipient_ID)
 go


/* ============ cast ,covert  ===========*/


select  cast (400 as int) as price
select convert (int ,7,1)  as total_bag
go


----============ cte using ==============--
with  cte_BB
as
(
select R.Recipient_ID,R.recipient_Name,BB.BloodBank_ID,BB.BloodBank_Name from Recipient R
 inner join BloodBank BB  ON R.Recipient_ID=BB.Recipient_ID
 )
 select* from cte_BB
go




 --==== using  case  ===--


 select Donor_Name,Donor_age,
 case
	when Donor_Name='kona' then 'KONA'
	when Donor_Name='sima' then 'SIMA'
	else ' NOT NAME'
end as NAME
from Donor


-----==== merge(update,insert , delete)  ====----

merge BloodBank as target
using Recipient as source
on  target.Recipient_ID=source.Recipient_ID

--For Update
when matched then 
update set
 target.BloodBank_Name=source.recipient_Name


--For Insert

when not matched  by  target
then
insert  ( Blood_ID) 
values (source.Blood_ID)

--for delete
when not matched by source
then delete;


----- check stored procedure

exec sp_Recipient
go


--INSERTING data using STORED PROCEDURE

declare  @id int
exec @id= sp_InsertDonorWithReturn 21,'Maya','45','shymoli','01770000','maya@gmail.com'
print  'New product inserted with Id : '+STR(@id)
go
		