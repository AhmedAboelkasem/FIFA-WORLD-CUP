--1)Which Countries Hosted the World Cup and Won?

create proc HostAndWin
as
select Host_Country,Year,Winner
from Cup
where Winner = Host_Country
order by YEAR
HostAndWin


--===================================================================

--2)which world cup has highest goals scored?

alter proc HighGoalsCup
as
SELECT YEAR, Goals_Scored
FROM cup
WHERE Goals_Scored = (SELECT MAX(Goals_Scored) FROM cup) 
HighGoalsCup


--===================================================================

--3)which country scored a highest goal outside home?

create proc HighGoalsOut
as
select Away_Team,Away_Goals,Year from(
select *,DENSE_RANK() over (order by away_goals desc) DN
from Match) as NewTable
where DN = 1
HighGoalsOut


--===================================================================

--4)which country scored a highest goal inside home?

create proc HighGoalsIn
as
select Home_Team,Home_Goals,Year from(
select *,DENSE_RANK() over (order by home_goals desc) DN
from Match) as NewTable
where DN = 1
HighGoalsIn


--===================================================================

--5)which Final match has a highest goals scored?

alter Proc Final_Highest_Goal
as
select top 1 *,Home_Goals+Away_Goals as Goals
from Match
where (Stage ='Final' or Stage = 'Final Round')
order by Goals desc

Final_Highest_Goal


--=====================================================================

--6)Most Team Won The World Cups?

create Proc Champ_Of_WC @x int
as
select * from(
select Winner ,COUNT(winner) as No_Of_Win ,DENSE_RANK() over (order by COUNT(winner) desc) as DR
from Cup
group by Winner) as NewTable
where DR = @x

Champ_Of_WC 1


--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
create function getwinner (@m int)
returns table 
as
return
select * from (
select WINNER ,count (WINNER) as no_of_win , DENSE_RANK () over (order by count (winner) desc ) dn
from cup
group by Winner)
as newtab where dn =@m
select * from dbo.getwinner(1)

--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

--The Most Teams Won The World Cups?

WITH TOP_TEAM
AS
(
SELECT Winner,COUNT(Winner) AS NUM_Winning ,DENSE_RANK()OVER(ORDER BY  COUNT(Winner) DESC) R
FROM cup
GROUP BY Winner
)

SELECT Winner, NUM_WINNING,
    CASE R 
	WHEN 1 THEN '1st'
	WHEN 2 THEN '2nd'
	WHEN 3 THEN '3rd'
	WHEN 4 THEN '4th'
	WHEN 5 THEN '5th'
	ELSE '< 5th'
	END AS Arrangement
FROM TOP_TEAM
ORDER BY NUM_WINNING DESC


--=====================================================================

--7)Which Countries Achieve The Specific Position?

create function Position(@x varchar(20)) 
returns @t table(Teams varchar(20), Year int)
as 
	begin
	   if @x='WINNER'
	     begin
	          insert into @t
	          select WINNER,year from cup
	     end
	 else if @x='RUNNERS_UP'
	 begin 
	      insert into @t
 	      select RUNNERS_UP,year from cup
	 end
	  else if @x='THIRD'
	 begin 
	      insert into @t
 	      select RUNNERS_UP,year from cup
	 end
	  else if @x='FOURTH'
	  begin
	      insert into @t
	      select Fourth ,year from cup
	  end
return
    
	end
select * from Position('winner')


--============================================================

--8)Who Win The Cup in That Year?

alter proc The_Winner @x int
as
select Winner,Year
from cup
where year = @x
The_Winner 2010


--============================================================

--9)which countries won the world cup in 2000s??

create proc The_2000s_Winners
as
select Winner,Year
from Cup
where Year >= 2000
the_2000s_winners


--===================================================================

--10)Average Goals Scored In World Cups and Who Is The Country?

WITH TOP_RATE
AS
(
SELECT ROUND(cast(Goals_Scored as float) / Matches_Played, 2) AS RATE, YEAR,
       RANK()OVER(ORDER BY ROUND(cast(Goals_Scored as float) / Matches_Played, 2) DESC) AS R, Winner
FROM cup
)
SELECT YEAR, Winner, RATE
FROM TOP_RATE
WHERE R = 1


