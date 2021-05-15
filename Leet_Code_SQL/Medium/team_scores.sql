/**
Table: Teams

+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+
team_id is the primary key of this table.
Each row of this table represents a single football team.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     | 
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the teams table (team_id) and they scored host_goals and guest_goals goals respectively.
 

You would like to compute the scores of all teams after all matches. Points are awarded as follows:
A team receives three points if they win a match (Score strictly more goals than the opponent team).
A team receives one point if they draw a match (Same number of goals as the opponent team).
A team receives no points if they lose a match (Score less goals than the opponent team).
Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches. 
Result table should be ordered by num_points (decreasing order). In case of a tie, order the records by team_id (increasing order).

**/

SELECT
    t.team_id,
    t.team_name,
    SUM(CASE 
            WHEN m.host_goals > m.guest_goals AND t.team_id = m.host_team THEN 3
            WHEN m.guest_goals > m.host_goals AND t.team_id = m.guest_team THEN 3
            WHEN m.host_goals = m.guest_goals THEN 1
            ELSE 0 END
       ) num_points
FROM teams t
LEFT JOIN matches m 
ON t.team_id = m.host_team OR t.team_id = m.guest_team
GROUP BY 1, 2
ORDER BY 3 DESC, 1