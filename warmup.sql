-- The Join That Passed the Count. Run in SQLite; all data live inside this query.
-- Expected rows: Clay 12 2 24, Ink 12 0 0, Paper 9 1 9.
WITH attendance(workshop, visits) AS (
  VALUES ('Clay',12), ('Paper',9), ('Ink',12)
), rooms(workshop, room) AS (
  VALUES ('Clay','East'), ('Clay','West'), ('Paper','North')
)
SELECT a.workshop, a.visits AS recorded_visits,
       COUNT(r.room) AS room_matches,
       a.visits * COUNT(r.room) AS visits_after_inner_join
FROM attendance AS a
LEFT JOIN rooms AS r ON r.workshop = a.workshop
GROUP BY a.workshop, a.visits
ORDER BY a.workshop;

-- Try the transfer case. Two workshops each have eleven visitors.
-- One offers two touch stations. The other offers one.
-- Expected result: 2 qualifying workshops, 22 visits.
WITH attendance(session_id, visits) AS (
  VALUES (51,11), (52,11)
), stations(session_id, station_id, kind) AS (
  VALUES (51,1,'touch'), (51,2,'touch'), (52,3,'touch')
)
SELECT COUNT(*) AS qualifying_workshops, SUM(a.visits) AS visits
FROM attendance AS a
WHERE EXISTS (
  SELECT 1 FROM stations AS s
  WHERE s.session_id = a.session_id AND s.kind = 'touch'
);