--===================================================================

--11)Which team has played the most matches in world cup history?

alter proc Most_Matches_Played
as
SELECT Top 2 H.Team,(HMP+AMP)as Most_Matches_Played
FROM (select Home_Team as Team,count(id) as HMP from Match group by Home_Team) H,
	 (select Away_Team as Team,count(id) as AMP from Match group by Away_Team) A
WHERE H.Team = A.Team
order by Most_Matches_Played desc
Most_Matches_Played


--==========================================================================

--12)What is the highest number of goals scored by a player in a single tournament?

create proc High_Goals_Player
as
select top 1 Top_Scorer,Goals,Year
from Cup
order by Goals desc
High_Goals_Player


--==========================================================================

--13)MOST SCORED MATCH

create proc Most_Scored_Match
as
SELECT ID,Date, Home_Team,  Home_Goals , Away_Goals , Away_Team, MAX(Home_Goals + Away_Goals) AS Goals
FROM match
GROUP BY ID,Date, Home_Team, Away_Team , Home_Goals , Away_Goals
ORDER BY Goals DESC
Most_Scored_Match


--=========================================================================

--14)Top 5 Countries Scored Goals 

create proc Top5TeamsGoals
as
SELECT TOP 5 H.TEAM, h_Goals+a_Goals AS GOALS
FROM
(SELECT SUM(Home_Goals)  AS h_Goals , Home_Team AS TEAM   
FROM match
GROUP BY Home_Team) AS H, 
(SELECT  SUM(Away_Goals) AS a_Goals , Away_Team  AS TEAM  
FROM match
GROUP BY Away_Team) AS AW
WHERE H.TEAM = AW.TEAM 
ORDER BY GOALS DESC
Top5TeamsGoals


--================================================================

--15)No Of Goals For Team In Specific Stage

alter PROC Goal_Stage @STG VARCHAR(20), @Team VARCHAR(20)
AS
 DECLARE @S INT , @W INT
 SELECT @S=SUM(Home_Goals) 
 FROM match
 WHERE  Home_Team= @Team AND Stage = @STG

 SELECT @W= SUM(Away_Goals) 
 FROM match
 WHERE  Away_Team= @Team AND Stage = @STG

 SELECT @S + @W AS Goals

Goal_Stage 'Final', 'Italy'


--===================================================================

--16)Number Of Apperance Of The Team For Each Cup

create FUNCTION N_Matches_Year(@Team VARCHAR(20))
RETURNS TABLE 
AS RETURN
(
 SELECT COUNT(*) AS No_OF_APPERIANCE , Year
 FROM match
 WHERE Home_Team = @Team OR  Away_Team = @Team
 GROUP BY Year
 )

SELECT * FROM N_Matches_Year('Brazil')


--===================================================================

--17)NUMBER OF MATCHES PLAYED BY TEAM 

create FUNCTION N_Matches(@T VARCHAR(20))
RETURNS INT
BEGIN
 DECLARE @C INT
 SELECT @C = COUNT(*)  
 FROM match
 WHERE Home_Team = @T OR  Away_Team = @T
 RETURN @C
END

SELECT dbo.N_Matches('Egypt') AS No_OF_MATCHES


--==============================================================

--18)Which Country Win and Which Country Host The specific Cup?

CREATE FUNCTION GETDATA (@L INT)
RETURNS TABLE
AS
RETURN 
   SELECT Host_Country, WINNER ,Goals_Scored
   FROM CUP
   WHERE YEAR=@L

SELECT * FROM dbo.GETDATA(2002)


--==============================================================

--19)Trigger To Prevent The Update

create table AuditTableOne  (
UserName varchar(max),
ModifiedDate date,
host_Old varchar(20),
host_New varchar(20),
)

create TRIGGER up_host 
on cup
INSTEAD  OF  update
as 
if update  (host_country)
    begin 
        declare @old_ho varchar(20) , @new_ho varchar(20) 
        select @old_ho = [Host_Country] from deleted
        select @new_ho = [Host_Country]from inserted
        insert into AuditTableOne values (SUSER_NAME(),GETDATE(), @old_ho , @new_ho )
    end

