# FIFA WORLD CUP
<img src="https://user-images.githubusercontent.com/47163932/235232138-8b24cb08-18cd-427e-b0ba-c7649cdac4a0.jpg">

## - Context:

<p>The FIFA World Cup is a global football competition contested by the various football-playing nations of the world. It is contested every four years and is the most prestigious and important trophy in the sport of football.<p/>


## - Content:

### FIFA WORLD CUP Data set contain 2 tables 
#### 1-	[Cup table](https://github.com/AhmedAboelkasem/FIFA-WORLD-CUP/blob/main/world_cups.csv) :
Columns ( Year, Host Country, Winner, Runners-Up, Third, Fourth, Goals Scored, Qualified Teams, Matches Played,
Top_Scorer, Goals ).
 
#### 2-	[Matches table](https://github.com/AhmedAboelkasem/FIFA-WORLD-CUP/blob/main/world_cup_matches.csv) : 
Columns (ID, Year, Date, Stage, Home Team, Home Goals, Away Goals, Away Team, Win Conditions, Host Team).

##### And [data_dictionary](https://github.com/AhmedAboelkasem/FIFA-WORLD-CUP/blob/main/Description.csv) table to describe all columns in dataset.

### ERD:

<img src="https://user-images.githubusercontent.com/47163932/235233298-bf9021cf-1cbd-4bae-bba6-f44ea0e7b732.jpeg" width="600" height="400">

### - Insights:

<p> We answered some questions …. <br>
1- Which Countries Hosted the World Cup and Won?<br>
2- which world cup has highest goals scored?<br>
3- which country scored a highest goal outside home?<br>
5- which Final match has a highest-goals scored?<br>
6- Most Team Won The World Cups.
     (The Most Teams Won The World Cups)?<br>
7- Which Countries Achieve The Specific Position?<br>
8- Who Win The Cup in That Year?<br>
9- which countries won the world cup in 2000s?<br>
10- Average Goals Scored In World Cups and Who Is The Country?<br>
11- Which team has played the most matches in world cup history?<br>
12- What is the highest number of goals scored by a player in a single tournament?<br>
13- MOST SCORED MATCH.<br>
14- Top 5 Countries Scored Goals.<br>
15- number Of Goals For Team In Specific Stage.<br>
16- Number Of Appearance Of The Team For Each Cup.<br>
17- NUMBER OF MATCHES PLAYED BY TEAM.<br>
18- Which Country Win and Which Country Host The specific Cup?<br>
19- Prevent The Update in dataset(Trigger).<br>
20- HIGHEST SCORE MATCH.<br>
21- Top Country Won In a Specific Position?<br>
<p/>

### - Tools and Technologies Used:

##### ● SQL Server 2019
##### ● Advanced SQL Queries:
  - user-defined functions:
    - ( getwinner , N_Matches_Year , Position , N_Matches , GETDATA )

  - Stored Procedures:
     - HostAndWin               - Final_Highest_Goal                - Most_Matches_Played
     - HighGoalsCup             - Champ_Of_WC                       - High_Goals_Player
     - HighGoalsOut             - The_Winner                        - Most_Scored_Match
     - HighGoalsIn              - The_2000s_Winners                 - Top5TeamsGoals
     - Goal_Stage               - Top_Team

  - Triggers ( up_host )   
  - VIEW ( H_A_Goals )
  - Window functions ( rank(), dense_rank () )
  - CTE 
  - Subquires
