/* Problem */

/*
Julia just finished conducting a coding contest, and she needs your help 
assembling the leaderboard! Write a query to print the respective hacker_id 
and name of hackers who achieved full scores for more than one challenge. 
Order your output in descending order by the total number of challenges in 
which the hacker earned a full score. If more than one hacker received full 
scores in same number of challenges, then sort them by ascending hacker_id.
*/

/* Solution */

SELECT 
    s.hacker_id, h.name
FROM 
    Hackers AS h
JOIN 
    Submissions AS s
ON 
    h.hacker_id = s.hacker_id
JOIN 
    Challenges c
ON 
    s.challenge_id = c.challenge_id
JOIN 
    Difficulty d
ON 
    d.difficulty_level = c.difficulty_level
WHERE 
    s.score = d.score
GROUP BY 
    s.hacker_id, h.name
hAVING 
    COUNT(*) > 1
ORDER BY 
    COUNT(*) DESC, s.hacker_id