update cup set Host_Country = 'Egypt'
where year = 2018

select * from AuditTableOne


--==============================================================

--20) HIGHEST SCORE MATCH

CREATE VIEW H_A_Goals
AS
SELECT ID, Home_Team, Home_Goals, Away_Goals, Away_Team FROM match

SELECT * FROM H_A_Goals

DECLARE @MAXH INT
SELECT @MAXH = MAX(Home_Goals)
FROM H_A_Goals

DECLARE @MAXAW INT
SELECT @MAXAW = MAX(Away_Goals)
FROM H_A_Goals

IF @MAXH > @MAXAW
  BEGIN
   SELECT ID, Date, Home_Team, Home_Goals , Away_Goals , Away_Team
   FROM match
   WHERE Home_Goals = @MAXH  
  END
ELSE
	BEGIN
	   SELECT ID, Date, Home_Team,  Home_Goals , Away_Goals , Away_Team
	   FROM match
	   WHERE Away_Goals = @MAXAW  
	END	


--================================================================

--21)Most Country Won In Specific Position?

CREATE PROC Top_Team (@P VARCHAR(20))
AS
IF @P = 'Winner'
 BEGIN
  WITH T
   AS
   (
     SELECT Winner,COUNT(Winner) AS NUM_Winning ,DENSE_RANK()OVER(ORDER BY  COUNT(Winner) DESC) R
     FROM cup
     GROUP BY Winner
   )
   SELECT *,
     CASE R 
	 WHEN 1 THEN '1st'
	 WHEN 2 THEN '2nd'
	 WHEN 3 THEN '3rd'
	 WHEN 4 THEN '4th'
	 WHEN 5 THEN '5th'
	 ELSE '< 5th'
	 END AS Arrangement
    FROM T
    ORDER BY NUM_Winning DESC
 END
ELSE IF @P = 'Runners_Up'
 BEGIN
   WITH T
     AS
     (
       SELECT Runners_Up,COUNT(Runners_Up) AS NUM_Winning ,DENSE_RANK()OVER(ORDER BY  COUNT(Runners_Up) DESC) R
       FROM cup
       GROUP BY Runners_Up
     )
	SELECT *,
    CASE R 
	 WHEN 1 THEN '1st'
	 WHEN 2 THEN '2nd'
	 WHEN 3 THEN '3rd'
	 WHEN 4 THEN '4th'
	 WHEN 5 THEN '5th'
	 ELSE '< 5th'
	 END AS Arrangement
    FROM T
    ORDER BY NUM_Winning DESC
 END
ELSE IF @P = 'Third'
BEGIN
   WITH T
     AS
     (
       SELECT Third,COUNT(Third) AS NUM_Winning ,DENSE_RANK()OVER(ORDER BY  COUNT(Third) DESC) R
       FROM cup
       GROUP BY Third
     )
 	SELECT *,
    CASE R 
	 WHEN 1 THEN '1st'
	 WHEN 2 THEN '2nd'
	 WHEN 3 THEN '3rd'
	 WHEN 4 THEN '4th'
	 WHEN 5 THEN '5th'
	 ELSE '< 5th'
	 END AS Arrangement
    FROM T
    ORDER BY NUM_Winning DESC
END
ELSE
BEGIN
   WITH T
     AS
     (
       SELECT Fourth,COUNT(Fourth) AS NUM_Winning ,DENSE_RANK()OVER(ORDER BY  COUNT(Fourth) DESC) R
       FROM cup
       GROUP BY Fourth
     )
	 SELECT *,
    CASE R 
	 WHEN 1 THEN '1st'
	 WHEN 2 THEN '2nd'
	 WHEN 3 THEN '3rd'
	 WHEN 4 THEN '4th'
	 WHEN 5 THEN '5th'
	 ELSE '< 5th'
	 END AS Arrangement
FROM T
ORDER BY NUM_Winning DESC
 END

 EXEC Top_Team 'third'



 select * from cup